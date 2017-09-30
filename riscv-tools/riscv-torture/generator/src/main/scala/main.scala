package torture
package generator

import scopt.OptionParser
import java.io.FileWriter
import java.io.FileInputStream
import java.util.Properties
import scala.collection.JavaConversions._

case class Options(var outFileName: String = "test",
  var confFileName: String = "config/default.config")

object Generator extends App
{
  override def main(args: Array[String]) =
  {
    val parser = new OptionParser[Options]("generator/run") {
      opt[String]('C', "config") valueName("<file>") text("config file") action {(s: String, c) => c.copy(confFileName = s)}
      opt[String]('o', "output") valueName("<filename>") text("output filename") action {(s: String, c) => c.copy(outFileName = s)}
    }
    parser.parse(args, Options()) match {
      case Some(opts) =>
        generate(opts.confFileName, opts.outFileName)
      case None =>
        System.exit(1) //error message printed by parser
    }
  }

  def generate(confFile: String, outFileName: String): String = {
    val config = new Properties()
    val in = new FileInputStream(confFile)
    config.load(in)
    in.close()
    val nseqs   = config.getProperty("torture.generator.nseqs", "1000").toInt
    val memsize = config.getProperty("torture.generator.memsize", "1024").toInt
    val fprnd   = config.getProperty("torture.generator.fprnd", "0").toInt
    val use_amo = (config.getProperty("torture.generator.amo", "true").toLowerCase == "true")
    val use_mul = (config.getProperty("torture.generator.mul", "true").toLowerCase == "true")
    val use_div = (config.getProperty("torture.generator.divider", "true").toLowerCase == "true")
    val mix     = config.filterKeys(_ contains "torture.generator.mix").map { case (k,v) => (k.split('.')(3), v.toInt) }.asInstanceOf[Map[String,Int]]
    val vec     = config.filterKeys(_ contains "torture.generator.vec").map { case (k,v) => (k.split('.').drop(3).reduce(_+"."+_), v) }.asInstanceOf[Map[String,String]]
    val segment = (config.getProperty("torture.generator.segment", "true").toLowerCase == "true")
    val loop    = (config.getProperty("torture.generator.loop", "true").toLowerCase == "true")
    val loop_size = config.getProperty("torture.generator.loop_size", "256").toInt
    generate(nseqs, memsize, fprnd, mix, vec, use_amo, use_mul, use_div, outFileName, segment, loop, loop_size)
  }

  def generate(nseqs: Int, memsize: Int, fprnd : Int, mix: Map[String,Int], veccfg: Map[String,String], use_amo: Boolean, use_mul: Boolean, use_div: Boolean, outFileName: String, segment : Boolean, loop : Boolean, loop_size : Int): String = {
    assert (mix.values.sum == 100, println("The instruction mix specified in config does not add up to 100%"))
    assert (mix.keys.forall(List("xmem","xbranch","xalu","fgen","fpmem","fax","fdiv","vec","cxmem","cxbranch","cxalu") contains _), println("The instruction mix specified in config contains an unknown sequence type name"))

    val vmemsize = veccfg.getOrElse("memsize", "32").toInt
    val vnseq = veccfg.getOrElse("seq", "100").toInt
    val vfnum = veccfg.getOrElse("vf", "10").toInt
    val vecmix = veccfg.filterKeys(_ contains "mix.").map { case (k,v) => (k.split('.')(1), v.toInt) }.asInstanceOf[Map[String,Int]]
    assert (vecmix.values.sum == 100, println("The vector instruction mix specified in config does not add up to 100%"))
    assert (vecmix.keys.forall(List("vmem","valu","vpop","vonly") contains _), println("The vector instruction mix specified in config contains an unknown sequence type name"))

    val prog = new Prog(memsize, veccfg, loop)
    ProgSeg.cnt = 0
    SeqVec.cnt = 0
    val s = prog.generate(nseqs, fprnd, mix, veccfg, use_amo, use_mul, use_div, segment, loop, loop_size)

    val oname = "output/" + outFileName + ".S"
    val fw = new FileWriter(oname)
    fw.write(s)
    fw.close()
    val stats = prog.statistics(nseqs,fprnd,mix,vnseq,vmemsize,vfnum,vecmix,use_amo,use_mul,use_div)
    val sname = "output/" + outFileName + ".stats"
    val fw2 = new FileWriter(sname)
    fw2.write(stats)
    fw2.close()
    oname
  }
}

