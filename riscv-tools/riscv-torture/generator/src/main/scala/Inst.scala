package torture

class Inst(opcode: String, val operands: Array[Operand])
{
  def optype(): String = {
    if (is_alu) return "alu"
    if (is_cmp) return "cmp"
    if (is_branch) return "branch"
    if (is_jalr) return "jalr"
    if (is_jmp) return "jmp"
    if (is_la) return "la"
    if (is_mem) return "mem"
    if (is_amo) return "amo"
    if (is_misc) return "misc"
    if (is_fpalu) return "fpalu"
    if (is_fpcmp) return "fpcmp"
    if (is_fpfma) return "fpfma"
    if (is_fpmem) return "fpmem"
    if (is_fpcvt) return "fpcvt"
    if (is_fpmisc) return "fpmisc"
    if (is_vshared) return "vshared"
    if (is_valu) return "valu"
    if (is_vfpalu) return "vfpalu"
    if (is_vfpfma) return "vfpfma"
    if (is_vfpcvt) return "vfpcvt"
    if (is_vsmem) return "vsmem"
    if (is_vshared) return "vshared"
    if (is_vcmp) return "vcmp"
    if (is_vpred) return "vpred"
    if (is_vmem) return "vmem"
    if (is_vamo) return "vamo"
    if (is_vmisc) return "vmisc"
    return "unknown" //Shouldn't return this.
  }

  def opcode(): String = { return opcode }

  def is_branch = List("beq", "bne", "blt", "bge", "bltu", "bgeu", "c.beqz", "c.bnez").contains(opcode)

  def is_jalr = List("jalr", "c.jalr").contains(opcode)

  def is_jmp = List("jal", "c.jal").contains(opcode)

  def is_la = opcode == "la"

  def is_mem = List("lb", "lh", "lw", "ld", "lbu", "lhu", "lwu", "sb", "sh", "sw", "sd", "c.lwsp", "c.swsp", "c.lw", "c.sw").contains(opcode)

  def is_amo = List("amoadd.w", "amoswap.w", "amoand.w", "amoor.w", "amomin.w", "amominu.w",
    "amomax.w", "amomaxu.w", "amoxor.w", "amoadd.d", "amoswap.d", "amoand.d", "amoor.d",
    "amomin.d", "amominu.d", "amomax.d", "amomaxu.d", "amoxor.d").contains(opcode)

  def is_cmp = List("slti", "sltiu", "slt", "sltu").contains(opcode)

  def is_alu = List("addi", "slli", "xori", "srli", "srai", "ori", "andi",
    "add", "sub", "sll", "xor", "srl", "sra", "or", "and", "mul", "mulh",
    "mulhsu", "mulhu", "div", "divu", "rem", "remu", "lui", "addiw", "slliw", "srliw",
    "sraiw", "addw", "subw", "sllw", "srlw", "sraw", "mulw", "divw", "divuw", "remw",
    "remuw", "c.li", "c.lui", "c.add", "c.mv", "c.add", "c.or", "c.xor", "c.sub", "c.addi", "c.addi16sp", "c.addi4spn", "c.slli", 
    "c.srli", "c.srai", "c.andi").contains(opcode)

  def is_fpmem = List("flw", "fld", "fsw", "fsd").contains(opcode)

  def is_fpalu = List("fadd.s", "fsub.s", "fmul.s", "fdiv.s", "fsqrt.s", "fmin.s", "fmax.s",
    "fadd.d", "fsub.d", "fmul.d", "fdiv.d", "fsqrt.d", "fmin.d", "fmax.d",
    "fsgnj.s", "fsgnjn.s", "fsgnjx.s", "fsgnj.d", "fsgnjn.d", "fsgnjx.d").contains(opcode)

  def is_fpfma = List("fmadd.s", "fmsub.s", "fnmsub.s", "fnmadd.s",
    "fmadd.d", "fmsub.d", "fnmsub.d", "fnmadd.d").contains(opcode)

  def is_fpcvt = List("fcvt.s.d", "fcvt.d.s", "fcvt.s.l", "fcvt.s.lu", "fcvt.s.w",
    "fcvt.s.wu", "fcvt.d.l", "fcvt.d.lu", "fcvt.d.w", "fcvt.d.wu", "fcvt.l.s",
    "fcvt.lu.s", "fcvt.w.s", "fcvt.wu.s", "fcvt.l.d", "fcvt.lu.d",
    "fcvt.w.d", "fcvt.wu.d").contains(opcode)

