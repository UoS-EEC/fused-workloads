#include "support.h"

__attribute__((used)) int main() {
  target_init();

  while (1) {
    indicate_begin();
    for (volatile long int i = 0; i < REPETITIONS; i++) {
      initialise_benchmark();
      benchmark();
    }
    indicate_end();
    wait();
  }
}
