cmake_minimum_required(VERSION 3.13)

add_library(support "")

IF(${TARGET_ARCH} STREQUAL arm)
target_sources(support
  PRIVATE cm0-support.c cm0-support.h cm0-vectors.c
  PUBLIC support.h
  )
ELSEIF(${TARGET_ARCH} STREQUAL msp430)
target_sources(support
  PRIVATE msp430-support.c msp430-support.h
  PUBLIC support.h
  )
ENDIF()

