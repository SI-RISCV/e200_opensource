package torture

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import Rand._
import java.util.Date
import java.text.DateFormat

class ProgSeg(val name: String)
{
  var insts = new ArrayBuffer[Inst]

  override def toString = ((name + ":\n") /: insts.map((x) => "\t" + x + "\n"))(_ + _)
}

object ProgSeg
{
  var cnt = 0

  def apply() =
  {
    val res = new ProgSeg("pseg_" + cnt)
    cnt += 1
    res
  }
}

class Prog(memsize: Int, veccfg: Map[String,String], loop : Boolean)
{
  // Setup scalar core memory
  val core_memory = new Mem("test_memory", memsize)

  // Setup register pools
  val num_vxregs = rand_range(5, 256)
  val use_pop = veccfg.getOrElse("pop", "true") == "true"
  val pred_alu = veccfg.getOrElse("pred_alu", "true") == "true"
  val pred_mem = veccfg.getOrElse("pred_mem", "true") == "true"
  val min_pregs   = if(pred_alu || pred_mem || use_pop) 2 else 1
  val num_vpregs = rand_range(min_pregs, 16)
  val num_vsregs = veccfg.getOrElse("numsregs","64").toInt
  val max_vl = (Math.floor(256/(num_vxregs-1))).toInt * 8
  val used_vl = Math.min(max_vl, rand_range(1, max_vl))

  val xregs = new XRegsPool()
  val fregs = new FRegsMaster()
  val vregs = new VRegsMaster(num_vxregs, num_vpregs, num_vsregs)

  val fregpools = fregs.extract_pools()
  val vregpools = vregs.extract_pools()
  val (fregs_s, fregs_d) = (fregpools(0), fregpools(1))
  val (vxregs, vpregs, vsregs, varegs) = (vregpools(0), vregpools(1), vregpools(2), vregpools(3))

  val seqs = new ArrayBuffer[InstSeq]
  val seqs_active = new ArrayBuffer[InstSeq]
  val progsegs = new ArrayBuffer[ProgSeg]

  var killed_seqs = 0
  var nseqs = 0
  var prob_tbl = new ArrayBuffer[(Int, ()=>InstSeq)]

  val opstats = new HashMap[String, scala.collection.mutable.Map[String,Int]]
  val catstats = new HashMap[String,Int]
  val seqstats = new HashMap[String,Int].withDefaultValue(0)
  val vseqstats = new HashMap[String,Int].withDefaultValue(0)
  val regstats = new HashMap[String,Int].withDefaultValue(0)
  for (cat <- List(("alu"),("cmp"),("branch"),("jalr"),
    ("jmp"),("la"),("mem"),("amo"),("misc"),("fpalu"),("fpcmp"),
    ("fpfma"),("fpmem"),("fpcvt"),("fpmisc"),("vmem"),("vamo"),("valu"),
    ("vmisc"),("vfpalu"),("vfpfma"),("vfpcvt"),("vsmem"),("vshared"),("vpred"),("vcmp"),("unknown")))
    {
      catstats(cat)=0
      opstats(cat) = new HashMap[String,Int].withDefaultValue(0)
    }
  var instcnt = 0

  def seqs_not_allocated = seqs.filter((x) => !x.allocated)
  def is_seqs_empty = seqs_not_allocated.length == 0
  def is_seqs_active_empty = seqs_active.length == 0

  def are_pools_fully_unallocated = List(xregs, fregs_s, fregs_d, vxregs, vpregs, vsregs, varegs).forall(_.is_fully_unallocated)

