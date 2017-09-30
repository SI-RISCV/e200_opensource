/* See LICENSE of license details. */

#include <errno.h>
#include "stub.h"

int __wrap_execve(const char* name, char* const argv[], char* const env[])
{
  return _stub(ENOMEM);
}
