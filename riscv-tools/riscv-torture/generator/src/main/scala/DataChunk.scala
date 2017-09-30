package torture

abstract class DataChunk

class StringData(contents: String) extends DataChunk
{
  override def toString = contents
}

class MemDump(mem: Mem) extends DataChunk
{
  override def toString = mem.dumpdata
}

object MemDump
{
  def apply(mem: Mem) = new MemDump(mem)
}

class MemAddrDump(mem: Mem, addrfn: (Int) => Int, memsize: Int) extends DataChunk
{
  override def toString = mem.dumpaddrs(addrfn, memsize)
}

object MemAddrDump
{
  def apply(mem: Mem, addrfn: (Int) => Int, memsize: Int) = new MemAddrDump(mem, addrfn, memsize)
}

class ProgSegDump(pseg: ProgSeg) extends DataChunk
{
  override def toString = pseg.toString
}

object ProgSegDump
{
  def apply(pseg: ProgSeg) = new ProgSegDump(pseg)
}