  def is_fpmisc = List("fmovz", "fmovn", "frsr", "fssr", "fmv.s.x", "fmv.x.s",
    "fmv.d.x", "fmv.x.d").contains(opcode)

  def is_fpcmp = List("feq.s", "flt.s", "fle.s", "feq.d", "flt.d", "fle.d").contains(opcode)

  def is_misc = List("syscall", "break", "rdcycle", "rdtime", "rdinstret",
    "nop", "li", "mfpcr", "mtpcr", "auipc", "movz", "movn", "fence.i", "fence").contains(opcode)

  def is_vshared = List("vaddi", "vslli", "vxori", "vsrli", "vsrai", "vori", "vandi", "vlui",
    "vaddiw", "vslliw", "vsrliw", "vsraiw").contains(opcode)

  def is_valu = List("vadd", "vsub", "vsll", "vxor", "vsrl", "vsra", "vor", "vand", "vmul", "vmulh",
    "vmulhsu", "vmulhu", "vdiv", "vdivu", "vrem", "vremu", "vaddw", "vsubw", "vsllw",
    "vsrlw", "vsraw", "vmulw", "vdivw", "vdivuw", "vremw", "vremuw").contains(opcode)

  def is_vpred = List("vpop", "vpset", "vpclear").contains(opcode)

  def is_vcmp = List("vcmpeq", "vcmplt", "vcmpltu", "vcmpfeq", "vcmpflt", "vcmfle").contains(opcode)

  def is_vfpalu = List("vfadd.s", "vfsub.s", "vfmul.s", "vfdiv.s", "vfsqrt.s", "vfmin.s", "vfmax.s",
    "vfadd.d", "vfsub.d", "vfmul.d", "vfdiv.d", "vfsqrt.d", "vfmin.d", "vfmax.d",
    "vfsgnj.s", "vfsgnjn.s", "vfsgnjx.s", "vfsgnj.d", "vfsgnjn.d", "vfsgnjx.d").contains(opcode)

  def is_vfpfma = List("vfmadd.s", "vfmsub.s", "vfnmsub.s", "vfnmadd.s",
    "vfmadd.d", "vfmsub.d", "vfnmsub.d", "vfnmadd.d").contains(opcode)

  def is_vfpcvt = List("vfcvt.s.d", "vfcvt.d.s", "vfcvt.s.l", "vfcvt.s.lu", "vfcvt.s.w",
    "vfcvt.s.wu", "vfcvt.d.l", "vfcvt.d.lu", "vfcvt.d.w", "vfcvt.d.wu", "vfcvt.l.s",
    "vfcvt.lu.s", "vfcvt.w.s", "vfcvt.wu.s", "vfcvt.l.d", "vfcvt.lu.d",
    "vfcvt.w.d", "vfcvt.wu.d").contains(opcode)

  def is_vsmem = List("vlsb", "vlsh", "vlsw", "vlsd", "vlsbu", "vlshu", "vlswu", "vssb", "vssh", "vssw", "vssd",
    "vlab", "vlah", "vlaw", "vlad", "vlabu", "vlahu", "vlawu", "vsab", "vsah", "vsaw", "vsad").contains(opcode)

  def is_vmem = List("vlb", "vlh", "vlw", "vld", "vlbu", "vlhu", "vlwu", "vsb", "vsh", "vsw", "vsd",
  "vlsegb", "vlsegh", "vlsegw", "vlsegd", "vlsegbu", "vlseghu", "vlsegwu", "vssegb", "vssegh", "vssegw", "vssegd",
  "vlstb", "vlsth", "vlstw", "vlstd", "vlstbu", "vlsthu", "vlstwu", "vsstb", "vssth", "vsstw", "vsstd",
  "vlsegstb", "vlsegsth", "vlsegstw", "vlsegstd", "vlsegstbu", "vlsegsthu", "vlsegstwu", "vssegstb", "vssegsth", "vssegstw", "vssegstd",
    "vlxb", "vlxh", "vlxw", "vlxd", "vlxbu", "vlxhu", "vlxwu", "vsxb", "vsxh", "vsxw", "vsxd",
    "vlsegxb", "vlsegxh", "vlsegxw", "vlsegxd", "vlsegxbu", "vlsegxhu", "vlsegxwu", "vssegxb", "vssegxh", "vssegxw", "vssegxd").contains(opcode)

