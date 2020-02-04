
          set pagination off
          set verbose off
          layout asm
          layout regs
          b 0x4c16
          target remote :51000
          load
          c
          