  def seqs_find_active(): Unit =
  {
    for (seq <- seqs_not_allocated)
    {
      xregs.backup()
      fregs.backup()
      vregs.backup()

      if (seq.allocate_regs())
      {
        seqs_active += seq
      }
      else
      {
        if (are_pools_fully_unallocated)
        {
          seqs -= seq
          killed_seqs += 1
          seqstats(seq.seqname) -= 1
          if (seq.seqname == "vec")
          {
            for ((seqname, seqcnt) <- seq.asInstanceOf[SeqVec].vseqstats)
            {
              vseqstats(seqname) = seqcnt
            }
          }
          if (killed_seqs < (nseqs*5))
            gen_seq()
        }
        xregs.restore()
        fregs.restore()
        vregs.restore()

        return
      }
    }
  }

  var jalr_labels = new ArrayBuffer[Label]

  def update_stats(inst: Inst) =
  {
    catstats(inst.optype) += 1
    opstats(inst.optype)(inst.opcode) += 1
    for (operand <- inst.operands)
    {
      if (operand.isInstanceOf[Reg])
      {
        regstats(operand.toString) += 1
      }
    }
    instcnt += 1
  }

  def register_stats(): String =
  {
    def register_lt(reg1: (String, Int), reg2: (String, Int)): Boolean =
    {
      val reghash = HashMap('x'->1,'f'->2,'v'->3,'p'->4,'s'->5,'a'->6)
      val regname1 = reg1._1
      val regname2 = reg2._1
      if (reghash(regname1(0)) == reghash(regname2(0)))
      {
        if (regname1(0) == 'v')
        {
          if (regname1(1) == regname2(1))
          {
            return (regname1.substring(2).toInt < regname2.substring(2).toInt)
          } else {
            return (reghash(regname1(1)) < reghash(regname2(1)))
          }
        } else {
          return (regname1.substring(1).toInt < regname2.substring(1).toInt)
        }
      } else {
        return (reghash(regname1(0)) < reghash(regname2(0)))
      }
    }
  
    val sortedRegs = regstats.toSeq.sortWith(register_lt) //TODO: Better way to sort?
    var s = "---------- Register Accesses ----------\n"
    for ((regname, cnt) <- sortedRegs)
    {
      s += "---------- " + regname + ": " + cnt + " ----------\n"
    }
    s
  }

  def sequence_stats(mix: Map[String, Int], vecmix: Map[String, Int], nseqs: Int, vnseq: Int, vfnum: Int): String = 
  {  
    def seq_lt(seq1: (String, Int), seq2: (String, Int)): Boolean =
    {
      val seqhash = HashMap("xmem"->1,"xbranch"->2,"xalu"->3,"vmem"->4, 
      "fgen"->5,"fpmem"->6,"fax"->7,"fdiv"->8,"vec"->9,"vonly"->10,"valu"->11,"Generic"->12,"cxmen"->13,"cxbranch"->14,"cxalu"->15).withDefaultValue(100)
      if (seqhash(seq1._1) == 100 && seqhash(seq2._1) == 100) return (seq1._1 < seq2._1)
      return seqhash(seq1._1) < seqhash(seq2._1)
    }
   
    val sortedMix = mix.toSeq.sortWith(seq_lt)
    val sortedVecmix = vecmix.toSeq.sortWith(seq_lt)
    var s = "----- Sequence Types Used:"
    for ((seqtype,percent) <- sortedMix) if (percent > 0) s += " " + seqtype.toUpperCase
    s += " -----\n"
    s += "--------------------------------------------------------------------------\n"
    s += "---------- Configured Sequence Mix ----------\n"
    for ((seqtype, percent) <- sortedMix)
    {
      s += "---------- " + seqtype + ": " + percent + "% ----------\n"
    }
    s += "--------------------------------------------------------------------------\n"
    s += "---------- Configured Vector Sequence Mix ----------\n"
    for ((seqtype, percent) <- sortedVecmix)
    {
      s+= "---------- " + seqtype + ": " + percent + "% ----------\n"
    }
    s += "--------------------------------------------------------------------------\n"
    s += "---------- Generated Sequence Mix ----------\n"
    s += "---------- nseqs = " + nseqs + " -------------\n"
    val sortedSeqs = seqstats.toSeq.sortWith(seq_lt)
    for ((seq, seqcnt) <- sortedSeqs)
    {
      s += "---------- " + seq + ": " + seqcnt + " :: %3.3f".format((seqcnt.toDouble/nseqs)*100)
      s += "% ----------\n"
    }
    s += "--------------------------------------------------------------------------\n"
    s += "---------- Generated Vector Sequence Mix ----------\n"
    s += "---------- nvseqs = " + vnseq*vfnum*seqstats("vec") + " -------------\n"
    val sortedVSeqs = vseqstats.toSeq.sortWith(seq_lt)
    for ((vseq, vseqcnt) <- sortedVSeqs)
    {
      s += "---------- " + vseq + ": " + vseqcnt
      s += " :: %3.3f".format((vseqcnt.toDouble/(vnseq*vfnum*seqstats("vec")))*100)
      s += "% ----------\n"
    }
    s
  }
  
