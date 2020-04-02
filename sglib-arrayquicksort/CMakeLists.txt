#
# Copyright (c) 2019-2020, University of Southampton and Contributors.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

set(NAME sglib-arrayquicksort)
set(SOURCES benchmark.h arraysort.c)
set(TARGET_DEFS QUICK_SORT)
set(REPETITIONS 33)
add_all_exe()
