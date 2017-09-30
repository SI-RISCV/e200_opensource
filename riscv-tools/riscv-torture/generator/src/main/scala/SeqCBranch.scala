package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqCBranch(xregs: HWRegPool) extends InstSeq
{
  override val seqname = "xbranch"
  val taken = Label("__needs_branch_patch")
  val nottakens = ArrayBuffer[Label](Label("crash_backward"), Label("crash_forward"))
  val nottaken = rand_pick(nottakens)
  def reverse_label(l: Label) = if(l == taken) nottaken else taken

  def helper_two_srcs_sameval_samereg_any_c_x8_x15() = () =>
  {
    val reg_src = reg_read_x8_x15(xregs)
    (reg_src, reg_src)
  }

  def helper_two_srcs_sameval_samereg_zero_c_x8_x15() = () =>
  {
    val reg_src = reg_read_x8_x15(xregs)
    (reg_src, reg_src)
  }




//update
//*********************************************************
  def helper_two_srcs_sameval_diffreg_any_c_x8_x15() = () =>
  {
    val reg_dst1 = reg_read_x8_x15(xregs)
    val reg_dst2 = reg_read_x8_x15(xregs)
    insts += C_ADDI(reg_dst1, Imm(rand_imm_32_0_31))
    insts += C_ADDI(reg_dst2, Imm(rand_imm_32_0_31))
    (reg_dst1, reg_dst2) 
  }
  
  def helper_two_srcs_sameval_diffreg_zero_c_x8_x15() = () =>
  {
    val reg_dst1 = reg_write_visible_x8_x15(xregs)
    val reg_dst2 = reg_write_x8_x15(xregs)
    insts += C_ADDI(reg_dst1, Imm(rand_imm_32_0_31))
    insts += C_ADDI(reg_dst2, Imm(rand_imm_32_0_31))
    (reg_dst1, reg_dst2)
  }

  def helper_two_srcs_diffval_diffreg_bothpos_c_x8_x15() = () =>
  {
    val reg_dst1 = reg_write_visible_x8_x15(xregs)
    val reg_dst2 = reg_write_x8_x15(xregs)

    insts += C_ADDI(reg_dst1, Imm(rand_imm_32_0_31))
    insts += C_ADDI(reg_dst2, Imm(rand_imm_32_0_31))

    // signed (+, ++), unsigned (+, ++)
    (reg_dst1, reg_dst2)
  }
  
  def helper_two_srcs_diffval_diffreg_bothneg_c_x8_x15() = () =>
  {
    val reg_dst1 = reg_write_visible_x8_x15(xregs)
    val reg_dst2 = reg_write_visible_x8_x15(xregs)

    insts += C_ADDI(reg_dst1, Imm(rand_imm_32_0_31))
    insts += C_ADDI(reg_dst2, Imm(rand_imm_32_0_31))

    // signed (-, --), unsigned (++++, +++)
    (reg_dst1, reg_dst2)
  }

 //  def helper_two_srcs_sameval_diffreg_oppositesign_c_x8_x15() = () =>
 // {
 //   val reg_src = reg_read_x8_x15(xregs)
 //   val reg_dst1 = reg_write_x8x15(xregs, reg_src)
 //   val reg_dst2 = reg_write_x8x15(xregs, reg_src)
 //   val reg_one = reg_write_visible_x8_x15(xregs)
 //   val reg_mask = reg_write_visible_x8_x15(xregs)

 //   insts += ADDI(reg_one, reg_read_x8_x15(xregs), Imm(1))
 //   insts += SLL(reg_one, reg_one, Imm(31))
 //   insts += ADDI(reg_mask, reg_read_x8_x15(xregs), Imm(-1))
 //   insts += XOR(reg_mask, reg_mask, reg_one)
 //   insts += AND(reg_dst1, reg_src, reg_mask)
 //   insts += OR(reg_dst2, reg_dst1, reg_one)

 //   // reg_dest1 sign bit 0, reg_dest2 sign bit 1
 //   (reg_dst1, reg_dst2)
 // }
    def helper_two_srcs_sameval_diffreg_oppositesign_c_x8_x15() = () =>
   {
    val reg_src = reg_read_x8_x15(xregs)
    val reg_one = reg_write_visible_x8_x15(xregs)
    val reg_mask = reg_write_visible_x8_x15(xregs)

    insts += C_ADDI(reg_one, Imm(1))
    insts += C_SLLI(reg_one, Imm(31))
    insts += C_ADDI(reg_mask, Imm(-1))
    insts += C_XOR(reg_mask, reg_one)
    insts += C_AND(reg_src, reg_mask)
    insts += C_OR(reg_one, reg_src)

    // reg_dest1 sign bit 0, reg_dest2 sign bit 1
    (reg_one, reg_src)
  }


 // def helper_two_srcs_diffval_diffreg_oppositesign_c_x8_x15() = () =>
 // {
 //   val reg_src1 = reg_read_x8_x15(xregs)
 //   val reg_src2 = reg_read_x8_x15(xregs)
 //   val reg_dst1 = reg_write_x8x15(xregs, reg_src1)
 //   val reg_dst2 = reg_write_x8x15(xregs, reg_src2)
 //   val reg_one = reg_write_visible_x8_x15(xregs)
 //   val reg_mask = reg_write_visible_x8_x15(xregs)

 //   insts += ADDI(reg_one, reg_read_x8_x15(xregs), Imm(1))
 //   insts += SLL(reg_one, reg_one, Imm(31))
 //   insts += ADDI(reg_mask, reg_read_x8_x15(xregs), Imm(-1))
 //   insts += XOR(reg_mask, reg_mask, reg_one)
 //   insts += AND(reg_dst1, reg_src1, reg_mask)
 //   insts += OR(reg_dst2, reg_src2, reg_one)

 //   // reg_dest1 sign bit 0, reg_dest2 sign bit 1
 //   (reg_dst1, reg_dst2)
 // }

  def helper_two_srcs_diffval_diffreg_oppositesign_c_x8_x15() = () =>
  {
    val reg_src1 = reg_read_x8_x15(xregs)
    val reg_src2 = reg_read_x8_x15(xregs)
    val reg_one = reg_write_visible_x8_x15(xregs)
    val reg_mask = reg_write_visible_x8_x15(xregs)

    insts += C_ADDI(reg_one, Imm(1))
    insts += C_SLLI(reg_one, Imm(31))
    insts += C_ADDI(reg_mask, Imm(-1))
    insts += C_XOR(reg_mask, reg_one)
    insts += C_AND(reg_src1, reg_mask)
    insts += C_OR(reg_src2, reg_one)

    // reg_dest1 sign bit 0, reg_dest2 sign bit 1
    (reg_src1, reg_src2)
  }


  def seq_taken_c_j() = () =>
  {
    insts += C_J(taken)
  }

  def seq_taken_c_jal() = () =>
  {
    val reg_x1 = reg_write_ra(xregs)
    insts += C_JAL(taken)
  }

  def seq_taken_c_jalr() = () =>
  {
    val reg_x1 = reg_write_ra(xregs)
    val reg_src1 = reg_read_zero(xregs)
    val reg_dst1 = reg_write_hidden(xregs)
    val reg_dst2 = reg_write_hidden(xregs)

    //insts += LA(reg_dst1, Label("__needs_jalr_patch1"))
    insts += C_JALR(reg_dst2, reg_dst1, Label("__needs_jalr_patch2"))
  }
  
  //tianchuan:We construct c instruction architecture
  //*************************************************
  def get_one_regs_and_branch_with_label( op: Opcode, helper: () => (Operand, Operand), label: Label, flip_ops:Boolean = false) = () =>
  {
    val regs = helper()
    if(!flip_ops) insts += op(regs._1, label) else insts += op(regs._2, label) 
  }

  //tianchuan:We construct c instruction architecture
  //*************************************************
  val reversible_tests_c = List(
    (C_BEQZ,  helper_two_srcs_sameval_samereg_any_c_x8_x15,          taken),
    (C_BEQZ,  helper_two_srcs_sameval_samereg_zero_c_x8_x15,         taken),
    (C_BEQZ,  helper_two_srcs_sameval_diffreg_any_c_x8_x15,          taken),
    (C_BEQZ,  helper_two_srcs_sameval_diffreg_zero_c_x8_x15,         taken),
    (C_BEQZ,  helper_two_srcs_diffval_diffreg_bothpos_c_x8_x15,      nottaken),
    (C_BEQZ,  helper_two_srcs_diffval_diffreg_bothneg_c_x8_x15,      nottaken),
    (C_BEQZ,  helper_two_srcs_sameval_diffreg_oppositesign_c_x8_x15, nottaken),
    (C_BEQZ,  helper_two_srcs_diffval_diffreg_oppositesign_c_x8_x15, nottaken),
    (C_BNEZ,  helper_two_srcs_sameval_samereg_any_c_x8_x15,          nottaken),
    (C_BNEZ,  helper_two_srcs_sameval_samereg_zero_c_x8_x15,         nottaken),
    (C_BNEZ,  helper_two_srcs_sameval_diffreg_any_c_x8_x15,          nottaken),
    (C_BNEZ,  helper_two_srcs_sameval_diffreg_zero_c_x8_x15,         nottaken),
    (C_BNEZ,  helper_two_srcs_diffval_diffreg_bothpos_c_x8_x15,      taken),
    (C_BNEZ,  helper_two_srcs_diffval_diffreg_bothneg_c_x8_x15,      taken),
    (C_BNEZ,  helper_two_srcs_sameval_diffreg_oppositesign_c_x8_x15, taken),
    (C_BNEZ,  helper_two_srcs_diffval_diffreg_oppositesign_c_x8_x15, taken)
 )

  val candidates = new ArrayBuffer[() => insts.type]

  candidates += seq_taken_c_j()
  candidates += seq_taken_c_jal()
  candidates += seq_taken_c_jalr()

  reversible_tests_c.foreach( t => candidates += get_one_regs_and_branch_with_label(t._1, t._2, t._3, false))

  rand_pick(candidates)()
}
