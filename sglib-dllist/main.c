#include <common.h>
#include <msp430fr5994.h>
#include <stdint.h>
#include "benchmark.h"

#define REPETITIONS 20

int main() {
    cs_init();
    gpio_init();

    while (1) {
        P1OUT |= BIT2;
        for (volatile long int i=0; i<REPETITIONS; i++) {
            initialise_benchmark();
            benchmark();
        }
        P1OUT &= ~BIT2;
        WAIT
    }
}
