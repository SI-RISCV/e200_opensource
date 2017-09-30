/* See LICENSE of license details. */

#include <errno.h>
#include <sys/times.h>
#include "stub.h"

clock_t __wrap_times(struct tms* buf)
{
  return _stub(EACCES);
}
