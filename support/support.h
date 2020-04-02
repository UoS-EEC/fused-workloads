/*
 * Copyright (c) 2019-2020, University of Southampton and Contributors.
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#pragma once

#ifdef CM0_ARCH
#include "cm0-support.h"
#elif defined(MSP430_ARCH)
#include <msp430fr5994.h>
#include "msp430-support.h"
#else
#error Target architecture must be defined
#endif

#include <stdbool.h>
#include <stdint.h>

// Initialize target
void target_init();

// Wait between workload iterations
void wait();

// Indicate start of workload
void indicate_workload_begin();

// Indicate end of workload
void indicate_workload_end();

// Indicate test fail
void indicate_test_fail();

// End experiment
void end_experiment();

// ------ Functions that must be implemented by benchmarks ------

/**
 * @brief Verify benchmark result
 * @param result return value of benchmark
 * @return 0 if success, -1 if no verification done, 1 otherwise
 */
extern int verify_benchmark(int result);

/**
 * @brief Initialise benchmark.
 */
extern void initialise_benchmark(void);

/**
 * @brief Run benchmark.
 * @return benchmark-specific return value. For example result of computation.
 */
extern int benchmark(void) __attribute__((noinline));
