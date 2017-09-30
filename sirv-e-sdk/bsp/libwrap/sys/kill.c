/* See LICENSE of license details. */

#include <errno.h>
#include "stub.h"

int __wrap_kill(int pid, int sig)
{
  return _stub(EINVAL);
}