  def is_vamo = List("vamoadd.w", "vamoswap.w", "vamoand.w", "vamoor.w", "vamomin.w", "vamominu.w",
    "vamomax.w", "vamomaxu.w", "vamoxor.w", "vamoadd.d", "vamoswap.d", "vamoand.d", "vamoor.d",
    "vamomin.d", "vamominu.d", "vamomax.d", "vamomaxu.d", "vamoxor.d").contains(opcode)

  def is_vmisc = List("vsetcfg", "vstop", "vsetvl", "veidx", "vf",
    "vmcs", "vmca", "fence").contains(opcode)

  override def toString =
  {
    operands.find(op => op.isInstanceOf[PredReg]) match {
      case Some(pred) => pred + " " + opcode +
        operands.filterNot(op => op.isInstanceOf[PredReg]).mkString(" ", ", ", "")
      case None => opcode + operands.mkString(" ", ", ", "")
    }
  }
}

class Opcode(val name: String)
{
  def apply(opnds: Operand*) = new Inst(name, opnds.toArray)
}

object J extends Opcode("j")
object JAL extends Opcode("jal")
object JALR extends Opcode("jalr")
object BEQ extends Opcode("beq")
object BNE extends Opcode("bne")
object BLT extends Opcode("blt")
object BGE extends Opcode("bge")
object BLTU extends Opcode("bltu")
object BGEU extends Opcode("bgeu")

object LA extends Opcode("la")
object LB extends Opcode("lb")
object LH extends Opcode("lh")
object LW extends Opcode("lw")
object LD extends Opcode("ld")
object LBU extends Opcode("lbu")
object LHU extends Opcode("lhu")
//object LWU extends Opcode("lwu")
object SB extends Opcode("sb")
object SH extends Opcode("sh")
object SW extends Opcode("sw")
object SD extends Opcode("sd")

object AMOADD_W extends Opcode("amoadd.w")
object AMOSWAP_W extends Opcode("amoswap.w")
object AMOAND_W extends Opcode("amoand.w")
object AMOOR_W extends Opcode("amoor.w")
object AMOMIN_W extends Opcode("amomin.w")
object AMOMINU_W extends Opcode("amominu.w")
object AMOMAX_W extends Opcode("amomax.w")
object AMOMAXU_W extends Opcode("amomaxu.w")
object AMOXOR_W extends Opcode("amoxor.w")
object AMOADD_D extends Opcode("amoadd.d")
object AMOSWAP_D extends Opcode("amoswap.d")
object AMOAND_D extends Opcode("amoand.d")
object AMOOR_D extends Opcode("amoor.d")
object AMOMIN_D extends Opcode("amomin.d")
object AMOMINU_D extends Opcode("amominu.d")
object AMOMAX_D extends Opcode("amomax.d")
object AMOMAXU_D extends Opcode("amomaxu.d")
object AMOXOR_D extends Opcode("amoxor.d")

object ADDI extends Opcode("addi")
object SLLI extends Opcode("slli")
object SLTI extends Opcode("slti")
object SLTIU extends Opcode("sltiu")
object XORI extends Opcode("xori")
object SRLI extends Opcode("srli")
object SRAI extends Opcode("srai")
object ORI extends Opcode("ori")
object ANDI extends Opcode("andi")
object ADD extends Opcode("add")
object SUB extends Opcode("sub")
object SLL extends Opcode("sll")
object SLT extends Opcode("slt")
object SLTU extends Opcode("sltu")
object XOR extends Opcode("xor")
object SRL extends Opcode("srl")
object SRA extends Opcode("sra")
object OR extends Opcode("or")
object AND extends Opcode("and")
object MUL extends Opcode("mul")
object MULH extends Opcode("mulh")
object MULHSU extends Opcode("mulhsu")
object MULHU extends Opcode("mulhu")
object DIV extends Opcode("div")
object DIVU extends Opcode("divu")
object REM extends Opcode("rem")
object REMU extends Opcode("remu")
object LUI extends Opcode("lui")

