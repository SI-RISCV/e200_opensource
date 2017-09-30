package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

import HWRegState._

class HWRegPool
{
  val hwregs = new ArrayBuffer[HWReg]

  def backup() = { hwregs.map((x) => x.backup()) }
  def restore() = { hwregs.map((x) => x.restore()) }

  def is_fully_unallocated = hwregs.forall(_.is_unallocated)
  def size = hwregs.length
}

trait ScalarRegPool extends HWRegPool
{
  val name: String
  val regname: String
  val ldinst: String
  val stinst: String
  
  def init_regs() =
  {
    var s = name + "_init:\n"
    s += "\tla x31, " + name + "_init_data\n"
    for (i <- 0 to hwregs.length-1)
      s += "\t" + ldinst + " " + hwregs(i) + ", " + 8*i + "(x31)\n"
    s += "\n"
    s
  }
  
  def save_regs() =
  {
    var s = "\tla x1, " + name + "_output_data\n"
    for (i <- 0 to hwregs.length-1)
      if (hwregs(i).is_visible)
        s += "\t" + stinst + " " + hwregs(i) + ", " + 8*i + "(x1)\n"
    s += "\n"
    s
  }
  
  def init_regs_data() = 
  {
    var s = "\t.align 8\n"
    s += name + "_init_data:\n"
    for (i <- 0 to hwregs.length-1)
      s += (regname + i + "_init:\t.dword " + "0x%016x\n" format rand_biased) //Change randomization for FRegs
    s += "\n"
    s
  }
  
  def output_regs_data() =
  {
    var s = "\t.align 8\n"
    s += name + "_output_data:\n"
    for (i <- 0 to hwregs.length-1)
      s += (regname + i + "_output:\t.dword 0x%016x\n" format rand_dword)
    s += "\n"
    s
  }
}

trait PoolsMaster extends HWRegPool
{
  val regpools: ArrayBuffer[HWRegPool]
  override val hwregs = new ArrayBuffer[HWReg] //Override this in subclasses
  override def is_fully_unallocated = regpools.forall(_.is_fully_unallocated)
  override def size = regpools.map(_.size).sum
  def extract_pools() =
  {
    regpools
  }
  override def backup() =
  {
    regpools.map(_.backup()).flatten
  }
  override def restore() =
  {
    regpools.map(_.restore()).flatten
  }
}

class XRegsPool extends ScalarRegPool
{
  val (name, regname, ldinst, stinst) = ("xreg", "reg_x", "ld", "sd")

  hwregs += new HWReg("x0", true, false)
  for (i <- 1 to 31)
    hwregs += new HWReg("x" + i.toString(), true, true)
    
  override def save_regs() =
  {
    hwregs(1).state = HID
    super.save_regs()
  }
}

class FRegsMaster extends ScalarRegPool with PoolsMaster
{
  val (name,regname,ldinst,stinst) = ("freg","reg_f","fld","fsd") // and flw and fsw
  val s_reg_num = new ArrayBuffer[Int]
  val d_reg_num = new ArrayBuffer[Int]

  for (n <- 0 to 31)
    if(rand_range(0, 1) == 0) s_reg_num += n
    else d_reg_num += n

  // Ensure each pool has at least 5 members
  while(s_reg_num.length < 5)
  {
    val mv_n = rand_pick(d_reg_num)
    d_reg_num -= mv_n
    s_reg_num += mv_n
  }
  
  while(d_reg_num.length < 5)
  {
    val mv_n = rand_pick(s_reg_num)
    s_reg_num -= mv_n
    d_reg_num += mv_n
  }
  
  val s_regpool = new FRegsPool(s_reg_num.toArray)
  val d_regpool = new FRegsPool(d_reg_num.toArray)
  val regpools = ArrayBuffer(s_regpool.asInstanceOf[HWRegPool],
                 d_regpool.asInstanceOf[HWRegPool])
  override val hwregs = regpools.map(_.hwregs).flatten
  
  override def init_regs() = //Wrapper function
  {
    var s = "freg_init:\n"+"freg_s_init:\n"+"\tla x1, freg_init_data\n"
    for ((i, curreg) <- s_reg_num.zip(s_regpool.hwregs))
      s += "\tflw" + " " + curreg + ", " + 8*i + "(x1)\n"
    s += "\n"+"freg_d_init:\n"+"\tla x1, freg_init_data\n"
    for ((i, curreg) <- d_reg_num.zip(d_regpool.hwregs))
      s += "\tfld" + " " + curreg + ", " + 8*i + "(x1)\n"
    s += "\n\n"
    s
  } 
  override def save_regs() = //Wrapper function
  {
    var s = "freg_save:\n"+"\tla x1, freg_output_data\n"
    for ((i, curreg) <- s_reg_num.zip(s_regpool.hwregs))
      if (curreg.is_visible)
        s += "\tfsw" + " " + curreg + ", " + 8*i + "(x1)\n"
    s += "\n"+"\tla x1, freg_output_data\n"
    for ((i, curreg) <- d_reg_num.zip(d_regpool.hwregs))
      if (curreg.is_visible)
        s += "\tfsd" + " " + curreg + ", " + 8*i + "(x1)\n"
    s += "\n\n"
    s
  }
}

