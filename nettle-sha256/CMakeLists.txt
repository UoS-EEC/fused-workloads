cmake_minimum_required(VERSION 3.13)
set(NAME nettle-sha256)
set(SOURCES main.c nettle-sha256.c benchmark.h)
add_all_exe()