//tianchuan:We construct c instruction architecture
//*************************************************
object C_LI extends Opcode("c.li")
object C_LUI extends Opcode("c.lui")
object C_LWSP extends Opcode("c.lwsp")
object C_SWSP extends Opcode("c.swsp")
object C_LW extends Opcode("c.lw")
object C_SW extends Opcode("c.sw")
object C_ADD extends Opcode("c.add")
object C_MV extends Opcode("c.mv")
object C_AND extends Opcode("c.and")
object C_OR extends Opcode("c.or")
object C_XOR extends Opcode("c.xor")
object C_SUB extends Opcode("c.sub")
object C_ADDI extends Opcode("c.addi")
object C_ADDI16SP extends Opcode("c.addi16sp")
object C_ADDI4SPN extends Opcode("c.addi4spn")
object C_SLLI extends Opcode("c.slli")
object C_SRLI extends Opcode("c.srli")
object C_SRAI extends Opcode("c.srai")
object C_ANDI extends Opcode("c.andi")
object C_BEQZ extends Opcode("c.beqz")
object C_BNEZ extends Opcode("c.bnez")
object C_J extends Opcode("c.j")
object C_JAL extends Opcode("c.jal")
object C_JALR extends Opcode("c.jalr")


//object ADDIW extends Opcode("addiw")
//object SLLIW extends Opcode("slliw")
//object SRLIW extends Opcode("srliw")
//object SRAIW extends Opcode("sraiw")
//object ADDW extends Opcode("addw")
//object SUBW extends Opcode("subw")
//object SLLW extends Opcode("sllw")
//object SRLW extends Opcode("srlw")
//object SRAW extends Opcode("sraw")
//object MULW extends Opcode("mulw")
//object DIVW extends Opcode("divw")
//object DIVUW extends Opcode("divuw")
//object REMW extends Opcode("remw")
//object REMUW extends Opcode("remuw")

object FLW extends Opcode("flw")
object FLD extends Opcode("fld")
object FSW extends Opcode("fsw")
object FSD extends Opcode("fsd")

object FADD_S extends Opcode("fadd.s")
object FSUB_S extends Opcode("fsub.s")
object FMUL_S extends Opcode("fmul.s")
object FDIV_S extends Opcode("fdiv.s")
object FSQRT_S extends Opcode("fsqrt.s")
object FMIN_S extends Opcode("fmin.s")
object FMAX_S extends Opcode("fmax.s")
object FADD_D extends Opcode("fadd.d")
object FSUB_D extends Opcode("fsub.d")
object FMUL_D extends Opcode("fmul.d")
object FDIV_D extends Opcode("fdiv.d")
object FSQRT_D extends Opcode("fsqrt.d")
object FMIN_D extends Opcode("fmin.d")
object FMAX_D extends Opcode("fmax.d")
object FSGNJ_S extends Opcode("fsgnj.s")
object FSGNJN_S extends Opcode("fsgnjn.s")
object FSGNJX_S extends Opcode("fsgnjx.s")
object FSGNJ_D extends Opcode("fsgnj.d")
object FSGNJN_D extends Opcode("fsgnjn.d")
object FSGNJX_D extends Opcode("fsgnjx.d")

object FMADD_S extends Opcode("fmadd.s")
object FMSUB_S extends Opcode("fmsub.s")
object FNMSUB_S extends Opcode("fnmsub.s")
object FNMADD_S extends Opcode("fnmadd.s")
object FMADD_D extends Opcode("fmadd.d")
object FMSUB_D extends Opcode("fmsub.d")
object FNMSUB_D extends Opcode("fnmsub.d")
object FNMADD_D extends Opcode("fnmadd.d")

object FCVT_S_D extends Opcode("fcvt.s.d")
object FCVT_D_S extends Opcode("fcvt.d.s")
object FCVT_S_L extends Opcode("fcvt.s.l")
object FCVT_S_LU extends Opcode("fcvt.s.lu")
object FCVT_S_W extends Opcode("fcvt.s.w")
object FCVT_S_WU extends Opcode("fcvt.s.wu")
object FCVT_D_L extends Opcode("fcvt.d.l")
object FCVT_D_LU extends Opcode("fcvt.d.lu")
object FCVT_D_W extends Opcode("fcvt.d.w")
object FCVT_D_WU extends Opcode("fcvt.d.wu")
object FCVT_L_S extends Opcode("fcvt.l.s")
object FCVT_LU_S extends Opcode("fcvt.lu.s")
object FCVT_W_S extends Opcode("fcvt.w.s")
object FCVT_WU_S extends Opcode("fcvt.wu.s")
object FCVT_L_D extends Opcode("fcvt.l.d")
object FCVT_LU_D extends Opcode("fcvt.lu.d")
object FCVT_W_D extends Opcode("fcvt.w.d")
object FCVT_WU_D extends Opcode("fcvt.wu.d")

