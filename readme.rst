===============
Fused workloads
===============

Repository containing workloads used in the evaluation of `Fused`_, several of
which are ported from the `BEEBS`_ project.

Install dependencies (tested on Ubuntu 18.04)
---------------------------------------------

First, install a few tools:

.. code-block:: bash

    $> sudo apt install libboost-dev build-essential g++ ninja-build gdb

Then install a recent version of *CMake* (>= version 3.12):

.. code-block:: bash

    $> wget https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4-Linux-x86_64.sh
    $> chmod a+x cmake*.sh
    $> sudo ./cmake*.sh --skip-license --prefix=/usr/local

Now download, build & install the MSP430 and Arm GCC toolchains, using *CMake*
(this may take a while):

.. code-block:: bash

    # in fused-workloads/
    $> mkdir build && cd build
    $> cmake .. -GNinja -D INSTALL_DEPENDENCIES=ON
    $> ninja


By default, this installs to ``~/.local``, but you can providea different
install path with the ``EP_INSTALL_DIR`` variable, e.g.
``-DEP_INSTALL_DIR=${HOME}/fused-workloads-deps``.

Before building, we need to set a few environment variables, add these lines to
your ``~/.bashrc`` (or your shell's equivalent):

.. code-block:: bash

    export FUSED_ROOT=<path/to/fused/root> # Optional
    export ARM_GCC_ROOT=${HOME}/.local/arm-gcc
    export MSP430_GCC_ROOT=${HOME}/.local/msp430-gcc
    export MSP430_INC=${HOME}/.local/msp430-inc
    export PATH="${HOME}/.local/msp430-gcc/bin:${PATH}"
    export PATH="${HOME}/.local/arm-gcc/bin:${PATH}"

Now, disable ``INSTALL_DEPENDENCIES``:

.. code-block:: bash

    # in fused-workloads/build
    $> cmake .. -D INSTALL_DEPENDENCIES=OFF

Build
-----

Simply select a target platform via the ``TARGET_ARCH`` variable (``cm0`` for
*Arm Cortex-M0* or ``msp430`` for *MSP430FR5994*) and build:

.. code-block:: bash

    # in fused-workloads/build
    $> cmake .. -GNinja -DINSTALL_DEPENDENCIES=OFF -DTARGET_ARCH=msp430
    $> ninja

Once the this has completed, there will be a folder for each benchmark,
containing executables with names in the format of

..

  <workload>-<Code section><Data section>-<target architecture (msp430-cm0)>

(you can list the ELF's with ``ls **/*.elf``)

**Note:** If you want to change the target, e.g. from ``msp430`` to ``cm0``,
completely clean the build folder first.

License
-------
This repository combines workloads licensed under several different licenses,
see the header of each source file.


.. _Fused: https://github.com/UoS-EEC/fused
.. _BEEBS: https://github.com/mageec/beebs
