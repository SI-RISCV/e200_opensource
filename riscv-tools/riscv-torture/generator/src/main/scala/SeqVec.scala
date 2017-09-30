package torture

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import Rand._

object SeqVec
{
  var cnt = 0
  def get_id = (cnt += 1)
}


class SeqVec(xregs: HWRegPool, vvregs: HWRegPool, vpregs: HWRegPool, vsregs: HWRegPool, varegs: HWRegPool, vl: Int, cfg: Map[String, String]) extends InstSeq
{
  override val seqname = "vec"
  val memsize = cfg.getOrElse("memsize", "32").toInt
  val vfnum   = cfg.getOrElse("vf", "10").toInt
  val seqnum  = cfg.getOrElse("seq", "100").toInt
  val use_mul = cfg.getOrElse("mul", "true") == "true"
  val use_div = cfg.getOrElse("div", "true") == "true"
  val use_mix = cfg.getOrElse("mix", "true") == "true"
  val use_fpu = cfg.getOrElse("fpu", "true") == "true"
  val use_fma = cfg.getOrElse("fma", "true") == "true"
  val use_fcvt = cfg.getOrElse("fcvt", "true") == "true"
  val use_fdiv = cfg.getOrElse("fdiv", "true") == "true"
  val use_amo = cfg.getOrElse("amo", "true") == "true"
  val use_seg = cfg.getOrElse("seg", "true") == "true"
  val use_stride = cfg.getOrElse("stride", "true") == "true"
  val pred_alu = cfg.getOrElse("pred_alu", "true") == "true"
  val pred_mem = cfg.getOrElse("pred_mem", "true") == "true"
  val mixcfg = cfg.filterKeys(_ contains "mix.").map { case (k,v) => (k.split('.')(1), v.toInt) }.asInstanceOf[Map[String,Int]]
  val vseqstats = new HashMap[String,Int].withDefaultValue(0)
  val vinsts = new ArrayBuffer[Inst]

  val name = "seqvec_" + SeqVec.cnt
  SeqVec.cnt += 1
  override def toString = name

  val xreg_helper = reg_write_hidden(xregs)
  val vareg_helper = reg_write_hidden(varegs)
  val vpreg_helper = reg_write_hidden(vpregs)
  val vec_mem = new VMem(name+"_mem", memsize, vl)
  extra_visible_data += MemDump(vec_mem)

  // Determine how many per type of vector register need to checkout for writing
  def get_rand_reg_num(max: Int, min: Int) =  // TODO: discuss this
  {
    val randtype = rand_range(0, 99)
    val attempt =
      if(randtype < 5)          //  5% use a lot of registers
        rand_range(max/2, max)  
      else if(randtype < 10)    //  5% use very little registers
        rand_range(1, 3)
      else                      // 90% use moderate number
        rand_range(3, max/2)
    Math.max(Math.min(max, attempt),min)
  }

  val num_xreg = get_rand_reg_num(xregs.size-2, 1) //can't use x0 or xreg_helper

  val num_vvreg   = get_rand_reg_num(vvregs.size, 5)
  val min_pregs   = if(pred_alu || pred_mem || mixcfg.getOrElse("vpop",0) > 0) 1 else 0
  val num_vpreg   = get_rand_reg_num(vpregs.size-1, min_pregs) //can't use preg_helper

  val num_vareg   = get_rand_reg_num(varegs.size-1, 1) //can't use va0
  val num_vsreg   = get_rand_reg_num(vsregs.size, 1)

  // Create shadow register pools to mimic those registers
  // allowing us to hold them after SeqSeq finishes
  val shadow_xregs  = new ShadowRegPool
  val shadow_vvregs = new ShadowRegPool
  val shadow_vpregs = new ShadowRegPool

  val shadow_varegs = new ShadowRegPool
  val shadow_vsregs = new ShadowRegPool

  val xregs_checkout = new ArrayBuffer[Reg]
  val xregs_adding = reg_write_visible_consec(xregs, num_xreg)
  xregs_adding.asInstanceOf[RegNeedsAlloc].regs.map(hr => {
    xregs_checkout += hr
    shadow_xregs.hwregs += new HWShadowReg(hr, "x_shadow", true, true)
  })

  val vvregs_checkout = new ArrayBuffer[Reg]
  val vregs_adding = reg_write_visible_consec(vvregs, num_vvreg)
  vregs_adding.asInstanceOf[RegNeedsAlloc].regs.map(hr => {
    vvregs_checkout += hr
    shadow_vvregs.hwregs += new HWShadowReg(hr, "v_shadow", true, true)
  })

  val vpregs_checkout = new ArrayBuffer[Reg]
  if(num_vpreg != 0 ) {
    val vpregs_adding = reg_write_visible_consec(vpregs, num_vpreg)
    vpregs_adding.asInstanceOf[RegNeedsAlloc].regs.map(hr => {
      vpregs_checkout += hr
      shadow_vpregs.hwregs += new HWShadowReg(hr, "p_shadow", true, true)
    })
  }

  val varegs_checkout = new ArrayBuffer[Reg]
  val varegs_adding = reg_write_visible_consec(varegs, num_vareg)
  varegs_adding.asInstanceOf[RegNeedsAlloc].regs.map(hr => {
    varegs_checkout += hr
    shadow_varegs.hwregs += new HWShadowReg(hr, "a_shadow", true, true)
  })

