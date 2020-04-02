#
# Copyright (c) 2013-2020, University of Southampton and Contributors.
# All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

include (ExternalProject)

set_property (DIRECTORY PROPERTY EP_BASE Dependencies)

# ------ Install target toolchains ------

# MSP430-GCC -- Just download and extract
ExternalProject_Add (ep_msp430_gcc
  URL http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/8_2_0_0/exports/msp430-gcc-8.2.0.52_linux64.tar.bz2
  CONFIGURE_COMMAND ""
  BUILD_COMMAND  ""
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND rsync -ra . ${EP_INSTALL_DIR}/msp430-gcc
  )

# MSP430 Support files -- Just download and extract
ExternalProject_Add (ep_msp430_inc
  URL http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/8_2_0_0/exports/msp430-gcc-support-files-1.207.zip
  CONFIGURE_COMMAND ""
  BUILD_COMMAND  ""
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND rsync -ra . ${EP_INSTALL_DIR}/msp430-inc
  )

# ARM-GCC -- Just download and extract
ExternalProject_Add (ep_arm_gcc
  URL https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/RC2.1/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
  CONFIGURE_COMMAND ""
  BUILD_COMMAND  ""
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND rsync -ra . ${EP_INSTALL_DIR}/arm-gcc
  )
