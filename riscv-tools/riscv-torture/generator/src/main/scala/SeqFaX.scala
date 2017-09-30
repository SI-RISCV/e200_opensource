package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqFaX(xregs: HWRegPool, fregs_s: HWRegPool, fregs_d: HWRegPool) extends InstSeq
{
  override val seqname = "fax"
  def seq_src1(op: Opcode, dst_pool: HWRegPool, src_pool: HWRegPool) = () =>
  {
    val src1 = reg_read_any(src_pool)
    val dest = reg_write(dst_pool, src1)
    insts += op(dest, src1)
  }

  def seq_src2(op: Opcode, dst_pool: HWRegPool, src_pool: HWRegPool) = () =>
  {
    val src1 = reg_read_any(src_pool)
    val src2 = reg_read_any(src_pool)
    val dest = reg_write(dst_pool, src1, src2)
    insts += op(dest, src1, src2)
  }

  val candidates = new ArrayBuffer[() => insts.type]

  // Intra-FPU Instructions
  candidates += seq_src1(FCVT_S_D, fregs_s, fregs_d)
  candidates += seq_src1(FCVT_D_S, fregs_d, fregs_s)

  for (op <- List(FSGNJ_S, FSGNJN_S, FSGNJX_S))
    candidates += seq_src2(op, fregs_s, fregs_s)

  for (op <- List(FSGNJ_D, FSGNJN_D, FSGNJX_D))
    candidates += seq_src2(op, fregs_d, fregs_d)

  // X<->F Instructions
  for (op <- List(FCVT_S_L, FCVT_S_LU, FCVT_S_W, FCVT_S_WU, FMV_S_X))
    candidates += seq_src1(op, fregs_s, xregs)

  for (op <- List(FCVT_D_L, FCVT_D_LU, FCVT_D_W, FCVT_D_WU, FMV_D_X))
    candidates += seq_src1(op, fregs_d, xregs)
  
  for (op <- List(FCVT_L_S, FCVT_LU_S, FCVT_W_S, FCVT_WU_S, FMV_X_S))
    candidates += seq_src1(op, xregs, fregs_s)

  for (op <- List(FCVT_L_D, FCVT_LU_D, FCVT_W_D, FCVT_WU_D, FMV_X_D))
    candidates += seq_src1(op, xregs, fregs_d)

  for (op <- List(FEQ_S, FLT_S, FLE_S))
    candidates += seq_src2(op, xregs, fregs_s)

  for (op <- List(FEQ_D, FLT_D, FLE_D))
    candidates += seq_src2(op, xregs, fregs_d)

  rand_pick(candidates)()
}