  def instruction_stats(): String = 
  {
    def cat_lt(cat1: (String, Int), cat2: (String, Int)): Boolean =
    {
      val cathash = HashMap("alu"->1,"cmp"->2,"branch"->3,"jmp"->4,"jalr"->5,
        "la"->6,"mem"->7,"amo"->8,"misc"->9,"fpalu"->10,"fpcmp"->11,"fpfma"->12,
        "fpmem"->13,"fpcvt"->14,"fpmisc"->15,"vmem"->16,"vamo"->17,"valu"->18,"vfpalu"->19,
        "vfpfma"->20,"vfpcvt"->21,"vsmem"->22,"vshared"->23,"vpred"->24,"vcmp"->25,"vmisc"->26,"unknown"->27)
      return cathash(cat1._1) < cathash(cat2._1)
    }

    var s = "---------- Opcode Usage ----------\n"
    s += "---------- instcnt = " + instcnt + " -------------\n"
    val sortedCats = catstats.toSeq.sortWith(cat_lt) // TODO: Better way to sort?
    for ((cat, catcnt) <- sortedCats)
    {
      val sortedOps = opstats(cat).toSeq.sortWith(_._1 < _._1)  //TODO: Better way to sort?
      s += "--------------------------------------------------------------------------\n"
      s += "---------- " + cat.toUpperCase() + " Opcodes: " + catcnt + " :: %3.3f".format((catcnt.toDouble/instcnt)*100)
      s +=  "% ----------\n"
      for ((op, opcnt) <- sortedOps)
      {
        s += "-------------------- " + op + ": " + opcnt + " :: %3.3f".format((opcnt.toDouble/instcnt)*100)
        s += "% ----------\n"
      }
    }
    s
  }

  def get_time(): String =
  {
    val date = new Date()
    val datestr = DateFormat.getDateTimeInstance(DateFormat.FULL, DateFormat.FULL).format(date)
    "----- Test generated on " + datestr + " -----\n"
  }

  def gen_seq(): Unit =
  {
    val nxtseq = InstSeq(prob_tbl)
    seqs += nxtseq
    seqstats(nxtseq.seqname) += 1
    if (nxtseq.seqname == "vec")
    {
      for ((seqname, seqcnt) <- nxtseq.asInstanceOf[SeqVec].vseqstats)
      {
        vseqstats(seqname) += seqcnt
      }
    }
  }

  def add_inst(inst: Inst) =
  {
    if (progsegs.length == 0)
      progsegs += ProgSeg()

    progsegs.last.insts += inst

    val branch_filter = (x: Operand) =>
      x.isInstanceOf[Label] && x.asInstanceOf[Label].label.indexOf("branch_patch") != -1
    val branch_patch = inst.operands.indexWhere(branch_filter)
    if (branch_patch != -1)
    {
      progsegs.last.insts += ILLEGAL(Label("0x%08x" format rand_word))
      progsegs += ProgSeg()
      inst.operands(branch_patch) = Label(progsegs.last.name)
    }

    val jalr_filter = (x: Operand) =>
      x.isInstanceOf[Label] && x.asInstanceOf[Label].label.indexOf("jalr_patch2") != -1
    val jalr_patch = inst.operands.indexWhere(jalr_filter)
    if (jalr_patch != -1)
    {
      progsegs.last.insts += ILLEGAL(Label("0x%08x" format rand_word))
      progsegs += ProgSeg()
      jalr_labels += Label(progsegs.last.name)
      inst.operands(jalr_patch) = Imm(0)
    }
    update_stats(inst)
  }

