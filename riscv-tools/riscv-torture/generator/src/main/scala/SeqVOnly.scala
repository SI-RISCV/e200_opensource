package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqVOnly(xregs: HWRegPool, fregs_s: HWRegPool, fregs_d: HWRegPool) extends VFInstSeq
{
  override val seqname = "vonly"
  def seq_xdest(op: Opcode) = () =>
  {
    val dest = reg_write_visible(xregs) // Verifiy visible is appropriate for this
    insts += op(dest)
  }

  def seq_src2(op: Opcode, using_pool: HWRegPool) = () =>
  {
    val src = reg_read_any(using_pool)
    val pred = reg_read_any(xregs)
    val dest = reg_write(using_pool, pred, src)
    insts += op(dest, pred, src)
  }

  val candidates = new ArrayBuffer[() => insts.type]

  // Intra-FPU Instructions
  candidates += seq_xdest(VEIDX)

  for (op <- List(MOVZ, MOVN))
    candidates += seq_src2(op, xregs)

  for (op <- List(FMOVZ, FMOVN))
  {
    candidates += seq_src2(op, fregs_s)
    candidates += seq_src2(op, fregs_d)
  }

  rand_pick(candidates)()
}