object FMV_X_S extends Opcode("fmv.x.s")
object FMV_S_X extends Opcode("fmv.s.x")
object FMV_X_D extends Opcode("fmv.x.d")
object FMV_D_X extends Opcode("fmv.d.x")

object FRSR extends Opcode("frsr")
object FSSR extends Opcode("fssr")

object FEQ_S extends Opcode("feq.s")
object FLT_S extends Opcode("flt.s")
object FLE_S extends Opcode("fle.s")
object FEQ_D extends Opcode("feq.d")
object FLT_D extends Opcode("flt.d")
object FLE_D extends Opcode("fle.d")

object FENCE_I extends Opcode("fence.i")
object FENCE extends Opcode("fence")

object SYSCALL extends Opcode("syscall")
object BREAK extends Opcode("break")
object RDCYCLE extends Opcode("rdcycle")
object RDTIME extends Opcode("rdtime")
object RDINSTRET extends Opcode("rdinstret")
object NOP extends Opcode("nop")
object LI extends Opcode("li")
object MFPCR extends Opcode("mfpcr")
object MTPCR extends Opcode("mtpcr")
object AUIPC extends Opcode("auipc")

object VVCFGIVL extends Opcode("vvcfgivl")
object VSTOP extends Opcode("vstop")
object VSETVL extends Opcode("vsetvl")
object VEIDX extends Opcode("veidx")
object VF extends Opcode("vf")
object VMCS extends Opcode("vmcs")
object VMCA extends Opcode("vmca")

object VADDI extends Opcode("vaddi")
object VSLLI extends Opcode("vslli")
object VXORI extends Opcode("vxori")
object VSRLI extends Opcode("vsrli")
object VSRAI extends Opcode("vsrai")
object VORI extends Opcode("vori")
object VANDI extends Opcode("vandi")
object VLUI extends Opcode("vlui")
object VADDIW extends Opcode("vaddiw")
object VSLLIW extends Opcode("vslliw")
object VSRLIW extends Opcode("vsrliw")
object VSRAIW extends Opcode("vsraiw")

object VADD extends Opcode("vadd")
object VSUB extends Opcode("vsub")
object VSLL extends Opcode("vsll")
object VXOR extends Opcode("vxor")
object VSRL extends Opcode("vsrl")
object VSRA extends Opcode("vsra")
object VOR extends Opcode("vor")
object VAND extends Opcode("vand")
object VMUL extends Opcode("vmul")
object VMULH extends Opcode("vmulh")
object VMULHSU extends Opcode("vmulhsu")
object VMULHU extends Opcode("vmulhu")
object VDIV extends Opcode("vdiv")
object VDIVU extends Opcode("vdivu")
object VREM extends Opcode("vrem")
object VREMU extends Opcode("vremu")
object VADDW extends Opcode("vaddw")
object VSUBW extends Opcode("vsubw")
object VSLLW extends Opcode("vsllw")
object VSRLW extends Opcode("vsrlw")
object VSRAW extends Opcode("vsraw")
object VMULW extends Opcode("vmulw")
object VDIVW extends Opcode("vdivw")
object VDIVUW extends Opcode("vdivuw")
object VREMW extends Opcode("vremw")
object VREMUW extends Opcode("vremuw")

object VCMPEQ extends Opcode("vcmpeq")
object VCMPLT extends Opcode("vcmplt")
object VCMPLTU extends Opcode("vcmpltu")
object VCMPFEQ extends Opcode("vcmpfeq")
object VCMPFLT extends Opcode("vcmpflt")
object VCMPFLE extends Opcode("vcmpfle")

object VPOP extends Opcode("vpop")
object VPSET extends Opcode("vpset")
object VPCLEAR extends Opcode("vpclear")