  def resolve_jalr_las =
  {
    var jalr_count = 0
    val jalr_la_filter = (x: Operand) =>
      x.isInstanceOf[Label] && x.asInstanceOf[Label].label.indexOf("jalr_patch1") != -1
    for (progseg <- progsegs)
    {
      for (inst <- progseg.insts)
      {
        val jalr_la_patch = inst.operands.indexWhere(jalr_la_filter)
        if (jalr_la_patch != -1) {
          inst.operands(jalr_la_patch) = jalr_labels(jalr_count)
          jalr_count += 1
        }
      }
    }
  }

  def names = List("xmem","xbranch","xalu","fgen","fpmem","fax","fdiv","vec","cxmen","cxbranch","cxalu")

  def code_body(seqnum: Int, mix: Map[String, Int], veccfg: Map[String, String], use_amo: Boolean, use_mul: Boolean, use_div: Boolean, segment: Boolean) =
  {
    val name_to_seq = Map(
      "xmem" -> (() => new SeqMem(xregs, core_memory, use_amo)),
      "xbranch" -> (() => new SeqBranch(xregs)),
      "xalu" -> (() => new SeqALU(xregs, use_mul, use_div)), //true means use_divider, TODO: make better
      "fgen" -> (() => new SeqFPU(fregs_s, fregs_d)),
      "fpmem" -> (() => new SeqFPMem(xregs, fregs_s, fregs_d, core_memory)),
      "fax" -> (() => new SeqFaX(xregs, fregs_s, fregs_d)),
      "fdiv" -> (() => new SeqFDiv(fregs_s, fregs_d)),
      "vec" -> (() => new SeqVec(xregs, vxregs, vpregs, vsregs, varegs, used_vl, veccfg)),
      "cxmem" -> (() => new SeqCMem(xregs, core_memory, use_amo)),
      "cxbranch" -> (() => new SeqCBranch(xregs)),
      "cxalu" -> (() => new SeqCALU(xregs, use_mul, use_div)))

    prob_tbl = new ArrayBuffer[(Int, () => InstSeq)]
    nseqs = seqnum

    for ((name, prob) <- mix)
      prob_tbl += ((prob, name_to_seq(name)))

    for (i <- 0 to nseqs-1) gen_seq()

    if (segment) { progsegs += ProgSeg() }
    while (!is_seqs_empty)
    {
      seqs_find_active()

      while (!is_seqs_active_empty)
      {
        val seq = rand_pick(seqs_active)
	if(segment) {
	  val inst = seq.next_inst()
	  val branch_filter = (x: Operand) =>
      	    x.isInstanceOf[Label] && x.asInstanceOf[Label].label.indexOf("branch_patch") != -1
    	  val branch_patch = inst.operands.indexWhere(branch_filter)
	  val jalr_filter1 = (x: Operand) =>
      	    x.isInstanceOf[Label] && x.asInstanceOf[Label].label.indexOf("jalr_patch1") != -1
    	  val jalr_patch1 = inst.operands.indexWhere(jalr_filter1)
	  val jalr_filter2 = (x: Operand) =>
      	    x.isInstanceOf[Label] && x.asInstanceOf[Label].label.indexOf("jalr_patch2") != -1
    	  val jalr_patch2 = inst.operands.indexWhere(jalr_filter2)
    	  if (jalr_patch1 == -1 && branch_patch == -1 && jalr_patch2 == -1){
    	    progsegs.last.insts += inst
	    update_stats(inst)
	  }
	} else {	
          add_inst(seq.next_inst())
	}

        if (seq.is_done)
        {
          seq.free_regs()
          seqs_active -= seq
          if (seq.isInstanceOf[SeqVec]) 
            for (vinst <- seq.asInstanceOf[SeqVec].vinsts)
              update_stats(vinst)
        }

        if (rand_range(0,99) < 10) seqs_find_active()
      }
    }
    
    //Final p_seg
    progsegs.last.insts += J(Label("reg_dump"))

    if(!segment) { resolve_jalr_las }
    rand_permute(progsegs)
 
    if (killed_seqs >= (nseqs*5))
    {
    println("Warning: Prog killed an excessive number of sequences. (#X=%d, #Fs=%d, #Fd=%d, #VX=%d, #VP=%d, #VS=%d, #VA=%d)" format (xregs.size, fregs_s.size, fregs_d.size, vxregs.size, vpregs.size, vsregs.size, varegs.size))
    }

    ("" /: progsegs)(_ + _) + "\n"
  }

