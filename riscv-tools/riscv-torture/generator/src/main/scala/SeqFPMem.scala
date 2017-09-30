package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqFPMem(xregs: HWRegPool, fregs_s: HWRegPool, fregs_d: HWRegPool, mem: Mem) extends InstSeq
{
  override val seqname = "fpmem"

  def seq_load_addrfn(op: Opcode, addrfn: (Int) => Int, fregpool: HWRegPool) = () =>
  {
    val reg_addr = reg_write_hidden(xregs)
    val reg_dest = reg_write_visible(fregpool)
    val addr = addrfn(mem.size)
    val imm = rand_imm()
    insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_dest, RegImm(reg_addr, imm))
  }

  def seq_store_addrfn(op: Opcode, addrfn: (Int) => Int, fregpool: HWRegPool) = () =>
  {
    val reg_addr = reg_write_hidden(xregs)
    val reg_src = reg_read_visible(fregpool)
    val addr = addrfn(mem.size)
    val imm = rand_imm()
    insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_src, RegImm(reg_addr, imm))
  }
  
  val candidates = new ArrayBuffer[() => insts.type]
  candidates += seq_load_addrfn(FLW, rand_addr_w, fregs_s)
  candidates += seq_store_addrfn(FSW, rand_addr_w, fregs_s)
  candidates += seq_load_addrfn(FLD, rand_addr_d, fregs_d)
  candidates += seq_store_addrfn(FSD, rand_addr_d, fregs_d)

  rand_pick(candidates)()

}
