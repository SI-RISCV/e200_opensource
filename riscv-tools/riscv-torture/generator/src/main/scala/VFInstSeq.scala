package torture

import scala.collection.mutable.ArrayBuffer
import Rand.rand_range

class VFInstSeq extends InstSeq
{
  val vinsts = new ArrayBuffer[Inst]
  var vinst_ptr = 0

  override def is_done = insts.length == inst_ptr && vinsts.length == vinst_ptr

  def inst_left = insts.length > inst_ptr
  def vinst_left = vinsts.length > vinst_ptr

  def next_vinst() =
  {
    val vinst = vinsts(vinst_ptr)
    vinst_ptr += 1
    vinst
  }
}

object VFInstSeq
{
  def apply(prob_tbl: ArrayBuffer[(Int, () => VFInstSeq)]): VFInstSeq =
  {
    var p = rand_range(0, 99)
    for ((prob, gen_seq) <- prob_tbl)
    {
      if (p < prob) return gen_seq()
      p -= prob
    }

    assert(false, println("Probabilties should have added up to 100%"))
    new VFInstSeq()
  }
}
