/* * BSD 3-Clause License
 *
 * Copyright (c) 2019, University of Southampton, United Kingdom.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the copyright holder nor the names of its
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdint.h>
#include <string.h>

// Tiled implementation to improve locality
void matmult(int m, int n, int16_t a[m][n], int16_t b[m][n],
             int16_t out[m][n]) {
  int row = m, col = n;
  int incr = 5;

  for (uint16_t i = 0; i < row; i += incr) {
    for (uint16_t j = 0; j < col; j += incr) {
      // clear a tile of out
      for (int aq = 0; aq < incr; aq++) {
        memset(&out[aq + i][j], 0, incr * sizeof(int16_t));
      }

      for (uint16_t k = 0; k < row; k += incr) {
        // Calculate tile product
        for (uint16_t x = i; x < i + incr; x++) {
          for (uint16_t y = j; y < j + incr; y++) {
            for (uint16_t z = k; z < k + incr; z++) {
              out[x][y] += a[x][z] * b[z][y];
            }
          }
        }
      }
    }
  }
}

/* ------ Benchmark ------*/
#include "input.h"
int16_t output[MATSIZE][MATSIZE];

void initialise_benchmark(void) { }

__attribute__((optimize(1))) int benchmark(void) {
  matmult(MATSIZE, MATSIZE, a, b, output);
  return 0;
}

int verify_benchmark(int result) { return 0; }
