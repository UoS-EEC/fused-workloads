/* fused.h
 *
 * @brief Definitions/macros for custom hardware/simulation control in Fused
 *
 */

/* ------ SimpleMonitor ------ */
#define SIMPLE_MONITOR *((unsigned int *)0x40000000)
#define SIMPLE_MONITOR_KILL_SIM 0x0D1E
#define SIMPLE_MONITOR_START_EVENT_LOG 0x000E
#define SIMPLE_MONITOR_INDICATE_BEGIN 0x0001
#define SIMPLE_MONITOR_INDICATE_END 0x0002

/* ------ NVM controller ------ */
