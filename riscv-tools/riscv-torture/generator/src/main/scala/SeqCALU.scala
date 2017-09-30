package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqCALU(xregs: HWRegPool, use_mul: Boolean, use_div: Boolean) extends InstSeq //TODO: better configuration
{
  override val seqname = "xalu"
  //tianchuan:We construct c instruction architecture
  //*************************************************
  def seq_src1_immfn_c_li(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_read_any_butnox0(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }

  def seq_immfn_c_lui(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_write_visible_c(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }

  def seq_src1_c_mv_c_add(op: Opcode) = () =>
  {
    val src1 = reg_read_any_butnox0(xregs)
    insts += op(src1, src1)
  }

  def seq_src1_c_and_c_or_c_xor_c_sub(op: Opcode) = () =>
  {
    val src1 = reg_read_x8_x15(xregs)
    val dest = reg_write_x8_x15(xregs)
    insts += op(dest, src1)
  }

  def seq_src1_immfn_c_addi(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_read_any_butnox0(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }
   
  def seq_src1_immfn_c_addi16sp(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_write_visible_x2(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }
  
  def seq_src1_immfn_c_addi4spn(op: Opcode, immfn: () => Int) = () =>
  {
    val src1 = reg_write_visible_x2(xregs)
    val dest = reg_write_x8_x15(xregs)
    val imm = Imm(immfn())
    insts += op(dest, src1, imm)
  }

  def seq_src1_immfn_c_slli(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_read_any_butnox0(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }

  def seq_src1_immfn_c_srli(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_write_x8_x15(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }

  def seq_src1_immfn_c_srai(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_write_x8_x15(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }

  def seq_src1_immfn_c_andi(op: Opcode, immfn: () => Int) = () =>
  {
    val dest = reg_write_x8_x15(xregs)
    val imm = Imm(immfn())
    insts += op(dest, imm)
  }





  //******************************************************
  //******************************************************

  val candidates = new ArrayBuffer[() => insts.type]
  //tianchuan:We construct c instruction architecture
  //*************************************************
  candidates += seq_src1_immfn_c_li(C_LI, rand_imm_32_0_31)
  candidates += seq_immfn_c_lui(C_LUI, rand_bigimm_c)
  candidates += seq_src1_c_mv_c_add(C_MV)
  candidates += seq_src1_c_mv_c_add(C_ADD)
  candidates += seq_src1_c_and_c_or_c_xor_c_sub(C_AND) 
  candidates += seq_src1_c_and_c_or_c_xor_c_sub(C_OR) 
  candidates += seq_src1_c_and_c_or_c_xor_c_sub(C_XOR) 
  candidates += seq_src1_c_and_c_or_c_xor_c_sub(C_SUB) 
  candidates += seq_src1_immfn_c_addi(C_ADDI, rand_imm_32_0_31) 
  candidates += seq_src1_immfn_c_addi16sp(C_ADDI16SP, rand_imm_32_0_31_16) 
  candidates += seq_src1_immfn_c_addi4spn(C_ADDI4SPN, rand_bigimm_4c) 
  candidates += seq_src1_immfn_c_slli(C_SLLI, rand_imm_1_31) 
  candidates += seq_src1_immfn_c_srli(C_SRLI, rand_imm_1_31) 
  candidates += seq_src1_immfn_c_srai(C_SRAI, rand_imm_1_31) 
  candidates += seq_src1_immfn_c_andi(C_ANDI, rand_imm_32_0_31) 
  
  rand_pick(candidates)()
}