class FRegsPool(reg_nums: Array[Int] = (0 to 31).toArray) extends HWRegPool
{
  for (i <- reg_nums)
    hwregs += new HWReg("f" + i.toString(), true, true)
}

class VRegsMaster(num_xregs: Int, num_pregs: Int, num_sregs: Int) extends PoolsMaster
{
  assert(num_xregs >= 5, "For VRegMaster, num_xregs >=5 enforced")
  assert(num_pregs >= 1, "For VRegMaster, num_pregs >=1 enforced")

  val x_reg_num = (0 to (num_xregs-1))
  val p_reg_num = (0 to (num_pregs-1))
  val s_reg_num = (0 to (num_sregs-1))
  
  val x_regpool  = new VXRegsPool(x_reg_num.toArray)
  val p_regpool  = new VPRegsPool(p_reg_num.toArray)
  val s_regpool  = new VSRegsPool(s_reg_num.toArray)
  val a_regpool  = new VARegsPool()
  val regpools = 
    ArrayBuffer(x_regpool.asInstanceOf[HWRegPool], p_regpool.asInstanceOf[HWRegPool],
    s_regpool.asInstanceOf[HWRegPool], a_regpool.asInstanceOf[HWRegPool])  
  override val hwregs = regpools.map(_.hwregs).flatten

  def init_regs() =
  { 
    var s = "vreg_init:\n"
    s += s_regpool.init_regs()
    s
  }
  def save_regs() =
  { 
    var s = "vreg_save:\n"
    s += s_regpool.save_regs()
    s
  }
  def init_regs_data() =
  { 
    var s = "vreg_init_data:\n"
    s += s_regpool.init_regs_data()
    s
  }
  def output_regs_data() =
  { 
    var s = "vreg_output_data:\n"
    s += s_regpool.output_regs_data()
    s
  }
}

class VXRegsPool(reg_nums: Array[Int] = (0 to 255).toArray) extends HWRegPool
{
  for (i <- reg_nums)
    hwregs += new HWReg("vv" + i.toString(), true, true)
}

class VPRegsPool(reg_nums: Array[Int] = (0 to 15).toArray) extends HWRegPool
{
  for (i <- reg_nums)
    hwregs += new HWReg("vp" + i.toString(), true, true)
}

class VSRegsPool(reg_nums: Array[Int] = (0 to 255).toArray) extends HWRegPool
{
  hwregs += new HWReg("vs0", true, false)
  for (i <- reg_nums.drop(1))
    hwregs += new HWReg("vs" + i.toString(), true, true)
  def init_regs() = 
  {
    var s = "vsreg_init:\n"+"\tla x1, vsreg_init_data\n"
    for ((i, curreg) <- reg_nums.zip(hwregs)) 
    {
      s += "\tld" + " x2, " + 8*i + "(x1)\n"
      s += "\tvmcs"+ " " + curreg + ", x2\n"
    }
    s += "\n\n"
    s
  } 
  def save_regs() =
  {
    hwregs(1).state = HID
    var s = "vsreg_save:\n"+"\tla x1, vsreg_output_data\n"
    s += "\tvmcs vs1, x1\n"
    s += "\tlui x1, %hi(vsreg_save_vf)\n"
    s += "\tvf %lo(vsreg_save_vf)(x1)\n"
    s += "\tj vsreg_save_end\n"
    s += ".align 3\n"
    s += "vsreg_save_vf:\n"
    for (curreg <- hwregs.drop(2))
      if (curreg.is_visible) 
      {
        s += "\tvssd vs1, " + curreg + "\n"
        s += "\tvaddi vs1, vs1, 8\n"
      }
      s += "\tvstop\n"
      s += "vsreg_save_end:\n\n"
    s
  }
  def init_regs_data() = 
  {
    var s = "\t.align 8\n"
    s += "vsreg_init_data:\n"
    for (i <- 0 to hwregs.length-1)
      s += ("vs" + i + "_init:\t.dword " + "0x%016x\n" format rand_biased)
    s += "\n"
    s
  }
  
  def output_regs_data() =
  {
    var s = "\t.align 8\n"
    s += "vsreg_output_data:\n"
    for (i <- 0 to hwregs.length-1)
      s += ("vs" + i + "_output:\t.dword 0x%016x\n" format rand_dword)
    s += "\n"
    s
  }
}

class VARegsPool(reg_nums: Array[Int] = (0 to 31).toArray) extends HWRegPool
{
  for (i <- reg_nums)
    hwregs += new HWReg("va" + i.toString(), true, true)
}
