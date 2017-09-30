package torture
package fileop

import scala.sys.process._
import scalax.file.Path
import scalax.file.FileSystem
import java.io.File

object FileOperations extends App
{
  override def main(args: Array[String]) = { System.exit(0) }

  def compile(dir: Path, compiledFile: Path) =
  {
    val workDir = new File(dir.toAbsolute.normalize.path)
    Process("make -j", workDir).!
    if (!compiledFile.exists) Process("make -j", workDir).!
  }
  
  def compileRemote(dir: Path, compiledFile: Path, host: String, options: String) =
  {
    val sshcmd = "ssh " + options + " " + host + " cd " + dir.path + " ; make -j"
    println(sshcmd)
    Process(sshcmd).!
    if (!remotePathExists(compiledFile, host, options)) Process(sshcmd).!
  }
 
  def clean(dir: Path) = 
  {
    val workDir = new File(dir.toAbsolute.normalize.path)
    Process("make clean", workDir).!
  }

  def cleanRemote(dir: Path, host: String, options: String) =
  {
    val sshcmd = "ssh " + options + " " + host + " cd " + dir.path + " ; make clean"
    println(sshcmd)
    Process(sshcmd).!
  }

  def gitcheckout(oldDir: Path, newDir: Path, commit: String): Unit =
  {
    val canonold = oldDir.toAbsolute.normalize.path
    val canonnew = newDir.toAbsolute.normalize.path
    if (newDir.exists) return
    Process("cp -r " + canonold + " " + canonnew).!
    if (commit.toLowerCase != "none")
    {
      println("Checking out commit " + commit + " in " + canonnew)
      val out = Process("git checkout " + commit, new File(canonnew)).!!
      println(out)
    }
  }

  def gitcheckoutRemote(oldDir: Path, newDir: Path, commit: String, host: String, options: String) =
  {
    if (!remotePathExists(newDir, host, options))
    {
      val sshcmd = "ssh " + options + " " + host + " cp -r " + oldDir.path + " " + newDir.path
      Process(sshcmd).!
      if (commit.toLowerCase != "none")
      {
        val sshgitcheckout = "ssh " + options + " " + host + " cd " + newDir.path + " ; git checkout " + commit
        println(sshgitcheckout)
        println(Process(sshgitcheckout).!!)
      }
    }
  }

  def remotePathExists(remote: Path, host: String, options: String): Boolean =
  {
    val remoteParentPath = remote.parent.get
    val cmd = ("ssh "+options+" "+host+" ls " + remoteParentPath.path)
    val output = (cmd.!!).split("\n")
    val remoteExists = output.contains(remote.name)
    remoteExists
  }

  def copy(from: Path, to: Path): Unit = 
  {
    from.copyTo(to, replaceExisting=true)
  }

  def scpFileBack(remotePath: Path, localPath: Path, host: String, options: String): Unit =
  {
    val localStr = localPath.path
    val remoteStr = remotePath.path
    if (remotePathExists(remotePath, host, options))
    {
      println("Copying remote file " + remotePath.name + " from " + host + "to directory " + localStr)
      val cmd = "scp " +options+" "+host+":"+remoteStr + " " + localStr
      println(cmd)
      val exitCode = cmd.!
      assert(exitCode == 0, println("SCP failed to successfully copy file " + localPath.name))
      println("Successfully copied remote " + host + " file to directory.\n")
    } else {
      println("Could not find remote file " + remoteStr + " on " + host)
    }
  }

  def scp(localPath: Path, remotePath: Path, host: String, options: String): Unit = 
  {
    def scpFile(localPath: Path, remotePath: Path): Unit = 
    {
      val localStr = localPath.path
      val remoteStr = remotePath.path
      println("Copying file " + localPath.name + " to " + host + " remote directory " + remoteStr)
      val cmd = "scp " +options+" "+localStr+" "+host+":"+remoteStr
      println(cmd)
      val exitCode = cmd.!
      assert(exitCode == 0, println("SCP failed to successfully copy file " + localPath.name))
      println("Successfully copied file to remote "+host+" directory.\n")
    }
    def compressDir(dir: String, tgz: String): Unit = 
    {
      println("Compressing directory to " + tgz)
      val tarcmd = "tar -czf " + tgz + " " + dir
      println(tarcmd)
      val out = tarcmd.!
      assert (out == 0, println("Failed to properly compress directory."))
      println("Successfully compressed directory to " + tgz + "\n")
    }
    def extractDir(remoteTgz: String, remoteDir: String): Unit = 
    {
      println("Extracting "+remoteTgz+" to "+host+" remote directory " + remoteDir)
      val extractcmd = "ssh "+options+" "+host+" tar -xzf " + remoteTgz +" -C " + remoteDir
      println (extractcmd)
      val out = extractcmd.!
      assert (out == 0, println("Failed to extract remote file " + remoteTgz + " to directory " + remoteDir))
      println("Successfully extracted to remote directory " + remoteDir + "\n")
    }

    assert(localPath.exists, println("Local object to be copied does not exist."))
    if (localPath.isDirectory)
    {
      //Zip it up, scp it, then unzip
      val canonPath: Path = localPath.toAbsolute.normalize
      val remoteParentPath = remotePath.parent.get
      val tgzName = canonPath.name + ".tgz"
      val tgzPath: Path = Path.fromString("../" + tgzName)
      val remoteTgzPath: Path = (remoteParentPath / Path.fromString(tgzName))

      val cmd = ("ssh "+options+" "+host+" ls " + remoteParentPath.path)
      val output = (cmd.!!).split("\n")
      val remoteExists = output.contains(remotePath.name)
      val remoteTgzExists = output.contains(tgzName)

      if (remoteExists) {
        println("Remote directory already exists. Skipping copy process.")
      } else {
        if (remoteTgzExists) {
          println(tgzName + " already exists on the remote "+host+" directory. Skipping transfer process.")
        } else {
          if(!tgzPath.exists) {
            compressDir(".", "../"+tgzName)
          } else {
            println(tgzName+" already exists. Skipping compression process.")
          }  
          scpFile(tgzPath, remoteTgzPath)
        }
        val out2 = ("ssh "+options+" "+host+" mkdir " + remotePath.path).!!
        extractDir(remoteTgzPath.path, remotePath.path)
      }
    } else {
      scpFile(localPath, remotePath)
    }
  }
}