  def header(nseqs: Int) =
  {
    "// random assembly code generated by RISC-V torture test generator\n" +
    "// nseqs = " + nseqs + "\n" +
    "// memsize = " + memsize + "\n" +
    "\n" +
    "#include \"riscv_test.h\"\n"
  }

  def code_header(using_fpu: Boolean, using_vec: Boolean, fprnd: Int) =
  {
    "\n" +
    (if (using_vec) "RVTEST_RV64UV\n"
     else if (using_fpu) "RVTEST_RV64UF\n"
     else "RVTEST_RV64U\n") +
    "RVTEST_CODE_BEGIN\n" +
    (if (using_vec) init_vector() else "") + 
    "\n" +
    "\tj test_start\n" +
    "\n" +
    "crash_backward:\n" +
    "\tRVTEST_FAIL\n" +
    "\n" +
    "test_start:\n" +
    "\n" +
    // fregs must be initialized before xregs!
    (if (using_fpu) fregs.init_regs() else "") +
    (if (using_vec) vregs.init_regs() else "") +
    xregs.init_regs() +
    "\tj pseg_0\n" +
    "\n"
  }

  def init_vector() = 
  {
    "\n" +
    "\tli x1, " + used_vl + "\n" +
    "\tvsetcfg " + num_vxregs + ", " + num_vpregs + "\n" +
    "\tvsetvl x1,x1\n"
  }

  def code_footer(using_fpu: Boolean, using_vec: Boolean, loop: Boolean) =
  {
    var s = "reg_dump:\n" +
    {
    if(loop){
      "\tla x1, loop_count\n" +
      "\tlw x2, 0(x1)\n" +
      "\taddi x3, x2, -1\n" +
      "\tsw x3, 0(x1)\n" +
      "\tbnez x2, pseg_0\n"
    } else {""}
    } +
    // fregs must be saved after xregs
    xregs.save_regs() +
    (if(using_fpu) fregs.save_regs() else "") +
    (if(using_vec) vregs.save_regs() else "") +
    "\tj test_end\n" +
    "\n" +
    "crash_forward:\n" +
    "\tRVTEST_FAIL\n" +
    "\n" +
    "test_end:\n" +
    "\tRVTEST_PASS\n" +
    "\n" +
    "RVTEST_CODE_END\n" +
    "\n"
    for(seq <- seqs.filter(_.is_done))
    {
      val ns = seq.extra_code.mkString("\n")
      if(ns.nonEmpty) s += "// extra code for " + seq + "\n" +
      "\t.align 3\n" + ns + "\n"
    }
    s += "\n"
    s
  }

  def data_header() =
  {
    "\t.data\n" +
    "\n"
  }

