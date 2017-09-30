package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqALU(xregs: HWRegPool, use_mul: Boolean, use_div: Boolean) extends InstSeq //TODO: better configuration
{
  override val seqname = "xalu"
  def seq_immfn(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_write_visible(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }

  def seq_src1(op: Opcode) = () =>
  {
    val src1 = reg_read_any(xregs)
    val dest = reg_write(xregs, src1)
    insts += op(dest, src1, src1)
  }

  def seq_src1_immfn(op: Opcode, immfn: () => Int) = () =>
  {
    val src1 = reg_read_any(xregs)
    val dest = reg_write(xregs, src1)
    val imm = Imm(immfn())
    insts += op(dest, src1, imm)
  }

  def seq_src1_zero(op: Opcode) = () =>
  {
    val src1 = reg_read_any(xregs)
    val dest = reg_write(xregs, src1)
    val tmp = reg_write_visible(xregs)
    insts += ADDI(tmp, reg_read_zero(xregs), Imm(rand_imm()))
    insts += op(dest, tmp, tmp)
  }

  def seq_src2(op: Opcode) = () =>
  {
    val src1 = reg_read_any(xregs)
    val src2 = reg_read_any(xregs)
    val dest = reg_write(xregs, src1, src2)
    insts += op(dest, src1, src2)
  }

  def seq_src2_zero(op: Opcode) = () =>
  {
    val src1 = reg_read_any(xregs)
    val dest = reg_write(xregs, src1)
    val tmp1 = reg_write_visible(xregs)
    val tmp2 = reg_write_visible(xregs)
    insts += ADDI(tmp1, reg_read_zero(xregs), Imm(rand_imm()))
    insts += ADDI(tmp2, reg_read_zero(xregs), Imm(rand_imm()))
    insts += op(dest, tmp1, tmp2)
  }

  val candidates = new ArrayBuffer[() => insts.type]

  candidates += seq_immfn(LUI, rand_bigimm)
  candidates += seq_src1_immfn(ADDI, rand_imm)
  candidates += seq_src1_immfn(SLLI, rand_imm_0_31)
  candidates += seq_src1_immfn(SLTI, rand_imm)
  candidates += seq_src1_immfn(SLTIU, rand_imm)
  candidates += seq_src1_immfn(XORI, rand_imm)
  candidates += seq_src1_immfn(SRLI, rand_imm_0_31)
  candidates += seq_src1_immfn(SRAI, rand_imm_0_31)
  candidates += seq_src1_immfn(ORI, rand_imm)
  candidates += seq_src1_immfn(ANDI, rand_imm)
  //candidates += seq_src1_immfn(ADDIW, rand_imm)
  //candidates += seq_src1_immfn(SLLIW, rand_shamtw)
  //candidates += seq_src1_immfn(SRLIW, rand_shamtw)
  //candidates += seq_src1_immfn(SRAIW, rand_shamtw)

  val oplist = new ArrayBuffer[Opcode]

  oplist += (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)
  //oplist += (ADDW, SUBW, SLLW, SRLW, SRAW)
  //if (use_mul) oplist += (MUL, MULH, MULHSU, MULHU, MULW)
  //if (use_div) oplist += (DIV, DIVU, REM, REMU, DIVW, DIVUW, REMW, REMUW)
  if (use_mul) oplist += (MUL, MULH, MULHSU, MULHU)
  if (use_div) oplist += (DIV, DIVU, REM, REMU)

  for (op <- oplist)
  {
    candidates += seq_src1(op)
    candidates += seq_src1_zero(op)
    candidates += seq_src2(op)
    candidates += seq_src2_zero(op)
  }

  rand_pick(candidates)()
}
