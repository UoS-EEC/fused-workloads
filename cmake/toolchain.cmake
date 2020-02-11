INCLUDE(CMakeForceCompiler)

# Find toolchain programs
set(CMAKEDIR ${CMAKE_CURRENT_LIST_DIR})
set(SUPPORTDIR ${CMAKE_CURRENT_LIST_DIR}/../support)

set(BINPATHS $ENV{ARM_GCC_ROOT}/bin $ENV{MSP430_GCC_ROOT}/bin)

# Hack to get variables into toolchain (https://stackoverflow.com/questions/28613394/)
IF(NOT (TARGET_ARCH STREQUAL ""))
  set($ENV{__TARGET_ARCH} "${TARGET_ARCH}")
ELSE()
  set(TARGET_ARCH "$ENV{__TARGET_ARCH}")
ENDIF()
set(TARGET_ARCH "arm")

message(STATUS "finding ${TARGET_ARCH} compiler")
IF(${TARGET_ARCH} STREQUAL "arm")
  set(BIN_PREFIX arm-none-eabi)
ELSEIF(${TARGET_ARCH} STREQUAL "msp430")
  set(BIN_PREFIX msp430-elf)
ELSE()
  message(FATAL_ERROR "Invalid TARGET_ARCH")
ENDIF()

find_program(TC-GCC ${BIN_PREFIX}-gcc PATHS ${BINPATHS})
find_program(TC-GXX ${BIN_PREFIX}-g++ PATHS ${BINPATHS})
find_program(TC-OBJCOPY ${BIN_PREFIX}-objcopy PATHS ${BINPATHS})
find_program(TC-SIZE ${BIN_PREFIX}-size PATHS ${BINPATHS})
find_program(TC-OBJDUMP ${BIN_PREFIX}-objdump PATHS ${BINPATHS})
find_program(MSPDEBUG mspdebug)

# Define toolchain
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_ASM_COMPILER ${TC-GCC} CACHE INTERNAL "")
set(CMAKE_C_COMPILER ${TC-GCC} CACHE INTERNAL "")
set(CMAKE_CXX_COMPIER ${TC-GXX} CACHE INTERNAL "")

# Prevent CMake from testing the compilers
set(CMAKE_C_COMPILER_WORKS 1 CACHE INTERNAL "")
set(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")

#Debug by default
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

function(add_upload EXECUTABLE)
IF(${TARGET_ARCH} STREQUAL "msp430")
  add_custom_target(upload_${EXECUTABLE}
    COMMAND ${MSPDEBUG} tilib "erase"
    COMMAND ${MSPDEBUG} tilib "prog ${EXECUTABLE}.elf"
    DEPENDS ${EXECUTABLE})
ELSEIF(${TARGET_ARCH} STREQUAL "arm")
  add_custom_target(upload_${EXECUTABLE}
    COMMAND echo "uploading ${EXECUTABLE}..."
    COMMAND echo "upload for ${TARGET_ARCH}not implemented!"
    DEPENDS ${EXECUTABLE})
ELSE()
  message(FATAL_ERROR "Invalid TARGET_ARCH: ${TARGET_ARCH}")
ENDIF()
endfunction(add_upload)

macro(add_all_exe)
  FOREACH (DATASEC F S)
    FOREACH (CODESEC F S)
      FOREACH (WS 0 15)
        set(TESTNAME "${NAME}-${CODESEC}${DATASEC}-WS${WS}")
        add_executable(${TESTNAME} "")
        target_sources(${TESTNAME}
          PRIVATE ${SOURCES} ${SUPPORTDIR}/main.c
        )
        include(${CMAKEDIR}/tail.cmake)
        FOREACH(DEF ${TARGET_DEFS})
          target_compile_definitions(${TESTNAME} PRIVATE -D${DEF})
        ENDFOREACH()
      ENDFOREACH()
    ENDFOREACH()
  ENDFOREACH()
endmacro()

macro(add_single_exe)
  set(TESTNAME "${NAME}-FS")
  set(CODESEC F)
  set(DATASEC S)
  add_executable(${TESTNAME} "")
  target_sources(
    PRIVATE ${SOURCES} ${SUPPORTDIR}/main.c
    )
  include(${CMAKEDIR}/tail.cmake)
  FOREACH(DEF ${TARGET_DEFS})
    target_compile_definitions(${TESTNAME} PRIVATE -D${DEF})
endmacro()
