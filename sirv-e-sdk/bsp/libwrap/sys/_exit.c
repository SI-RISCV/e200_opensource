/* See LICENSE of license details. */

#include <unistd.h>
#include "platform.h"

void _exit(int code)
{
  const char message[] = "\nProgam has exited with code:";

  write(STDERR_FILENO, message, sizeof(message) - 1);
  write_hex(STDERR_FILENO, code);
  write(STDERR_FILENO, "\n", 1);

  for (;;);
}
