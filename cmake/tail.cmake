#
# Copyright (c) 2019-2020, University of Southampton and Contributors.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

cmake_minimum_required(VERSION 3.13)

# Commmon function to add linker script and definitions for each target

string(COMPARE EQUAL ${CODESEC} S TEXT_IN_SRAM)
string(COMPARE EQUAL ${DATASEC} S DATA_IN_SRAM)

target_compile_definitions(
  ${TESTNAME}
  PUBLIC -DFRAM_WAIT=${WS}
  PUBLIC -DTEXT_IN_SRAM=${TEXT_IN_SRAM}
  PUBLIC -DDATA_IN_SRAM=${DATA_IN_SRAM}
  PUBLIC -DREPETITIONS=${REPETITIONS}
  )

target_link_libraries(${TESTNAME} PUBLIC support-${TARGET_ARCH} ${SUPPORT_LIBS})

# Add correct linker script depending on section allocations
IF(${TARGET_ARCH} STREQUAL "msp430")
  target_link_options(${TESTNAME}
    PUBLIC -T${CMAKE_CURRENT_LIST_DIR}/../support/msp430fr5994-${CODESEC}${DATASEC}.ld)
ELSEIF (${TARGET_ARCH} STREQUAL "cm0")
  target_link_options(${TESTNAME}
    PUBLIC -T${CMAKE_CURRENT_LIST_DIR}/../support/cm0.ld)
ENDIF()

set_target_properties(${TESTNAME} PROPERTIES SUFFIX ".elf")

# Emit map
add_custom_command(TARGET ${TESTNAME} POST_BUILD
  COMMAND ${TC-SIZE} -A -x "$<TARGET_FILE:${TESTNAME}>" > ${TESTNAME}.map
  COMMAND ${TC-OBJDUMP} -d "$<TARGET_FILE:${TESTNAME}>" > ${TESTNAME}.lst
  COMMAND ${TC-OBJCOPY} -O ihex "$<TARGET_FILE:${TESTNAME}>" ${TESTNAME}.hex
  )

# Add upload target
add_upload(${TESTNAME})
