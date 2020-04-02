#
# Copyright (c) 2019-2020, University of Southampton and Contributors.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

cmake_minimum_required(VERSION 3.13)

add_library(support-${TARGET_ARCH} "")
target_sources(support-${TARGET_ARCH}
  PRIVATE main.c
  PUBLIC support.h
  )

IF(${TARGET_ARCH} STREQUAL cm0)
  target_sources(support-${TARGET_ARCH}
    PRIVATE cm0-support.c cm0-support.h cm0-vectors.c
    PUBLIC cm0.h)
ELSEIF(${TARGET_ARCH} STREQUAL msp430)
  target_sources(support-${TARGET_ARCH}
    PRIVATE msp430-support.c msp430-support.h)
ELSE()
  message(FATAL_ERROR "Must define TARGET_ARCH to be one of {cm0, msp430}")
ENDIF()

