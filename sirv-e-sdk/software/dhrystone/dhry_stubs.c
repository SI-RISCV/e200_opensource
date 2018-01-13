#include "platform.h"

/* The functions in this file are only meant to support Dhrystone on an
 * embedded RV32 system and are obviously incorrect in general. */

long csr_cycle(void)
{
  return get_cycle_value();
}

long csr_instret(void)
{
  return get_instret_value();
}

long time(void)
{
  return get_timer_value() / get_timer_freq();
}

// set the number of dhrystone iterations
void __wrap_scanf(const char* fmt, int* n)
{
//  *n = 100000000;
// Bob: it takes to long time to run that much time, so change it to shorter times
  *n = 160000;
  //*n = 100;
}
