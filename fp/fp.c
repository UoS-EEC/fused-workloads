/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2019-2020, University of Southampton and Contributors.
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdint.h>

volatile float a;
volatile float b;
volatile float c;
volatile float d;

float test(uint16_t cnt) {
  while (cnt--) {
    a = 0.2;
    b = 0.3;
    c = 14.2;
    d = 13.28E4;
    a += a * b + c / d;
  }
  return a;
}

/* ------ Benchmark ------*/
void initialise_benchmark(void) {}

__attribute__((optimize(1))) int benchmark(void) {
  volatile float result __attribute__((unused)) = test(100);
  return 0;
}

int verify_benchmark(int result) { return 0; }
