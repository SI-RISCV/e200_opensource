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

