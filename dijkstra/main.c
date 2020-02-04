#include <common.h>
#include <msp430fr5994.h>
#include <stdint.h>
#include "dijkstra_small.h"

__attribute__((optimize(1)))
int main() {
    cs_init();
    gpio_init();
    initialise_benchmark();

    while (1) {
        P1OUT |= BIT2;
        benchmark();
        P1OUT &= ~BIT2;
        WAIT
    }
}
