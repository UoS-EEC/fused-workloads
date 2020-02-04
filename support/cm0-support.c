#include <stdint.h>
#include <string.h>
#include "cm0-support.h"

void indicate_begin() {
   MONITOR = MONITOR_INDICATE_BEGIN;
  ;}

void indicate_end() {
  //MONITOR = MONITOR_INDICATE_END;
  MONITOR = MONITOR_KILL_SIM;
  }

void wait() {
  for (volatile uint32_t i = 0; i < 10000ll; i++)
    ; // delay
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