  def output_mem_data(loop_size: Int) =
  {
    var s = "// Memory Blocks\n"
    s += MemDump(core_memory)
    s += "\n"
    s += ".align 8\n"
    s += "loop_count: .word 0x" + Integer.toHexString(loop_size) + "\n\n"
    for(seq <- seqs.filter(_.is_done))
    {
      val ns = seq.extra_visible_data.mkString("\n")
      if(ns.nonEmpty) s += "// output data for " + seq + "\n" + ns + "\n"
    }
    s
  }

  def data_input(using_fpu: Boolean, using_vec: Boolean) =
  {
    var s = "hidden_data:\n"
    for(seq <- seqs.filter(_.is_done))
    {
      val ns = seq.extra_hidden_data.mkString("\n")
      if(ns.nonEmpty) s += "// hidden data for " + seq + "\n" + ns + "\n"
    }
    s += xregs.init_regs_data()
    s += (if(using_fpu) fregs.init_regs_data() else "")
    s += (if(using_vec) vregs.init_regs_data() else "")
    s
  }

  def data_output(using_fpu: Boolean, using_vec: Boolean, loop_size: Int) =
  {
    "RVTEST_DATA_BEGIN\n" +
    "\n" +
    xregs.output_regs_data() +
    (if(using_fpu) fregs.output_regs_data() else "") +
    (if(using_vec) vregs.output_regs_data() else "") +
    output_mem_data(loop_size) +
    "RVTEST_DATA_END\n"
  }

  def data_footer() = ""

  def generate(nseqs: Int, fprnd: Int, mix: Map[String, Int], veccfg: Map[String, String], use_amo: Boolean, use_mul: Boolean, use_div: Boolean, segment : Boolean, loop: Boolean, loop_size: Int) =
  {
    // Check if generating any FP operations or Vec unit stuff
    val using_vec = mix.filterKeys(List("vec") contains _).values.reduce(_+_) > 0
    val using_fpu = (mix.filterKeys(List("fgen","fpmem","fax","fdiv") contains _).values.reduce(_+_) > 0) || using_vec
    // TODO: make a config object that is passed around?

    header(nseqs) +
    code_header(using_fpu, using_vec, fprnd) +
    code_body(nseqs, mix, veccfg, use_amo, use_mul, use_div, segment) +
    code_footer(using_fpu, using_vec, loop) +
    data_header() +
    data_input(using_fpu, using_vec) +
    data_output(using_fpu, using_vec, loop_size) +
    data_footer()
  }

  def statistics(nseqs: Int, fprnd: Int, mix: Map[String, Int], vnseq: Int, vmemsize: Int, vfnum: Int, vecmix: Map[String, Int],
                 use_amo: Boolean, use_mul: Boolean, use_div: Boolean) =
  {
    "--------------------------------------------------------------------------\n" + 
    "-- Statistics for assembly code created by RISCV torture test generator --\n" +
    get_time() +
    "--------------------------------------------------------------------------\n" +
    "---------- instcnt = " + instcnt + " -------------\n" +
    "---------- nseqs = " + nseqs + " -------------\n" +
    "---------- memsize = " + memsize + " ----------\n" +
    "---------- vnseq = " + vnseq + " ----------\n" +
    "---------- vfnum = " + vfnum + " ----------\n" +
    "---------- vmemsize = " + vmemsize + " ----------\n" +
    "---------- fprnd = " + fprnd + " ----------\n" +
    "---------- use_amo = " + use_amo + " ----------\n" +
    "---------- use_mul = " + use_mul + " ----------\n" +
    "---------- use_div = " + use_div + " ----------\n" + 
    "--------------------------------------------------------------------------\n\n" +
    "--------------------------------------------------------------------------\n" +
    sequence_stats(mix, vecmix, nseqs, vnseq, vfnum) +
    "--------------------------------------------------------------------------\n\n" +
    "--------------------------------------------------------------------------\n" +
    instruction_stats() +
    "--------------------------------------------------------------------------\n\n" +
    "--------------------------------------------------------------------------\n" +
    register_stats() +
    "--------------------------------------------------------------------------\n"
  }
}
