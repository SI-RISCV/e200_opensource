/* See LICENSE of license details. */

#include <errno.h>
#include "stub.h"

int __wrap_close(int fd)
{
  return _stub(EBADF);
}
