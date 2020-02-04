cmake_minimum_required(VERSION 3.13)

# Commmon function to add linker script and definitions for each target

string(COMPARE EQUAL ${CODESEC} S TEXT_IN_SRAM)
string(COMPARE EQUAL ${DATASEC} S DATA_IN_SRAM)

target_compile_definitions(
  ${TESTNAME}
  PRIVATE -DFRAM_WAIT=${WS}
  PRIVATE -DTEXT_IN_SRAM=${TEXT_IN_SRAM}
  PRIVATE -DDATA_IN_SRAM=${DATA_IN_SRAM}
  PRIVATE -DREPETITIONS=${REPETITIONS}
  )

target_link_libraries(${TESTNAME} PUBLIC support ${SUPPORT_LIBS})

IF (${TARGET_ARCH} STREQUAL "arm")
  target_compile_definitions(${TESTNAME} PUBLIC -DCM0_ARCH)
ELSEIF (${TARGET_ARCH} STREQUAL "msp430")
  target_compile_definitions(${TESTNAME} PUBLIC -DMSP430_ARCH)
ENDIF()

# Add correct linker script depending on section allocations
IF(${TARGET_ARCH} STREQUAL "msp430")
  target_link_options(${TESTNAME}
    PUBLIC -T${PROJECT_ROOT}/support/msp430fr5994-${CODESEC}${DATASEC}.ld)
ELSEIF (${TARGET_ARCH} STREQUAL "arm")
  target_link_options(${TESTNAME} PUBLIC -T${PROJECT_ROOT}/support/cm0-FS.ld)
ELSE()
  message(ERROR "Invalid TARGET_ARCH: ${TARGET_ARCH}")
ENDIF()

# Link support libs
#target_link_libraries( ${TESTNAME} ${SUPPORT_LIBS})

set_target_properties(${TESTNAME} PROPERTIES SUFFIX ".elf")

# Emit map
add_custom_command(TARGET ${TESTNAME} POST_BUILD
  COMMAND ${TC-SIZE} -A -x "$<TARGET_FILE:${TESTNAME}>" > ${TESTNAME}.map
  COMMAND ${TC-OBJDUMP} -d "$<TARGET_FILE:${TESTNAME}>" > ${TESTNAME}.lst
  COMMAND ${TC-OBJCOPY} -O ihex "$<TARGET_FILE:${TESTNAME}>" ${TESTNAME}.hex
  )

# Add upload target
add_upload(${TESTNAME})
