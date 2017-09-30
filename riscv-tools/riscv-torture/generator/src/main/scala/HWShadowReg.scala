package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

import HWRegState._

class HWShadowReg(target:Reg, name: String, readable: Boolean, writeable: Boolean) extends HWReg(name, readable, writeable)
{
  def physical = target
  override def toString = target.toString
}

class ShadowRegPool extends HWRegPool
{
  def pairings(selecting: (HWReg => Boolean)) = hwregs.filter(selecting).map((reg:HWReg) => (reg, reg.asInstanceOf[HWShadowReg].physical))
}
