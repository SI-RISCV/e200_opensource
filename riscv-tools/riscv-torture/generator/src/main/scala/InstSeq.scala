package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class InstSeq extends HWRegAllocator
{
  val insts = new ArrayBuffer[Inst]
  var inst_ptr = 0
  val seqname = "Unnamed"

  val extra_code = new ArrayBuffer[DataChunk]
  val extra_hidden_data = new ArrayBuffer[DataChunk]
  val extra_visible_data = new ArrayBuffer[DataChunk]
  
  def is_done = insts.length == inst_ptr

  def next_inst() =
  {
    val inst = insts(inst_ptr)
    inst_ptr += 1
    inst
  }
}

object InstSeq
{
  def apply(prob_tbl: ArrayBuffer[(Int, () => InstSeq)]): InstSeq =
  {
    var p = rand_range(0, 99)
    for ((prob, gen_seq) <- prob_tbl)
    {
      if (p < prob) return gen_seq()
      p -= prob
    }

    assert(false, println("Probabilties should have added up to 100%"))
    new InstSeq()
  }
}

import HWReg._

class HWRegAllocator
{
  val regs = new ArrayBuffer[Reg]
  var allocated = false

  def reg_fn(hwrp: HWRegPool, filter: (HWReg) => Boolean, alloc: (HWReg) => Unit, free: (HWReg) => Unit, consec_regs: Int = 1) =
  {
    val reg = new RegNeedsAlloc(hwrp, filter, alloc, free, consec_regs)
    for(i <- 1 to consec_regs) reg.regs += new Reg
    regs += reg
    reg
  }

  def reg_read_zero(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_zero, alloc_read, free_read) }
  def reg_read_any(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_any, alloc_read, free_read) }
  def reg_read_any_other(hwrp: HWRegPool, other: Reg) = { reg_fn(hwrp, filter_read_any_other(other), alloc_read, free_read) }
  def reg_read_visible(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_visible, alloc_read, free_read) }
  def reg_read_visible_consec(hwrp: HWRegPool, regs: Int) = { reg_fn(hwrp, filter_read_visible, alloc_read, free_read, regs) }
  def reg_write_ra(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_ra, alloc_write(false), free_write) }
  def reg_write_visible(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_visible, alloc_write(true), free_write) }
  def reg_write_visible_consec(hwrp: HWRegPool, regs: Int) = { reg_fn(hwrp, filter_write_visible, alloc_write(true), free_write, regs) }
  def reg_write_hidden(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_hidden, alloc_write(false), free_write) }
  def reg_write(hwrp: HWRegPool, regs: Reg*) = { reg_fn(hwrp, filter_write_dep(regs.toList), alloc_write_dep(regs.toList), free_write) }
  def reg_write_other(hwrp: HWRegPool, other: Reg, regs: Reg*) = { reg_fn(hwrp, filter_write_dep_other(other, regs.toList), alloc_write_dep(regs.toList), free_write) }

  //tianchuan:We construct c instruction architecture
  //*************************************************
  def reg_write_visible_c(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_visible_c, alloc_write(true), free_write) }
  def reg_write_visible_nox0(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_visible_nox0, alloc_write(true), free_write) }
  def reg_write_hidden_x2(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_hidden_x2, alloc_write(false), free_write) }
  def reg_read_visible_nox0(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_visible_nox0, alloc_read, free_read) }
  def reg_write_hidden_x8_x15(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_hidden_x8_x15, alloc_write(false), free_write) }
  def reg_write_visible_x8_x15(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_visible_x8_x15, alloc_write(true), free_write) }
  def reg_read_visible_x8_x15(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_visible_x8_x15, alloc_read, free_read) }
  def reg_read_any_butnox0(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_any_butnox0, alloc_read, free_read) }
  def reg_read_x8_x15(hwrp: HWRegPool) = { reg_fn(hwrp, filter_read_x8_x15, alloc_read, free_read) }
  def reg_write_x8_x15(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_x8_x15, alloc_write(false), free_write) }
  def reg_write_visible_x2(hwrp: HWRegPool) = { reg_fn(hwrp, filter_write_visible_x2, alloc_write(true), free_write) }
  def reg_write_x8x15(hwrp: HWRegPool, regs: Reg*) = { reg_fn(hwrp, filter_write_dep_x8x15(regs.toList), alloc_write_dep(regs.toList), free_write) }
  
  
  
  
  
  def allocate_regs(): Boolean =
  {
    for (reg <- regs)
    {
      val regna = reg.asInstanceOf[RegNeedsAlloc]
      val candidates = regna.hwrp.hwregs.filter(regna.filter)
      val consec_regs = regna.consec_regs
      val hwregs = regna.hwrp.hwregs

      if (candidates.length < consec_regs)
        return false

      var high = 0
      val consec_candidates = new ArrayBuffer[Int] // index in hwregs
      for( hrindex <- 0 to hwregs.length)
      {
        if(hrindex < hwregs.length && candidates.contains(hwregs(hrindex)))
          high += 1 // still seeing consec regs
        else if (high > 0)
        {
          // end of sequence. number all the candidates of this sequence
          for(i <- high to consec_regs by -1)
            consec_candidates += hrindex-i
          high = 0
        }
      }
      if(consec_candidates.size == 0)
        return false
      val reg_index = rand_pick(consec_candidates)
      for(i <- reg_index until reg_index+consec_regs){
        val hwreg = hwregs(i)
        regna.alloc(hwreg)
        if(i == reg_index) regna.hwreg = hwreg
        regna.regs.toArray[Reg].apply(i-reg_index).hwreg = hwreg
      }
    }

    allocated = true

    return true
  }

  def free_regs() =
  {
    for (reg <- regs)
    {
      val regna = reg.asInstanceOf[RegNeedsAlloc]
      val hwregs = regna.hwrp.hwregs
      val start = hwregs.indexOf(regna.hwreg)
      for( i <- start until start+regna.consec_regs ) regna.free(hwregs(i))
    }
  }
}
