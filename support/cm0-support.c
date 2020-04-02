/*
 * Copyright (c) 2019-2020, University of Southampton and Contributors.
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdint.h>
#include <string.h>
#include "cm0-support.h"

#ifdef SIMULATION
#include <fused.h>
#endif

void indicate_workload_begin() {
#ifdef SIMULATION
  SIMPLE_MONITOR = SIMPLE_MONITOR_INDICATE_BEGIN;
#endif
  ;
}

void indicate_workload_end() {
#ifdef SIMULATION
  SIMPLE_MONITOR = SIMPLE_MONITOR_INDICATE_END;
#endif
}

void end_experiment() {
#ifdef SIMULATION
  SIMPLE_MONITOR = SIMPLE_MONITOR_KILL_SIM;
#endif
  while (1)
    ;
}

void wait() {
  for (volatile uint32_t i = 0; i < 10000ll; i++)
    ;  // delay
}

void target_init() { return; }

// Boot function
__attribute__((optimize(1), naked, used, section(".ftext"))) void _start() {
  // Boot data (if necessary)
  extern uint8_t __data_low, __data_high, __data_loadLow;
  if ((&__data_loadLow != &__data_low) && (&__data_low < &__data_high)) {
    memcpy(&__data_low, &__data_loadLow, &__data_high - &__data_low + 1);
  }

  int main();
  main();
}
