package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqCMem(xregs: HWRegPool, mem: Mem, use_amo: Boolean) extends InstSeq
{
  override val seqname = "xmem"
  //tianchuan:We construct c instruction architecture
  //*************************************************
  def seq_load_addrfn_c_lwsp(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden_x2(xregs)
    val reg_dest = reg_write_visible_nox0(xregs)
    val addr = addrfn(mem.size)
    val imm = 4*rand_imm_0_63()

   // insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_dest, RegImm(reg_addr, imm))
  }

  def seq_store_addrfn_c_swsp(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden_x2(xregs)
    val reg_src = reg_read_visible_nox0(xregs)
    val addr = addrfn(mem.size)
    val imm = 4*rand_imm_0_63()

   // insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_src, RegImm(reg_addr, imm))
  }

  def seq_load_addrfn_c_lw(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden_x8_x15(xregs)
    val reg_dest = reg_write_visible_x8_x15(xregs)
    val addr = addrfn(mem.size)
    val imm = 4*rand_imm_0_31()

    // insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_dest, RegImm(reg_addr, imm))
  }
  
  def seq_store_addrfn_c_sw(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden_x8_x15(xregs)
    val reg_src = reg_read_visible_x8_x15(xregs)
    val addr = addrfn(mem.size)
    val imm = 4*rand_imm_0_31()

  //  insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_src, RegImm(reg_addr, imm))
  }

  val candidates = new ArrayBuffer[() => insts.type]

  //tianchuan:We construct c instruction architecture
  //*************************************************
  candidates += seq_load_addrfn_c_lwsp(C_LWSP, rand_addr_c)
  candidates += seq_store_addrfn_c_swsp(C_SWSP, rand_addr_c)
  candidates += seq_load_addrfn_c_lw(C_LW, rand_addr_c)
  candidates += seq_store_addrfn_c_sw(C_SW, rand_addr_c)
  
  rand_pick(candidates)()                   
}                                           
                                            
                                           
                                            
                                            
                                            
                                           
                                            
                                            
                                            
                                            
                                            
                                            
                                           
                                            
                                            
                                            
