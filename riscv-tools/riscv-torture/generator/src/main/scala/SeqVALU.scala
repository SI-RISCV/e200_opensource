package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqVALU(vregs: HWRegPool, pregs: HWRegPool, def_preg: Reg, sregs: HWRegPool, use_mul: Boolean, use_div: Boolean, use_mix: Boolean, use_fpu: Boolean, use_fma: Boolean, use_fcvt: Boolean, use_fdiv: Boolean, use_pred: Boolean) extends VFInstSeq //TODO: better configuration
{
  override val seqname = "valu"
  val pred = if(use_pred) PredReg(reg_read_any(pregs), false)
    else PredReg(def_preg, false)

  def seq_src1(op: Opcode, dreg: HWRegPool, s1reg: HWRegPool) = () =>
  {
    val src1 = reg_read_any(s1reg)
    val dest = reg_write(dreg, src1)
    if(dreg == sregs) vinsts += op(dest, src1)
    else vinsts += op(dest, src1, pred)
  }

  def seq_src2(op: Opcode, dreg: HWRegPool, s1reg: HWRegPool, s2reg: HWRegPool) = () =>
  {
    val src1 = reg_read_any(s1reg)
    val src2 = reg_read_any(s2reg)
    val dest = reg_write(dreg, src1, src2)
    if(dreg == sregs) vinsts += op(dest, src1, src2)
    else vinsts += op(dest, src1, src2, pred)
  }

  def seq_src3(op: Opcode, dreg: HWRegPool, s1reg: HWRegPool, s2reg: HWRegPool, s3reg: HWRegPool) = () =>
  {
    val src1 = reg_read_any(s1reg)
    val src2 = reg_read_any(s2reg)
    val src3 = reg_read_any(s3reg)
    val dest = reg_write(dreg, src1, src2, src3)
    if(dreg == sregs) vinsts += op(dest, src1, src2, src3)
    else vinsts += op(dest, src1, src2, src3, pred)
  }

  val candidates = new ArrayBuffer[() => vinsts.type]

  val oplist1 = new ArrayBuffer[Opcode]
  val oplist2 = new ArrayBuffer[Opcode]
  val oplist3 = new ArrayBuffer[Opcode]

  oplist2 += (VADD, VSUB, VSLL, VXOR, VSRL, VSRA, VOR, VAND)
  oplist2 += (VADDW, VSUBW, VSLLW, VSRLW, VSRAW)
  if (use_mul) oplist2 += (VMUL, VMULH, VMULHSU, VMULHU, VMULW)
  if (use_div) oplist2 += (VDIV, VDIVU, VREM, VREMU, VDIVW, VDIVUW, VREMW, VREMUW)
  if (use_fpu)
  {
    oplist2 += (VFADD_S, VFSUB_S, VFMUL_S, VFMIN_S, VFMAX_S,
    VFADD_D, VFSUB_D, VFMUL_D, VFMIN_D, VFMAX_D,
    VFSGNJ_S, VFSGNJN_S, VFSGNJX_S, VFSGNJ_D, VFSGNJN_D, VFSGNJX_D)
    if (use_fdiv)
    {
      oplist1 += (VFSQRT_S, VFSQRT_D)
      oplist2 += (VFDIV_S, VFDIV_D)
    }
  }
  if (use_fma) oplist3 += (VFMADD_S, VFMSUB_S, VFNMSUB_S, VFNMADD_S,
    VFMADD_D, VFMSUB_D, VFNMSUB_D, VFNMADD_D)
  if (use_fcvt) oplist1 += (VFCVT_S_D, VFCVT_D_S, VFCVT_S_L, VFCVT_S_LU, VFCVT_S_W,
    VFCVT_S_WU, VFCVT_D_L, VFCVT_D_LU, VFCVT_D_W, VFCVT_D_WU, VFCVT_L_S,
    VFCVT_LU_S, VFCVT_W_S, VFCVT_WU_S, VFCVT_L_D, VFCVT_LU_D,
    VFCVT_W_D, VFCVT_WU_D)

  for (op <- oplist1)
  {
    candidates += seq_src1(op,vregs,vregs)
    candidates += seq_src1(op,sregs,sregs)

    if (use_mix)
    {
      candidates += seq_src1(op,vregs,sregs)
    }
  }
  for (op <- oplist2)
  {
    candidates += seq_src2(op,vregs,vregs,vregs)
    candidates += seq_src2(op,sregs,sregs,sregs)

    if (use_mix)
    {
      candidates += seq_src2(op,vregs,vregs,sregs)
      candidates += seq_src2(op,vregs,sregs,vregs)
      candidates += seq_src2(op,vregs,sregs,sregs)
    }
  }
  for (op <- oplist3)
  {
    candidates += seq_src3(op,vregs,vregs,vregs,vregs)
    candidates += seq_src3(op,sregs,sregs,sregs,sregs)

    if (use_mix)
    {
      candidates += seq_src3(op,vregs,vregs,vregs,sregs)
      candidates += seq_src3(op,vregs,vregs,sregs,vregs)
      candidates += seq_src3(op,vregs,vregs,sregs,sregs)
      candidates += seq_src3(op,vregs,sregs,vregs,sregs)
      candidates += seq_src3(op,vregs,sregs,sregs,vregs)
      candidates += seq_src3(op,vregs,sregs,sregs,sregs)
    }
  }

  rand_pick(candidates)()
}
