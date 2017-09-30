package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

object HWRegState extends Enumeration
{
  type HWRegState = Value
  val VIS, HID, HID2HID, HID2VIS, VIS2HID, VIS2VIS = Value
}

import HWRegState._
class HWReg(val name: String, val readable: Boolean, val writable: Boolean)
{
  var state = VIS
  var readers = 0
  var backup_state = VIS
  var backup_readers = 0

  def is_state(states: HWRegState*) = states.toList.contains(state)

  def is_visible() = is_state(VIS, VIS2VIS)

  def is_unallocated = is_state(VIS, HID)
    //TODO: should this also check readers == 0?

  override def toString = name

  def backup() =
  {
    backup_state = state
    backup_readers = readers
  }

  def restore() =
  {
    state = backup_state
    readers = backup_readers
  }
}

object HWReg
{
  // These filters are for allocation purposes
  def filter_read_zero = (hwreg: HWReg) => (hwreg.name == "x0" || hwreg.name == "x0_shadow")
  def filter_read_any = (hwreg: HWReg) => hwreg.readable
  def filter_read_any_other(other: Reg)(hwreg: HWReg) = (hwreg.readable && hwreg.name != other.hwreg.name)
  def filter_read_visible = (hwreg: HWReg) => hwreg.readable && hwreg.is_state(VIS,VIS2VIS)
  def filter_write_ra = (hwreg: HWReg) => hwreg.name == "x1" && filter_write_visible(hwreg)
  def filter_write_visible = (hwreg: HWReg) => hwreg.writable && hwreg.is_state(VIS,HID)
  def filter_write_hidden = (hwreg: HWReg) => hwreg.writable && (hwreg.is_state(HID) || hwreg.is_state(VIS) && hwreg.readers == 0)
  def filter_write_visible_other(other: Reg)(hwreg: HWReg) = (hwreg.name != other.hwreg.name && hwreg.writable && hwreg.is_state(VIS,HID))
  def filter_write_hidden_other(other: Reg)(hwreg: HWReg) = (hwreg.name != other.hwreg.name && hwreg.writable && (hwreg.is_state(HID) || hwreg.is_state(VIS) && hwreg.readers == 0))
  def filter_write_dep(regs: List[Reg]) =
  {
    if (regs.forall(_.hwreg.is_visible)) filter_write_visible
    else filter_write_hidden
  }
  def filter_write_dep_other(other: Reg, regs: List[Reg]) =
  {
    if (regs.forall(_.hwreg.is_visible)) filter_write_visible_other(other) _
    else filter_write_hidden_other(other) _
  }

  def alloc_read = (hwreg: HWReg) => hwreg.readers += 1
  def alloc_write(visible: Boolean)(hwreg: HWReg) =
  {
    if (hwreg.state == VIS)
    {
      if (visible) hwreg.state = VIS2VIS
      else hwreg.state = VIS2HID
    }
    else if (hwreg.state == HID)
    {
      if (visible) hwreg.state = HID2VIS
      else hwreg.state = HID2HID
    }
    else println("bug in do_write")
  }
  def alloc_write_dep(regs: List[Reg]) = alloc_write(regs.forall(_.hwreg.is_visible)) _

  def free_read = (hwreg: HWReg) => hwreg.readers -= 1
  def free_write = (hwreg: HWReg) =>
  {
    if (hwreg.state == VIS2VIS || hwreg.state == HID2VIS) hwreg.state = VIS
    else if (hwreg.state == VIS2HID || hwreg.state == HID2HID) hwreg.state = HID
    else println("bug in free_write")
  }


  //tianchuan:We construct c instruction architecture
  //*************************************************
  def filter_write_visible_c = (hwreg: HWReg) => hwreg.writable && hwreg.is_state(VIS,HID) && hwreg.name != "x0" && hwreg.name != "x2"
  def filter_write_hidden_x2 = (hwreg: HWReg) => hwreg.writable && (hwreg.is_state(HID) || hwreg.is_state(VIS) && hwreg.readers == 0)&& hwreg.name == "x2" 
  def filter_write_visible_nox0 = (hwreg: HWReg) => hwreg.writable && hwreg.is_state(VIS,HID) && hwreg.name != "x0"
  def filter_read_visible_nox0 = (hwreg: HWReg) => hwreg.readable && hwreg.is_state(VIS,VIS2VIS) && hwreg.name != "x0"
  def filter_write_hidden_x8_x15 = (hwreg: HWReg) => hwreg.writable && (hwreg.is_state(HID) || hwreg.is_state(VIS) && hwreg.readers == 0)&& (hwreg.name == "x8" || hwreg.name == "x9" || hwreg.name == "x10" || hwreg.name == "x11" || hwreg.name == "x12" || hwreg.name == "x13" || hwreg.name == "x14" || hwreg.name == "x15")
  def filter_write_visible_x8_x15 = (hwreg: HWReg) => hwreg.writable && hwreg.is_state(VIS,HID) && (hwreg.name == "x8" || hwreg.name == "x9" || hwreg.name == "x10" || hwreg.name == "x11" || hwreg.name == "x12" || hwreg.name == "x13" || hwreg.name == "x14" || hwreg.name == "x15")
  def filter_read_visible_x8_x15 = (hwreg: HWReg) => hwreg.readable && hwreg.is_state(VIS,VIS2VIS) && (hwreg.name == "x8" || hwreg.name == "x9" || hwreg.name == "x10" || hwreg.name == "x11" || hwreg.name == "x12" || hwreg.name == "x13" || hwreg.name == "x14" || hwreg.name == "x15")
  def filter_read_any_butnox0= (hwreg: HWReg) => hwreg.name != "x0"
  def filter_read_x8_x15= (hwreg: HWReg) => (hwreg.name == "x8" || hwreg.name == "x9" || hwreg.name == "x10" || hwreg.name == "x11" || hwreg.name == "x12" || hwreg.name == "x13" || hwreg.name == "x14" || hwreg.name == "x15")
  def filter_write_x8_x15 = (hwreg: HWReg) => (hwreg.name == "x8" || hwreg.name == "x9" || hwreg.name == "x10" || hwreg.name == "x11" || hwreg.name == "x12" || hwreg.name == "x13" || hwreg.name == "x14" || hwreg.name == "x15") && filter_write_visible(hwreg)
  def filter_write_visible_x2 = (hwreg: HWReg) => hwreg.writable && hwreg.is_state(VIS,HID) && hwreg.name == "x2" 
  def filter_write_dep_x8x15(regs: List[Reg]) =
  {
    if (regs.forall(_.hwreg.is_visible)) filter_write_visible_x8_x15
    else filter_write_hidden_x8_x15
  }





















}


