cmake_minimum_required(VERSION 3.10)

set(TARGET_ARCH "arm" CACHE STRING "Target architecture")
#set(TARGET_ARCH "msp430" CACHE STRING "Target architecture")
set($ENV{FUSED_SW_TARGET_ARCH} ${TARGET_ARCH})

message(STATUS "Compiling benchmarks for ${TARGET_ARCH}")

set(PROJECT_ROOT ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/common.cmake)

project(benchmarks)
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
add_subdirectory(sglib-rbtree)

#add_subdirectory(nettle-sha256) # Too large mem footprint

add_subdirectory(aes)
add_subdirectory(matmul)
add_subdirectory(matmul-tiled)
add_subdirectory(fp)

add_subdirectory(dijkstra)
