package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqBranch(xregs: HWRegPool) extends InstSeq
{
  override val seqname = "xbranch"
  val taken = Label("__needs_branch_patch")
  val nottakens = ArrayBuffer[Label](Label("crash_backward"), Label("crash_forward"))
  val nottaken = rand_pick(nottakens)
  def reverse_label(l: Label) = if(l == taken) nottaken else taken

  def helper_two_srcs_sameval_samereg_any() = () =>
  {
    val reg_src = reg_read_any(xregs)
    (reg_src, reg_src)
  }

  def helper_two_srcs_sameval_samereg_zero() = () =>
  {
    val reg_src = reg_read_zero(xregs)
    (reg_src, reg_src)
  }

  def helper_two_srcs_sameval_diffreg_any() = () =>
  {
    val reg_src = reg_read_any(xregs)
    val reg_dst1 = reg_write(xregs, reg_src)
    val reg_dst2 = reg_write(xregs, reg_dst1)
    insts += ADDI(reg_dst1, reg_src, Imm(0))
    insts += ADDI(reg_dst2, reg_dst1, Imm(0))
    (reg_dst1, reg_dst2)
  }

  def helper_two_srcs_sameval_diffreg_zero() = () =>
  {
    val reg_dst1 = reg_write_visible(xregs)
    val reg_dst2 = reg_write(xregs)
    insts += ADDI(reg_dst1, reg_read_zero(xregs), Imm(0))
    insts += ADDI(reg_dst2, reg_read_zero(xregs), Imm(0))
    (reg_dst1, reg_dst2)
  }

  def helper_two_srcs_diffval_diffreg_bothpos() = () =>
  {
    val reg_dst1 = reg_write_visible(xregs)
    val reg_dst2 = reg_write(xregs, reg_dst1)

    insts += ADDI(reg_dst1, reg_read_zero(xregs), Imm(rand_filter(rand_imm, (x) => x > 0)))
    insts += ADDI(reg_dst2, reg_dst1, Imm(rand_filter(rand_imm, (x) => x > 0)))

    // signed (+, ++), unsigned (+, ++)
    (reg_dst1, reg_dst2)
  }

  def helper_two_srcs_diffval_diffreg_bothneg() = () =>
  {
    val reg_dst1 = reg_write_visible(xregs)
    val reg_dst2 = reg_write(xregs, reg_dst1)

    insts += ADDI(reg_dst1, reg_read_zero(xregs), Imm(rand_filter(rand_imm, (x) => x < 0)))
    insts += ADDI(reg_dst2, reg_dst1, Imm(rand_filter(rand_imm, (x) => x < 0)))

    // signed (-, --), unsigned (++++, +++)
    (reg_dst1, reg_dst2)
  }

  def helper_two_srcs_sameval_diffreg_oppositesign() = () =>
  {
    val reg_src = reg_read_any(xregs)
    val reg_dst1 = reg_write(xregs, reg_src)
    val reg_dst2 = reg_write(xregs, reg_src)
    val reg_one = reg_write_visible(xregs)
    val reg_mask = reg_write_visible(xregs)

    insts += ADDI(reg_one, reg_read_zero(xregs), Imm(1))
    insts += SLL(reg_one, reg_one, Imm(31))
    insts += ADDI(reg_mask, reg_read_zero(xregs), Imm(-1))
    insts += XOR(reg_mask, reg_mask, reg_one)
    insts += AND(reg_dst1, reg_src, reg_mask)
    insts += OR(reg_dst2, reg_dst1, reg_one)

    // reg_dest1 sign bit 0, reg_dest2 sign bit 1
    (reg_dst1, reg_dst2)
  }

  def helper_two_srcs_diffval_diffreg_oppositesign() = () =>
  {
    val reg_src1 = reg_read_any(xregs)
    val reg_src2 = reg_read_any(xregs)
    val reg_dst1 = reg_write(xregs, reg_src1)
    val reg_dst2 = reg_write(xregs, reg_src2)
    val reg_one = reg_write_visible(xregs)
    val reg_mask = reg_write_visible(xregs)

    insts += ADDI(reg_one, reg_read_zero(xregs), Imm(1))
    insts += SLL(reg_one, reg_one, Imm(31))
    insts += ADDI(reg_mask, reg_read_zero(xregs), Imm(-1))
    insts += XOR(reg_mask, reg_mask, reg_one)
    insts += AND(reg_dst1, reg_src1, reg_mask)
    insts += OR(reg_dst2, reg_src2, reg_one)

    // reg_dest1 sign bit 0, reg_dest2 sign bit 1
    (reg_dst1, reg_dst2)
  }

  def seq_taken_j() = () =>
  {
    insts += J(taken)
  }

  def seq_taken_jal() = () =>
  {
    val reg_x1 = reg_write_ra(xregs)
    insts += JAL(taken)
  }

  def seq_taken_jalr() = () =>
  {
    val reg_x1 = reg_write_ra(xregs)
    val reg_src1 = reg_read_zero(xregs)
    val reg_dst1 = reg_write_hidden(xregs)
    val reg_dst2 = reg_write_hidden(xregs)

    insts += LA(reg_dst1, Label("__needs_jalr_patch1"))
    insts += JALR(reg_dst2, reg_dst1, Label("__needs_jalr_patch2"))
  }

  def get_two_regs_and_branch_with_label( op: Opcode, helper: () => (Operand, Operand), label: Label, flip_ops:Boolean = false) = () =>
  {
    val regs = helper()
    if(!flip_ops) insts += op(regs._1, regs._2, label) else insts += op(regs._2, regs._1, label) 
  }

  // These tests have the same labels if the operand order is reversed
  val reversible_tests = List(
    (BEQ,  helper_two_srcs_sameval_samereg_any,          taken),
    (BEQ,  helper_two_srcs_sameval_samereg_zero,         taken),
    (BEQ,  helper_two_srcs_sameval_diffreg_any,          taken),
    (BEQ,  helper_two_srcs_sameval_diffreg_zero,         taken),
    (BEQ,  helper_two_srcs_diffval_diffreg_bothpos,      nottaken),
    (BEQ,  helper_two_srcs_diffval_diffreg_bothneg,      nottaken),
    (BEQ,  helper_two_srcs_sameval_diffreg_oppositesign, nottaken),
    (BEQ,  helper_two_srcs_diffval_diffreg_oppositesign, nottaken),
    (BNE,  helper_two_srcs_sameval_samereg_any,          nottaken),
    (BNE,  helper_two_srcs_sameval_samereg_zero,         nottaken),
    (BNE,  helper_two_srcs_sameval_diffreg_any,          nottaken),
    (BNE,  helper_two_srcs_sameval_diffreg_zero,         nottaken),
    (BNE,  helper_two_srcs_diffval_diffreg_bothpos,      taken),
    (BNE,  helper_two_srcs_diffval_diffreg_bothneg,      taken),
    (BNE,  helper_two_srcs_sameval_diffreg_oppositesign, taken),
    (BNE,  helper_two_srcs_diffval_diffreg_oppositesign, taken),
    (BLT,  helper_two_srcs_sameval_samereg_any,          nottaken),
    (BLT,  helper_two_srcs_sameval_samereg_zero,         nottaken),
    (BLT,  helper_two_srcs_sameval_diffreg_any,          nottaken),
    (BLT,  helper_two_srcs_sameval_diffreg_zero,         nottaken),
    (BLTU, helper_two_srcs_sameval_samereg_any,          nottaken),
    (BLTU, helper_two_srcs_sameval_samereg_zero,         nottaken),
    (BLTU, helper_two_srcs_sameval_diffreg_any,          nottaken),
    (BLTU, helper_two_srcs_sameval_diffreg_zero,         nottaken),
    (BGE,  helper_two_srcs_sameval_samereg_any,          taken),
    (BGE,  helper_two_srcs_sameval_samereg_zero,         taken),
    (BGE,  helper_two_srcs_sameval_diffreg_any,          taken),
    (BGE,  helper_two_srcs_sameval_diffreg_zero,         taken),
    (BGEU, helper_two_srcs_sameval_samereg_any,          taken),
    (BGEU, helper_two_srcs_sameval_samereg_zero,         taken),
    (BGEU, helper_two_srcs_sameval_diffreg_any,          taken),
    (BGEU, helper_two_srcs_sameval_diffreg_zero,         taken)
  )

  // These tests need opposite labels if the operand order is reversed
  val chiral_tests = List(
    (BLT,  helper_two_srcs_diffval_diffreg_bothpos,      taken),
    (BLT,  helper_two_srcs_diffval_diffreg_bothneg,      nottaken),
    (BLT,  helper_two_srcs_sameval_diffreg_oppositesign, nottaken),
    (BLT,  helper_two_srcs_diffval_diffreg_oppositesign, nottaken),
    (BLTU, helper_two_srcs_diffval_diffreg_bothpos,      taken),
    (BLTU, helper_two_srcs_diffval_diffreg_bothneg,      nottaken),
    (BLTU, helper_two_srcs_sameval_diffreg_oppositesign, taken),
    (BLTU, helper_two_srcs_diffval_diffreg_oppositesign, taken),
    (BGE,  helper_two_srcs_diffval_diffreg_bothpos,      nottaken),
    (BGE,  helper_two_srcs_diffval_diffreg_bothneg,      taken),
    (BGE,  helper_two_srcs_sameval_diffreg_oppositesign, taken),
    (BGE,  helper_two_srcs_diffval_diffreg_oppositesign, taken),
    (BGEU, helper_two_srcs_diffval_diffreg_bothpos,      nottaken),
    (BGEU, helper_two_srcs_diffval_diffreg_bothneg,      taken),
    (BGEU, helper_two_srcs_sameval_diffreg_oppositesign, nottaken),
    (BGEU, helper_two_srcs_diffval_diffreg_oppositesign, nottaken)
 )

  val candidates = new ArrayBuffer[() => insts.type]

  candidates += seq_taken_j()
  candidates += seq_taken_jal()
  candidates += seq_taken_jalr()

  reversible_tests.foreach( t => candidates += get_two_regs_and_branch_with_label(t._1, t._2, t._3, false))
  chiral_tests.foreach( t => candidates += get_two_regs_and_branch_with_label(t._1, t._2, t._3, false))
  chiral_tests.foreach( t => candidates += get_two_regs_and_branch_with_label(t._1, t._2, reverse_label(t._3), true))

  rand_pick(candidates)()
}
