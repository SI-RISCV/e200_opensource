package torture

import scala.collection.mutable.ArrayBuffer

abstract class Operand

class Reg extends Operand
{
  var allocated = false
  var hwreg = new HWReg("-", false, false)

  override def toString = hwreg.toString
}

class RegNeedsAlloc(
  val hwrp: HWRegPool,
  val filter: (HWReg) => Boolean,
  val alloc: (HWReg) => Unit,
  val free: (HWReg) => Unit,
  val consec_regs: Int = 1) extends Reg
{
  val regs = new ArrayBuffer[Reg]
}

class Imm(imm: Int) extends Operand
{
  override def toString = imm.toString
}

class HexImm(imm: Int) extends Operand
{
  override def toString = "0x"+Integer.toHexString(imm)
}

class BaseImm(base: String, imm: Int) extends Operand
{
  override def toString =
  {
    if (imm == 0) base
    else if (imm < 0) base + imm.toString
    else base + "+" + imm.toString
  }
}

class RegImm(base: Reg, imm: Int) extends Operand
{
  override def toString = imm.toString + "(" + base + ")"
}

class RegStrImm(base: Reg, imm: String) extends Operand
{
  override def toString = imm + "(" + base + ")"
}

class Label(val label: String) extends Operand
{
  override def toString = label
}

class PredReg(pred: Reg, neg: Boolean) extends Operand
{
  override def toString =
    if (neg) "@!" + pred
    else "@" + pred
}

object Imm
{
  def apply(imm: Int) = new Imm(imm)
}

object HexImm
{
  def apply(imm: Int) = new HexImm(imm)
}

object BaseImm
{
  def apply(base: String, imm: Int) = new BaseImm(base, imm)
}

object RegImm
{
  def apply(base: Reg, imm: Int) = new RegImm(base, imm)
}

object RegStrImm
{
  def apply(base: Reg, imm: String) = new RegStrImm(base, imm)
}

object Label
{
  def apply(label: String) = new Label(label)
}

object PredReg
{
  def apply(pred: Reg, neg: Boolean) = new PredReg(pred, neg)
}
