package torture

import scala.collection.mutable.ArrayBuffer
import Rand._

class SeqVPop(vregs: HWRegPool, pregs: HWRegPool, def_preg: Reg, sregs: HWRegPool) extends VFInstSeq //TODO: better configuration
{
  override val seqname = "vpop"

  def seq_src3(pop: Int) = () => {
    val src1 = reg_read_any(pregs)
    val src2 = reg_read_any(pregs)
    val src3 = reg_read_any(pregs)
    val dest = reg_write(pregs, src1, src2, src3)
    vinsts += VPOP(dest, src1, src2, src3, HexImm(pop))
  }

  val candidates = new ArrayBuffer[() => vinsts.type]

  candidates += seq_src3(rand_word & 0xFF)

  rand_pick(candidates)()
}
