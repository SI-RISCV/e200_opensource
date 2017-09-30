/* See LICENSE of license details. */

#include <errno.h>
#include "stub.h"

int __wrap_unlink(const char* name)
{
  return _stub(ENOENT);
}
