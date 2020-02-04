cmake_minimum_required(VERSION 3.13)
set(NAME aes)
set(SOURCES TI_aes_128_encr_only.c TI_aes_128_encr_only.h lipsum.h)
set(REPETITIONS 1)
add_all_exe()

