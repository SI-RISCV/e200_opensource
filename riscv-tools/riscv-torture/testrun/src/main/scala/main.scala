package torture
package testrun

import scopt.OptionParser
import scala.sys.process._
import scala.collection.mutable.ArrayBuffer
import java.io.FileWriter
import java.util.Properties
import java.io.FileInputStream
import java.util.Scanner
import java.io.File
import scala.util.Random

case class Options(var testAsmName: Option[String] = None,
  var testBinName: Option[String] = None,
  var cSimPath: Option[String] = None,
  var rtlSimPath: Option[String] = None,
  var seekOutFailure: Boolean = false,
  var output: Boolean = false,
  var dumpWaveform: Boolean = false,
  var confFileName: String = "config/default.config")

abstract sealed class Result
case object Failed extends Result
case object Mismatched extends Result
case object Matched extends Result

object TestRunner extends App
{
  var opts = new Options()
  override def main(args: Array[String]) =
  {
  //TODO: need to make the class Options above look like the new website should get us to remove the options!
    val parser = new OptionParser[Options]("testrun/run") {
      opt[String]('C', "config") valueName("<file>") text("config file") action {(s: String, c) => c.copy(confFileName = s)}
      opt[String]('a', "asm") valueName("<file>") text("input ASM file") action {(s: String, c) => c.copy(testAsmName = Some(s))}
      opt[String]('c', "csim") valueName("<file>") text("C simulator") action {(s: String, c) => c.copy(cSimPath = Some(s))}
      opt[String]('r', "rtlsim") valueName("<file>") text("RTL simulator") action {(s: String, c) => c.copy(rtlSimPath = Some(s))}
      opt[Unit]("seek") abbr("s") text("Seek for failing pseg") action {(_, c) => c.copy(seekOutFailure = true)}
      opt[Unit]("output") abbr("o") text("Write verbose output of simulators to file") action {(_, c) => c.copy(output = true)}
      opt[Unit]("dumpwaveform") abbr("dump") text("Create a vcd from csim or a vpd from vsim") action {(_, c) => c.copy(dumpWaveform= true)}
    }
    parser.parse(args, Options()) match {
      case Some(options) =>
      {
        opts = options;
        testrun(opts.testAsmName, opts.cSimPath, opts.rtlSimPath, opts.seekOutFailure, opts.output, opts.dumpWaveform, opts.confFileName) 
      }
      case None =>
        System.exit(1) // error message printed by parser
    }
  }

  var virtualMode = false
  var maxcycles = 10000000
  var hwacha = true

  def testrun(testAsmName:  Option[String], 
              cSimPath:     Option[String], 
              rtlSimPath:   Option[String], 
              doSeek:       Boolean,
              output:       Boolean,
              dumpWaveform: Boolean,
              confFileName: String): (Boolean, Option[Seq[String]]) =
  {

    val config = new Properties()
    val configin = new FileInputStream(confFileName)
    config.load(configin)
    configin.close()

    maxcycles = config.getProperty("torture.testrun.maxcycles", "10000000").toInt
    virtualMode = (config.getProperty("torture.testrun.virtual", "false").toLowerCase == "true")
    val dump = (config.getProperty("torture.testrun.dump", "false").toLowerCase == "true")
    val seek = (config.getProperty("torture.testrun.seek", "true").toLowerCase == "true")
    hwacha = (config.getProperty("torture.testrun.vec", "true").toLowerCase == "true")

    // Figure out which binary file to test
    val finalBinName = testAsmName match {
      case Some(asmName) => compileAsmToBin(asmName)
      case None => {
        val gen = generator.Generator
        val newAsmName = gen.generate(confFileName, "test")
        compileAsmToBin(newAsmName)
      }
    }

    // Add the simulators that should be tested
    val simulators = new ArrayBuffer[(String, (String, Boolean, Boolean, Boolean) => String)]
    simulators += (("spike",runIsaSim _ ))
    cSimPath match { 
      case Some(p) => simulators += (("csim",runCSim(p) _ ))
      case None =>
    }
    rtlSimPath match { 
      case Some(p) => simulators += (("rtlsim",runRtlSim(p) _ ))
      case None => 
    }

    // Test the simulators on the complete binary
    finalBinName match {
      case Some(binName) => {
      val res = runSimulators(binName, simulators, false, output, dumpWaveform || dump)
        val fail_names = res.filter(_._3 == Failed).map(_._1.toString)
        val mism_names = res.filter(_._3 == Mismatched).map(_._1.toString)
        val bad_sims  = res.filter(_._3 != Matched).map(_._2)
        if (bad_sims.length > 0) {
          println("///////////////////////////////////////////////////////")
          println("//  Simulation failed for " + binName + ":")
          fail_names.foreach(n => println("\t"+n))
          println("//  Mismatched sigs for " + binName + ":")
          mism_names.foreach(n => println("\t"+n))
          println("//  Rerunning in Debug mode")
          // run debug for failed/mismatched
          val resDebug = runSimulators(binName, simulators, true, output, dumpWaveform || dump)
          println("///////////////////////////////////////////////////////")
          if(doSeek || seek) {
            val failName = seekOutFailureBinary(binName, bad_sims, true, output, dumpWaveform || dump)
            println("///////////////////////////////////////////////////////")
            println("//  Failing pseg identified. Binary at " + failName)
            println("///////////////////////////////////////////////////////")
            dumpFromBin(failName)
            (true, Some(failName.split("/")))
          } else {
            dumpFromBin(binName)
            (true, Some(binName.split("/")))
          }
        } else {
          println("///////////////////////////////////////////////////////")
          println("//  All signatures match for " + binName)
          println("///////////////////////////////////////////////////////")
          (false, Some(binName.split("/")))
        }
      }
      case None => {
        println("Error: ASM file could not be compiled or generated.")
        (false, None)
      }
    }
  }

