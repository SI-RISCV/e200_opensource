package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqFDiv(fregs_s: HWRegPool, fregs_d: HWRegPool) extends InstSeq
{
  override val seqname = "fdiv"
  def seq_src1_s(op: Opcode) = () =>
  {
    val src1 = reg_read_any(fregs_s)
    val dest = reg_write(fregs_s, src1)
    insts += op(dest, src1)
  }

  def seq_src2_s(op: Opcode) = () =>
  {
    val src1 = reg_read_any(fregs_s)
    val src2 = reg_read_any(fregs_s)
    val dest = reg_write(fregs_s, src1, src2)
    insts += op(dest, src1, src2)
  }

  def seq_src1_d(op: Opcode) = () =>
  {
    val src1 = reg_read_any(fregs_d)
    val dest = reg_write(fregs_d, src1)
    insts += op(dest, src1)
  }

  def seq_src2_d(op: Opcode) = () =>
  {
    val src1 = reg_read_any(fregs_d)
    val src2 = reg_read_any(fregs_d)
    val dest = reg_write(fregs_d, src1, src2)
    insts += op(dest, src1, src2)
  }

  val candidates = new ArrayBuffer[() => insts.type]

  candidates += seq_src1_s(FSQRT_S)
  candidates += seq_src1_d(FSQRT_D)
  candidates += seq_src2_s(FDIV_S)
  candidates += seq_src2_d(FDIV_D)

  rand_pick(candidates)()
}
