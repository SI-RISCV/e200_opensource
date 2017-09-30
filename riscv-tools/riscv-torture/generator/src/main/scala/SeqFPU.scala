package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqFPU(fregs_s: HWRegPool, fregs_d: HWRegPool) extends InstSeq
{
  override val seqname = "fgen"
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

  def seq_src3_s(op: Opcode) = () =>
  {
    val src1 = reg_read_any(fregs_s)
    val src2 = reg_read_any(fregs_s)
    val src3 = reg_read_any(fregs_s)
    val dest = reg_write(fregs_s, src1, src2, src3)
    insts += op(dest, src1, src2, src3)
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

  def seq_src3_d(op: Opcode) = () =>
  {
    val src1 = reg_read_any(fregs_d)
    val src2 = reg_read_any(fregs_d)
    val src3 = reg_read_any(fregs_d)
    val dest = reg_write(fregs_d, src1, src2, src3)
    insts += op(dest, src1, src2, src3)
  }

  val candidates = new ArrayBuffer[() => insts.type]

  for (op <- List(FADD_S, FSUB_S, FMUL_S, FMIN_S, FMAX_S))
    candidates += seq_src2_s(op)

  for (op <- List(FADD_D, FSUB_D, FMUL_D, FMIN_D, FMAX_D))
    candidates += seq_src2_d(op)

  for (op <- List(FMADD_S, FNMADD_S, FMSUB_S, FNMSUB_S))
    candidates += seq_src3_s(op)
  
  for (op <- List(FMADD_D, FNMADD_D, FMSUB_D, FNMSUB_D))
    candidates += seq_src3_d(op)
  
  rand_pick(candidates)()
}