  def compileAsmToBin(asmFileName: String): Option[String] = {  
    assert(asmFileName.endsWith(".S"), println("Filename does not end in .S"))
    val binFileName = asmFileName.dropRight(2)
    var process = ""
    if (virtualMode)
    {
      println("Virtual mode")
      val entropy = (new Random()).nextLong()
      println("entropy: " + entropy)
      process = "riscv64-unknown-elf-gcc -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -Wa,-march=rv64imafd -DENTROPY=" + entropy + " -std=gnu99 -O2 -I./env/v -I./macros/scalar -T./env/v/link.ld ./env/v/entry.S ./env/v/vm.c " + asmFileName + " -lc -o " + binFileName
    }
    else
    {
      println("Physical mode")
      process = "riscv64-unknown-elf-gcc -nostdlib -nostartfiles -Wa,-march=rv64imafd -I./env/p -T./env/p/link.ld " + asmFileName + " -o " + binFileName
    }
    val pb = Process(process)
    val exitCode = pb.!
    if (exitCode == 0) Some(binFileName) else None
  }

  def dumpFromBin(binFileName: String): Option[String] = {
    val dumpFileName = binFileName + ".dump"
    val pd = Process("riscv64-unknown-elf-objdump --disassemble-all --section=.text --section=.data --section=.bss " + binFileName)
    val dump = pd.!!
    val fw = new FileWriter(dumpFileName)
    fw.write(dump)
    fw.close()
    Some(dumpFileName)
  }
  def generateHexFromBin(binFileName: String) = {
    import java.io.File
    // Determine binary size
    val binfile = new File(binFileName)
    
    val hexlines = 2 << (Math.log(binfile.length >>> 4)/Math.log(2)+1).toInt

    val hexFileName = binFileName + ".hex"
    val pd = Process("elf2hex 16 "+hexlines+" " + binFileName)
    val hexdump = pd.!!

    val fw = new FileWriter(hexFileName)
    fw.write(hexdump)
    fw.close()

    hexFileName
  }