object VFADD_S extends Opcode("vfadd.s")
object VFSUB_S extends Opcode("vfsub.s")
object VFMUL_S extends Opcode("vfmul.s")
object VFDIV_S extends Opcode("vfdiv.s")
object VFSQRT_S extends Opcode("vfsqrt.s")
object VFMIN_S extends Opcode("vfmin.s")
object VFMAX_S extends Opcode("vfmax.s")
object VFADD_D extends Opcode("vfadd.d")
object VFSUB_D extends Opcode("vfsub.d")
object VFMUL_D extends Opcode("vfmul.d")
object VFDIV_D extends Opcode("vfdiv.d")
object VFSQRT_D extends Opcode("vfsqrt.d")
object VFMIN_D extends Opcode("vfmin.d")
object VFMAX_D extends Opcode("vfmax.d")
object VFSGNJ_S extends Opcode("vfsgnj.s")
object VFSGNJN_S extends Opcode("vfsgnjn.s")
object VFSGNJX_S extends Opcode("vfsgnjx.s")
object VFSGNJ_D extends Opcode("vfsgnj.d")
object VFSGNJN_D extends Opcode("vfsgnjn.d")
object VFSGNJX_D extends Opcode("vfsgnjx.d")

object VFMADD_S extends Opcode("vfmadd.s")
object VFMSUB_S extends Opcode("vfmsub.s")
object VFNMSUB_S extends Opcode("vfnmsub.s")
object VFNMADD_S extends Opcode("vfnmadd.s")
object VFMADD_D extends Opcode("vfmadd.d")
object VFMSUB_D extends Opcode("vfmsub.d")
object VFNMSUB_D extends Opcode("vfnmsub.d")
object VFNMADD_D extends Opcode("vfnmadd.d")

object VFCVT_S_D extends Opcode("vfcvt.s.d")
object VFCVT_D_S extends Opcode("vfcvt.d.s")
object VFCVT_S_L extends Opcode("vfcvt.s.l")
object VFCVT_S_LU extends Opcode("vfcvt.s.lu")
object VFCVT_S_W extends Opcode("vfcvt.s.w")
object VFCVT_S_WU extends Opcode("vfcvt.s.wu")
object VFCVT_D_L extends Opcode("vfcvt.d.l")
object VFCVT_D_LU extends Opcode("vfcvt.d.lu")
object VFCVT_D_W extends Opcode("vfcvt.d.w")
object VFCVT_D_WU extends Opcode("vfcvt.d.wu")
object VFCVT_L_S extends Opcode("vfcvt.l.s")
object VFCVT_LU_S extends Opcode("vfcvt.lu.s")
object VFCVT_W_S extends Opcode("vfcvt.w.s")
object VFCVT_WU_S extends Opcode("vfcvt.wu.s")
object VFCVT_L_D extends Opcode("vfcvt.l.d")
object VFCVT_LU_D extends Opcode("vfcvt.lu.d")
object VFCVT_W_D extends Opcode("vfcvt.w.d")
object VFCVT_WU_D extends Opcode("vfcvt.wu.d")

object VLSB extends Opcode("vlsb")
object VLSH extends Opcode("vlsh")
object VLSW extends Opcode("vlsw")
object VLSD extends Opcode("vlsd")
object VLSBU extends Opcode("vlsbu")
object VLSHU extends Opcode("vlshu")
object VLSWU extends Opcode("vlswu")
object VSSB extends Opcode("vssb")
object VSSH extends Opcode("vssh")
object VSSW extends Opcode("vssw")
object VSSD extends Opcode("vssd")
object VLAB extends Opcode("vlab")
object VLAH extends Opcode("vlah")
object VLAW extends Opcode("vlaw")
object VLAD extends Opcode("vlad")
object VLABU extends Opcode("vlabu")
object VLAHU extends Opcode("vlahu")
object VLAWU extends Opcode("vlawu")
object VSAB extends Opcode("vsab")
object VSAH extends Opcode("vsah")
object VSAW extends Opcode("vsaw")
object VSAD extends Opcode("vsad")

object VLB extends Opcode("vlb")
object VLH extends Opcode("vlh")
object VLW extends Opcode("vlw")
object VLD extends Opcode("vld")
object VLBU extends Opcode("vlbu")
object VLHU extends Opcode("vlhu")
object VLWU extends Opcode("vlwu")
object VSB extends Opcode("vsb")
object VSH extends Opcode("vsh")
object VSW extends Opcode("vsw")
object VSD extends Opcode("vsd")

