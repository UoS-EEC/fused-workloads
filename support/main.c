#include "support.h"
#include "fused.h"

__attribute__((used)) int main() {
  target_init();

  while (1) {
    indicate_begin();
    for (volatile long int i = 0; i < REPETITIONS; i++) {
      initialise_benchmark();
      benchmark();
      if (i==0) {
        SIMPLE_MONITOR = SIMPLE_MONITOR_START_EVENT_LOG;
      }
    }
    indicate_end();
    wait();
  }
}
