#pragma once

#define MONITOR *((unsigned int *)0x40000000)
#define MONITOR_KILL_SIM 0x0D1E
#define MONITOR_INDICATE_BEGIN 0x0001
#define MONITOR_INDICATE_END 0x0002

void target_init();
void wait();
void indicate_begin();
void indicate_end();
void _start();
