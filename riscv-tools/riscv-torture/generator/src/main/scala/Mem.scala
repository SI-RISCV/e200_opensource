package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class Mem(name: Array[Operand], val size: Int) extends Operand
{
  def this(namelabel: String, size: Int) = this(Array[Operand](Label(namelabel)), size)

  assert(size % 4 == 0, "Memory size must be multiple of 4")

  override def toString = name.mkString("")

  def dumpdata = 
  {
    var s = "\t.align 8\n"
    s += this.toString + ":\n"
    if(size % 16 == 0)
    {
      for (i <- 0 to (size/8/2 - 1))
        s += "\t.dword 0x%016x, 0x%016x\n" format (rand_dword, rand_dword)
    } else if(size % 8 == 0)
    {
      for (i <- 0 to (size/8 - 1))
        s += "\t.dword 0x%016x\n" format (rand_dword)
    }
    else
    {
      for (i <- 0 to (size/4 - 1))
        s += "\t.word 0x%08x\n" format (rand_word)
    }
    s
  }

  def dumpaddrs(addrfn: (Int) => Int, memsize: Int) =
  {
    var s = "\t.align 8\n"
    s += this.toString + ":\n"
    if(size % 16 == 0)
    {
      for (i <- 0 to (size/8/2 - 1))
        s += "\t.dword 0x%016x, 0x%016x\n" format (addrfn(memsize), addrfn(memsize))
    } else if(size % 8 == 0)
    {
      for (i <- 0 to (size/8 - 1))
        s += "\t.dword 0x%016x\n" format (addrfn(memsize))
    }
    else
    {
      for (i <- 0 to (size/4 - 1))
        s += "\t.word 0x%08x\n" format (addrfn(memsize))
    }
    s
  }
}

class VMem(name: Array[Operand], val ut_size: Int, num_ut: Int) extends Mem(name, ut_size*num_ut)
{
  def this(namelabel: String, ut_size: Int, num_ut: Int) = this(Array[Operand](Label(namelabel)), ut_size, num_ut)

  assert(size % 16 == 0, "Per uthread memory size must be multiple of 16")

  override def dumpdata = 
  {
    var s = "\t.align 8\n"
    s += this.toString + ":\n"

    for(ut <- 0 to (num_ut-1))
    {
      s+= "\t" + this.toString + "_ut_" + ut + ":\n"
      for (i <- 0 to (ut_size/8/2 - 1))
        s += "\t.dword 0x%016x, 0x%016x\n" format (rand_dword, rand_dword)
    }
    s
  }
}

