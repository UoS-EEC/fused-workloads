#!/usr/bin/env python3

# BSD 3-Clause License
#
# Copyright (c) 2019, University of Southampton, United Kingdom.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import os, glob, re, code


def parseTraceFile(fn):
  with open(fn, 'r') as infile:
    content = infile.read()
  blocks = re.compile(r'\n0x[0-9a-f]+ in \w+ \(\)\n').split(content)[1:]
  blocks = [b for b in blocks if "Loading" not in b]
  regs = ['pc', 'sp', 'sr', 'cg', 'r4', 'r5', 'r6', 'r7', 'r8', 'r9', 'r10',
      'r11', 'r12', 'r13', 'r14', 'r15']
  state = [{} for i in range(len(blocks))]
  for i,b in enumerate(blocks):
    for r in regs:
      regex = r'{}\s+(0x[0-9a-f]+)\s'.format(r)
      state[i][r] = int(re.search(regex, b).group(1), 16)
  return state

def compareValues(d1, d2):
  for k in d1.keys():
    if (d1[k] != d2[k]):
      print('{}: 0x{:04x}, 0x{:04x}'.format(k, d1[k], d2[k]))
      return False
  return True

def filterConsecutive(arr):
  return [arr[i] for i in range(len(arr)-1) if arr[i]['pc'] != arr[i+1]['pc']]

def emitReproduceScript(bp, path, elf):
  for mode in ['sim', 'meas']:
    port = 51000 if mode == "sim" else 55000
    with open(os.path.join(path, mode+'.gdb'), 'w+') as of:
      of.write(
          '''
          set pagination off
          set verbose off
          layout asm
          layout regs
          file {}
          b 0x{:04x}
          target remote :{:d}
          load
          set $r4 = 0
          set $r5 = 0
          set $r6 = 0
          set $r7 = 0
          set $r8 = 0
          set $r9 = 0
          set $r10 = 0
          set $r11 = 0
          set $r12 = 0
          set $r13 = 0
          set $r14 = 0
          set $r15 = 0
          c
          '''.format(elf, bp, port)
          )

def main():
  simTrace = parseTraceFile('sim-trace.log')
  measTrace = parseTraceFile('meas-trace.log')

  simTrace = filterConsecutive(simTrace)
  measTrace = filterConsecutive(measTrace)

  #Find mismatches
  n_err = 0
  for i in range(len(simTrace)-1):
    s = simTrace[i]; m = measTrace[i];
    if (s != m):
      n_err +=1
      print("PC: 0x{:04x}".format(simTrace[i]['pc']))
      compareValues(s,m)
      print(s)
      print(m)
      print(i)
      if n_err < 2:
        emitReproduceScript(simTrace[i-1]['pc'], '.', 'matmul-tiled-FS-WS0.elf')
      if n_err >= 3:
        exit(1)

if __name__ == "__main__":
  main()



