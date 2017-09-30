package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqMem(xregs: HWRegPool, mem: Mem, use_amo: Boolean) extends InstSeq
{
  override val seqname = "xmem"
  def seq_load_addrfn(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden(xregs)
    val reg_dest = reg_write_visible(xregs)
    val addr = addrfn(mem.size)
    val imm = rand_imm()

    insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_dest, RegImm(reg_addr, imm))
  }

  def seq_store_addrfn(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden(xregs)
    val reg_src = reg_read_visible(xregs)
    val addr = addrfn(mem.size)
    val imm = rand_imm()

    insts += LA(reg_addr, BaseImm(mem.toString, addr-imm))
    insts += op(reg_src, RegImm(reg_addr, imm))
  }

  def seq_amo_addrfn(op: Opcode, addrfn: (Int) => Int) = () =>
  {
    val reg_addr = reg_write_hidden(xregs)
    val reg_dest = reg_write_visible(xregs)
    val reg_src = reg_read_visible(xregs)
    val addr = addrfn(mem.size)

    insts += LA(reg_addr, BaseImm(mem.toString, addr))
    insts += op(reg_dest, reg_src, RegImm(reg_addr, 0))
  }

  // test st and ld sequences in which the double-word addresses match
  // but the lower-order bits may differ. Randomize whether the dependency
  // is ld->st or st->ld.
  def seq_stld_overlap() = () =>
  {
    object AccessType extends Enumeration
    {
       type AccessType = Value
       val byte, ubyte, hword, uhword, word, uword, dword = Value

       def getRandOpAndAddr (dw_addr: Int, is_store: Boolean): (Opcode, Int) =
       {
          val typ = AccessType.values.toIndexedSeq(rand_range(0,6))
          if (is_store)
          {
             if      (typ == byte  || typ ==ubyte)  (SB, dw_addr + rand_addr_b(8))
             else if (typ == hword || typ ==uhword) (SH, dw_addr + rand_addr_h(8))
             else if (typ ==  word || typ ==uword)  (SW, dw_addr + rand_addr_w(8))
             else                                   (SD, dw_addr)
          }
          else
          {
             if      (typ == byte)   (LB,  dw_addr + rand_addr_b(8))
             else if (typ == ubyte)  (LBU, dw_addr + rand_addr_b(8))
             else if (typ == hword)  (LH,  dw_addr + rand_addr_h(8))
             else if (typ == uhword) (LHU, dw_addr + rand_addr_h(8))
             else if (typ == word)   (LW,  dw_addr + rand_addr_w(8))
             //else if (typ == uword)  (LWU, dw_addr + rand_addr_w(8))
             else if (typ == uword)  (LW, dw_addr + rand_addr_w(8))
             else                    (LD,  dw_addr)
          }
       }
    }
    import AccessType._

    val l_reg_addr = reg_write_hidden(xregs)
    val s_reg_addr = reg_write_hidden(xregs)
    val s_reg_src  = reg_read_visible(xregs)
    val l_reg_dest = reg_write_visible(xregs)

    val dw_addr = rand_addr_d(mem.size)
    val s_imm = rand_imm()
    val l_imm = rand_imm()

    val (lop, l_addr) = AccessType.getRandOpAndAddr(dw_addr, is_store=false)
    val (sop, s_addr) = AccessType.getRandOpAndAddr(dw_addr, is_store=true)
    //println("dwaddr: " + dw_addr + ",sop: " + sop.name  + ",lop: " + lop.name + " saddr: " + s_addr + ", laddr: " + l_addr)

    insts += LA(l_reg_addr, BaseImm(mem.toString, l_addr-l_imm))
    insts += LA(s_reg_addr, BaseImm(mem.toString, s_addr-s_imm))
    if (math.random < 0.5)
    {
       insts += lop(l_reg_dest, RegImm(l_reg_addr, l_imm))
       insts += sop(s_reg_src, RegImm(s_reg_addr, s_imm))
    }
    else
    {
       insts += sop(s_reg_src, RegImm(s_reg_addr, s_imm))
       insts += lop(l_reg_dest, RegImm(l_reg_addr, l_imm))
    }
  }

  val candidates = new ArrayBuffer[() => insts.type]

  candidates += seq_stld_overlap()
  candidates += seq_stld_overlap()

  candidates += seq_load_addrfn(LB, rand_addr_b)
  candidates += seq_load_addrfn(LBU, rand_addr_b)
  candidates += seq_load_addrfn(LH, rand_addr_h)
  candidates += seq_load_addrfn(LHU, rand_addr_h)
  candidates += seq_load_addrfn(LW, rand_addr_w)
  //candidates += seq_load_addrfn(LWU, rand_addr_w)
  candidates += seq_load_addrfn(LD, rand_addr_d)

  candidates += seq_store_addrfn(SB, rand_addr_b)
  candidates += seq_store_addrfn(SH, rand_addr_h)
  candidates += seq_store_addrfn(SW, rand_addr_w)
  candidates += seq_store_addrfn(SD, rand_addr_d)

  if (use_amo) 
  {
    candidates += seq_amo_addrfn(AMOADD_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOSWAP_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOAND_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOOR_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOMIN_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOMINU_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOMAX_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOMAXU_W, rand_addr_w)
    candidates += seq_amo_addrfn(AMOADD_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOSWAP_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOAND_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOOR_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOMIN_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOMINU_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOMAX_D, rand_addr_d)
    candidates += seq_amo_addrfn(AMOMAXU_D, rand_addr_d)
  }

  rand_pick(candidates)()
}