object VLSEGB extends Opcode("vlsegb")
object VLSEGH extends Opcode("vlsegh")
object VLSEGW extends Opcode("vlsegw")
object VLSEGD extends Opcode("vlsegd")
object VLSEGBU extends Opcode("vlsegbu")
object VLSEGHU extends Opcode("vlseghu")
object VLSEGWU extends Opcode("vlsegwu")
object VSSEGB extends Opcode("vssegb")
object VSSEGH extends Opcode("vssegh")
object VSSEGW extends Opcode("vssegw")
object VSSEGD extends Opcode("vssegd")

object VLSTB extends Opcode("vlstb")
object VLSTH extends Opcode("vlsth")
object VLSTW extends Opcode("vlstw")
object VLSTD extends Opcode("vlstd")
object VLSTBU extends Opcode("vlstbu")
object VLSTHU extends Opcode("vlsthu")
object VLSTWU extends Opcode("vlstwu")
object VSSTB extends Opcode("vsstb")
object VSSTH extends Opcode("vssth")
object VSSTW extends Opcode("vsstw")
object VSSTD extends Opcode("vsstd")

object VLSEGSTB extends Opcode("vlsegstb")
object VLSEGSTH extends Opcode("vlsegsth")
object VLSEGSTW extends Opcode("vlsegstw")
object VLSEGSTD extends Opcode("vlsegstd")
object VLSEGSTBU extends Opcode("vlsegstbu")
object VLSEGSTHU extends Opcode("vlsegsthu")
object VLSEGSTWU extends Opcode("vlsegstwu")
object VSSEGSTB extends Opcode("vssegstb")
object VSSEGSTH extends Opcode("vssegsth")
object VSSEGSTW extends Opcode("vssegstw")
object VSSEGSTD extends Opcode("vssegstd")

object VLXB extends Opcode("vlxb")
object VLXH extends Opcode("vlxh")
object VLXW extends Opcode("vlxw")
object VLXD extends Opcode("vlxd")
object VLXBU extends Opcode("vlxbu")
object VLXHU extends Opcode("vlxhu")
object VLXWU extends Opcode("vlxwu")
object VSXB extends Opcode("vsxb")
object VSXH extends Opcode("vsxh")
object VSXW extends Opcode("vsxw")
object VSXD extends Opcode("vsxd")

object VLSEGXB extends Opcode("vlsegxb")
object VLSEGXH extends Opcode("vlsegxh")
object VLSEGXW extends Opcode("vlsegxw")
object VLSEGXD extends Opcode("vlsegxd")
object VLSEGXBU extends Opcode("vlsegxbu")
object VLSEGXHU extends Opcode("vlsegxhu")
object VLSEGXWU extends Opcode("vlsegxwu")
object VSSEGXB extends Opcode("vssegxb")
object VSSEGXH extends Opcode("vssegxh")
object VSSEGXW extends Opcode("vssegxw")
object VSSEGXD extends Opcode("vssegxd")

object VAMOADD_W extends Opcode("vamoadd.w")
object VAMOSWAP_W extends Opcode("vamoswap.w")
object VAMOAND_W extends Opcode("vamoand.w")
object VAMOOR_W extends Opcode("vamoor.w")
object VAMOMIN_W extends Opcode("vamomin.w")
object VAMOMINU_W extends Opcode("vamominu.w")
object VAMOMAX_W extends Opcode("vamomax.w")
object VAMOMAXU_W extends Opcode("vamomaxu.w")
object VAMOXOR_W extends Opcode("vamoxor.w")
object VAMOADD_D extends Opcode("vamoadd.d")
object VAMOSWAP_D extends Opcode("vamoswap.d")
object VAMOAND_D extends Opcode("vamoand.d")
object VAMOOR_D extends Opcode("vamoor.d")
object VAMOMIN_D extends Opcode("vamomin.d")
object VAMOMINU_D extends Opcode("vamominu.d")
object VAMOMAX_D extends Opcode("vamomax.d")
object VAMOMAXU_D extends Opcode("vamomaxu.d")
object VAMOXOR_D extends Opcode("vamoxor.d")

object MOVZ extends Opcode("movz")
object MOVN extends Opcode("movn")
object FMOVZ extends Opcode("fmovz")
object FMOVN extends Opcode("fmovn")

object FENCE_V extends Opcode("fence")

object ILLEGAL extends Opcode(".word")