  def runSim(sim: String, simargs: Seq[String], signature: String, output: Boolean, outName: String, args: Seq[String], invokebin: String): String = {
    val cmd = Seq(sim) ++ simargs ++ Seq("+signature="+signature) ++ args ++ Seq(invokebin)
    println("running:"+cmd)
    if(output) {
      var fw = new FileWriter(outName+".raw")
      cmd ! ProcessLogger(
         {s => fw.write(s+"\n") },
         {s => fw.write(s+"\n") })
      fw.close()
      val fwd = new FileWriter(outName)
      Process(Seq("cat",outName+".raw")) #| Process("spike-dasm --extension=hwacha") ! ProcessLogger(
         {s => fwd.write(s+"\n") },
         {s => fwd.write(s+"\n") })
      fwd.close()
      new File(outName+".raw").delete()
    } else {
      cmd !!
    }
    val sigFile = new File(signature)
    if(!sigFile.exists()) ""
    else new Scanner(sigFile).useDelimiter("\\Z").next()
  }

  def runCSim(sim: String)(bin: String, debug: Boolean, output: Boolean, dump: Boolean): String = {
    val outputArgs = if(output) Seq("+verbose") else Seq()
    val dumpArgs = if(dump && debug) Seq("-v"+bin+".vcd") else Seq()
    val debugArgs = if(debug) outputArgs ++ dumpArgs else Seq()
    val simArgs = Seq("+max-cycles="+maxcycles) ++ debugArgs
    val simName = sim
    runSim(simName, Seq(), bin+".csim.sig", output, bin+".csim.out", simArgs, bin)
  }

  def runRtlSim(sim: String)(bin: String, debug: Boolean, output: Boolean, dump: Boolean): String = {
    val outputArgs = if(output) Seq("+verbose") else Seq()
    val dumpArgs = if(dump && debug) Seq("+vcdplusfile="+bin+".vpd") else Seq()
    val debugArgs = if(debug) outputArgs ++ dumpArgs else Seq()
    val simArgs = Seq("+max-cycles="+maxcycles) ++ debugArgs
    val simName = sim
    runSim(simName, Seq(), bin+".rtlsim.sig", output, bin+".rtlsim.out", simArgs, bin)
  }

  def runIsaSim(bin: String, debug: Boolean, output: Boolean, dump: Boolean): String = {
    val debugArgs = if(debug && output) Seq("-d") else Seq()
    val simArgs = if (hwacha) Seq("--extension=hwacha") else Seq()
    runSim("spike", simArgs ++ debugArgs, bin+".spike.sig", output, bin+".spike.out", Seq(), bin)
  }

  def runSimulators(bin: String, simulators: Seq[(String, (String, Boolean, Boolean, Boolean) => String)], debug: Boolean, output: Boolean, dumpWaveform: Boolean): Seq[(String, (String, (String, Boolean, Boolean, Boolean) => String), Result)] = {
    if(simulators.length == 0) println("Warning: No simulators specified for comparison. Comparing ISA to ISA...")
    val isa_sig = runIsaSim(bin, debug, output, false)
    simulators.map { case (name, sim) => {
      val res =
        try {
        if (isa_sig != sim(bin, debug, output, dumpWaveform)) Mismatched
          else Matched
        } catch {
          case e:RuntimeException => Failed
        }
      (name, (name, sim), res)
    } }
  }

  def seekOutFailureBinary(bin: String, simulators: Seq[(String, (String, Boolean, Boolean, Boolean) => String)], debug: Boolean, output: Boolean, dumpWaveform: Boolean): String =
  {
    // Find failing asm file
    val source = scala.io.Source.fromFile(bin+".S")
    val lines = source.mkString
    source.close()

    // For all psegs
    val psegFinder = """pseg_\d+""".r
    val psegNums: List[Int] = psegFinder.findAllIn(lines).map(_.drop(5).toInt).toList
    var (low, high) = (psegNums.min, psegNums.max)
    if (low == high) 
    {
      println("Only one pseg was detected.")
      return bin
    }
    var lastfound = ""
    while (low <= high)
    {
      val p = (high + low)/2
      // Replace jump to pseg with jump to reg_dump
      val psegReplacer = ("pseg_" + p + ":\\n").r
      val newAsmSource = psegReplacer.replaceAllIn(lines, "pseg_" + p + ":\n\tj reg_dump\n")
      val newAsmName = bin + "_pseg_" + p + ".S"
      val fw = new FileWriter(newAsmName)
      fw.write(newAsmSource)
      fw.close()

      // Compile new asm and test on sims
      val newBinName = compileAsmToBin(newAsmName)
      newBinName match {
        case Some(b) => {
          val res = runSimulators(b, simulators, debug, output, dumpWaveform)
          if (!res.forall(_._3 == Matched)) {
            lastfound = b
            high = p-1
          } else {
            low = p+1
          }
        }
        case None => println("Warning: Subset test could not compile.")    
      }
    }
    if (lastfound == "") {
      println("Warning: No subset tests could compile.")
      bin
    } else {
      lastfound 
    }
  }

  def seekOutFailure(bin: String, simulators: Seq[(String, (String, Boolean, Boolean, Boolean) => String)], debug: Boolean, output: Boolean, dumpWaveform: Boolean): String = {
    // Find failing asm file
    val source = scala.io.Source.fromFile(bin+".S")
    val lines = source.mkString
    source.close()

    // For all psegs
    val psegFinder = """pseg_\d+""".r
    val psegNums: List[Int] = psegFinder.findAllIn(lines).map(_.drop(5).toInt).toList
    if (psegNums.min == psegNums.max) 
    {
      println("Only one pseg was detected.")
      return bin
    }
    for( p <- psegNums.min to psegNums.max) {
      // Replace jump to pseg with jump to reg_dump
      val psegReplacer = ("pseg_" + p + ":\\n").r
      val newAsmSource = psegReplacer.replaceAllIn(lines, "pseg_" + p + ":\n\tj reg_dump\n")
      val newAsmName = bin + "_pseg_" + p + ".S"
      val fw = new FileWriter(newAsmName)
      fw.write(newAsmSource)
      fw.close()

      // Compile new asm and test on sims
      val newBinName = compileAsmToBin(newAsmName)
      newBinName match {
        case Some(b) => {
        val res = runSimulators(b, simulators, debug, output, dumpWaveform)
          if (!res.forall(_._3 == Matched)) {
            return b
          }
        }
        case None => println("Warning: Subset test could not compile.")    
      }
    }
    println("Warning: No subset tests could compile.")
    bin
  } 

}

