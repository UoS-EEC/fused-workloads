#
# Copyright (c) 2013-2020, University of Southampton and Contributors.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

cmake_minimum_required(VERSION 3.10)

# ------ Options -------
option(SIMULATION "Enable fused simulation control (via SIMPLE_MONITOR)" ON)
option(INSTALL_DEPENDENCIES "Download, build & install dependencies only" OFF)

IF(${SIMULATION})
  IF(NOT EXISTS $ENV{FUSED_ROOT}/include/fused.h)
    message(FATAL_ERROR "SIMULATION set, but can't find "
      "\$ENV{FUSED_ROOT}/include/fused.h, is the environment variable "
      "FUSED_ROOT set correctly? If building without Fused, set SIMULATION=OFF "
      " (-D SIMULATION=OFF)"
      )
  ENDIF()
ENDIF()

# ------ Optionally install target toolchains ------

set(EP_INSTALL_DIR $ENV{HOME}/.local CACHE STRING
                "Installation directory for dependencies")

IF(${INSTALL_DEPENDENCIES})
  # Install dependencies and exit
  project(INSTALL_DEPENDENCIES NONE)
  include(cmake/InstallDependencies.cmake)
  return()
ENDIF()

# ------ Set CMAKE toolchain ------
IF(NOT DEFINED TARGET_ARCH)
  message(FATAL_ERROR
    "TARGET_ARCH undefined, must be one of {cm0, msp430}")
ENDIF()
IF(${TARGET_ARCH} STREQUAL "cm0")
  set(CMAKE_TOOLCHAIN_FILE cmake/cm0-toolchain.cmake)
ELSEIF(${TARGET_ARCH} STREQUAL "msp430")
  set(CMAKE_TOOLCHAIN_FILE cmake/msp430-toolchain.cmake)
ELSE ()
  message(FATAL_ERROR
    "Invalid TARGET_ARCH ${TARGET_ARCH}, must be one of {cm0, msp430}")
ENDIF()

# ------ Project ------
project(workloads)

include(cmake/common.cmake)

set(PROJECT_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(.)
include_directories(support)

add_subdirectory(support)

add_subdirectory(newlib-exp)
add_subdirectory(newlib-log)
add_subdirectory(newlib-mod)
add_subdirectory(newlib-sqrt)

add_subdirectory(sglib-arraybinsearch)
add_subdirectory(sglib-arrayheapsort)
add_subdirectory(sglib-arrayquicksort)
add_subdirectory(sglib-dllist)
add_subdirectory(sglib-hashtable)
add_subdirectory(sglib-listinsertsort)
add_subdirectory(sglib-listsort)
add_subdirectory(sglib-queue)
#add_subdirectory(sglib-rbtree) # Too large mem footprint

#add_subdirectory(nettle-sha256) # Too large mem footprint

add_subdirectory(aes)
add_subdirectory(matmul)
add_subdirectory(matmul-tiled)
add_subdirectory(fp)

add_subdirectory(dijkstra)