  val vsregs_checkout = new ArrayBuffer[Reg]
  val vsregs_adding = reg_write_visible_consec(vsregs, num_vsreg)
  vsregs_adding.asInstanceOf[RegNeedsAlloc].regs.map(hr => {
    vsregs_checkout += hr
    shadow_vsregs.hwregs += new HWShadowReg(hr, "s_shadow", true, true)
  })

  // Handle initialization of vreg from memories
  for((vreg,i) <- vvregs_checkout.zipWithIndex)
  {
    val init_mem = new Mem(Array(Label(name+"_"), vreg, Label("_init"))  , 8*vl)
    extra_hidden_data  += MemDump(init_mem)
    insts += LA(xreg_helper, init_mem)
    insts += VMCA(vareg_helper, xreg_helper)
    val vf_init_block = new ProgSeg(name+"_"+i+"_vf_init")
    vf_init_block.insts += VPSET(vpreg_helper)
    vinsts += VPSET(vpreg_helper)
    vf_init_block.insts += VLD(vreg, vareg_helper, PredReg(vpreg_helper, false))
    vf_init_block.insts += VSTOP()
    vinsts += VLD(vreg, vareg_helper)
    vinsts += VSTOP()
    extra_code += ProgSegDump(vf_init_block)
    insts += LUI(xreg_helper, Label("%hi("+vf_init_block.name+")"))
    insts += VF(RegStrImm(xreg_helper, "%lo("+vf_init_block.name+")"))
  }

  val vf_init_pred_block = new ProgSeg(name+"_vf_init_pred")
  for((vpreg,i) <- vpregs_checkout.zipWithIndex)
  {
    //try to have different alternate settings
    if(i % 2 == 0) {
      vf_init_pred_block.insts += VCMPLT(vpreg,vvregs_checkout(0), vvregs_checkout(1),PredReg(vpreg_helper, false))
      vinsts += VCMPLT(vpreg,vvregs_checkout(0), vvregs_checkout(1),PredReg(vpreg_helper, false))
    } else {
      vf_init_pred_block.insts += VCMPLT(vpreg,vvregs_checkout(2), vvregs_checkout(3),PredReg(vpreg_helper, false))
      vinsts += VCMPLT(vpreg,vvregs_checkout(2), vvregs_checkout(3),PredReg(vpreg_helper, false))
    }
  }
  vf_init_pred_block.insts += VSTOP()
  vinsts += VSTOP()
  extra_code += ProgSegDump(vf_init_pred_block)
  insts += LUI(xreg_helper, Label("%hi("+vf_init_pred_block.name+")"))
  insts += VF(RegStrImm(xreg_helper, "%lo("+vf_init_pred_block.name+")"))

  for(i <- 1 to vfnum)
  {
    // Create SeqSeq to create some vector instructions
    val vf_instseq = new SeqSeq(shadow_vvregs, shadow_vpregs, vpreg_helper, shadow_vsregs, shadow_varegs, shadow_xregs, vec_mem, seqnum, mixcfg, vl, use_mul, use_div, use_mix, use_fpu, use_fma, use_fcvt, use_fdiv, use_amo, use_seg, use_stride, pred_alu, pred_mem) //TODO: Enable configuration of enabling mul,div ops
    for ((seqname, seqcnt) <- vf_instseq.seqstats)
    {
      vseqstats(seqname) += seqcnt
    }

    // Dump that SeqSeq into a VF Instruction block
    val vf_block = new ProgSeg(name+"_vf_"+i)
    //clear vphelper for vmemops
    vf_block.insts += VPSET(vpreg_helper) //TODO: add vpset and vpop
    vinsts += VPSET(vpreg_helper) // TODO: add helper function that does these two lines
    while(!vf_instseq.is_done)
    {
      if(vf_instseq.vinst_left)
      {
        val vinst = vf_instseq.next_vinst()
        vf_block.insts += vinst
        vinsts += vinst
      }
      if(vf_instseq.inst_left) insts += vf_instseq.next_inst()
    }
    vf_block.insts += VSTOP()
    vinsts += VSTOP()
    extra_code += ProgSegDump(vf_block)
    extra_hidden_data.appendAll(vf_instseq.extra_hidden_data)

    insts += LUI(xreg_helper, Label("%hi("+vf_block.name+")"))
    insts += VF(RegStrImm(xreg_helper, "%lo("+vf_block.name+")"))
  }

  // Handling dumping of vreg to output memories 
  for((vreg,i) <- vvregs_checkout.zipWithIndex)
  {
    if(vreg.hwreg.is_visible) {
      val out_mem = new Mem(Array(Label(name+"_"), vreg, Label("_output"))  , 8*vl)
      extra_visible_data  += MemDump(out_mem)
      insts += LA(xreg_helper, out_mem)
      insts += VMCA(vareg_helper, xreg_helper)
      val vf_init_block = new ProgSeg(name+"_"+i+"_vf_dump")
      vf_init_block.insts += VPSET(vpreg_helper)
      vinsts += VPSET(vpreg_helper)
      vf_init_block.insts += VSD(vreg, vareg_helper, PredReg(vpreg_helper, false))
      vf_init_block.insts += VSTOP()
      vinsts += VSD(vreg, vareg_helper)
      vinsts += VSTOP()
      extra_code += ProgSegDump(vf_init_block)
      insts += LUI(xreg_helper, Label("%hi("+vf_init_block.name+")"))
      insts += VF(RegStrImm(xreg_helper, "%lo("+vf_init_block.name+")"))
    }
  }

  // Fence to close out the vector sequence
  insts += FENCE_V(Label("// " + name))
}
