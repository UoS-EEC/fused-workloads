#
# Copyright (c) 2019-2020, University of Southampton and Contributors.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

set(NAME sglib-arrayheapsort)
set(SOURCES benchmark.h arraysort.c)
set(TARGET_DEFS HEAP_SORT)
set(REPETITIONS 21)
add_all_exe()
