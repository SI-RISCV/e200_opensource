package torture

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import Rand._

class SeqSeq(vregs: HWRegPool, pregs: HWRegPool, def_preg: Reg, sregs: HWRegPool, aregs: HWRegPool, xregs: HWRegPool, mem: Mem, nseqs: Int, mixcfg: Map[String,Int], vl: Int, use_mul: Boolean, use_div: Boolean, use_mix: Boolean, use_fpu: Boolean, use_fma: Boolean, use_fcvt: Boolean, use_fdiv: Boolean, use_amo: Boolean, use_seg: Boolean, use_stride: Boolean, pred_alu: Boolean, pred_mem: Boolean) extends VFInstSeq
{
  val seqs = new ArrayBuffer[VFInstSeq]
  val seqs_active = new ArrayBuffer[VFInstSeq]
  var killed_seqs = 0
  val seqstats = new HashMap[String,Int].withDefaultValue(0)

  def seqs_not_allocated = seqs.filter((x) => !x.allocated)
  def is_seqs_empty = seqs_not_allocated.length == 0
  def is_seqs_active_empty = seqs_active.length == 0

  def are_pools_fully_unallocated = List(vregs, pregs, sregs).forall(_.is_fully_unallocated)

  val name_to_seq = Map(
    "vmem" -> (() => new SeqVMem(xregs, vregs, pregs, def_preg, sregs, aregs, mem.asInstanceOf[VMem], vl, use_amo,use_seg, use_stride, pred_mem)),
    "valu" -> (() => new SeqVALU(vregs, pregs, def_preg, sregs, use_mul, use_div, use_mix, use_fpu, use_fma, use_fcvt, use_fdiv, pred_alu)), // TODO: Clean up
    "vpop" -> (() => new SeqVPop(vregs, pregs, def_preg, sregs)),
    "vonly" -> (() => new SeqVOnly(vregs, pregs, sregs)))

  val prob_tbl = new ArrayBuffer[(Int, () => VFInstSeq)]
  mixcfg foreach {case(name, prob) => (prob_tbl += ((prob, name_to_seq(name))))}

  def gen_seq(): Unit =
  {
    val nxtseq = VFInstSeq(prob_tbl)
    seqs += nxtseq
    seqstats(nxtseq.seqname) += 1
  }
 
  def seqs_find_active(): Unit =
  {
    for (seq <- seqs_not_allocated)
    {
      vregs.backup()
      pregs.backup()
      sregs.backup()
      aregs.backup()
      xregs.backup()

      if (seq.allocate_regs())
      {
        seqs_active += seq
      }
      else
      {
        vregs.restore()
        pregs.restore()
        sregs.restore()
        aregs.restore()
        xregs.restore()
        // because the setup instructions for a vf seq are only run once we
        // cannot free va or vs regs to be reused so we kill seqs that can be
        // allocated
        seqs -= seq
        killed_seqs += 1
        seqstats(seq.seqname) -= 1

        return
      }
    }
  }

  for(i <- 1 to nseqs) gen_seq()
  
  while(!is_seqs_empty)
  {
    seqs_find_active()

    while(!is_seqs_active_empty)
    {
      val seq = rand_pick(seqs_active)
      if(seq.inst_left) insts += seq.next_inst()
      if(seq.vinst_left) vinsts += seq.next_vinst()

      if(seq.is_done) {
        extra_hidden_data.appendAll(seq.extra_hidden_data)
        seqs_active -= seq
      }
    }
  }
  for(seq <- seqs) seq.free_regs()

  if(killed_seqs >= (nseqs*5))
  println("warning: a SeqSeq killed an excessive number of sequences. (#V=%d, #P=%d, #S=%d)" format (vregs.size, pregs.size, sregs.size))
}
