/*
 * Copyright (c) 2018-2020, University of Southampton.
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "support.h"

#ifndef CACHE_WARMING_ITERATIONS
#define CACHE_WARMING_ITERATIONS 0
#endif

#ifndef REPETITIONS
#define REPETITIONS 1
#endif

#define RUNS 1

__attribute__((used, noreturn)) int main() {
  target_init();

  while (1) {
    for (volatile long int j = 0; j < RUNS; j++) {
      indicate_workload_begin();
      for (volatile long int i = 0; i < REPETITIONS + CACHE_WARMING_ITERATIONS;
           i++) {
        initialise_benchmark();
        benchmark();
        if (i >= CACHE_WARMING_ITERATIONS) {
          indicate_workload_begin();
        }
      }
      indicate_workload_end();
      wait();
    }
    end_experiment();
  }
}
