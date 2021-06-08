#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>

int main(void) {
  struct timespec tms;
  clock_gettime(CLOCK_REALTIME, &tms);
  printf("%" PRId64 "\n", (int64_t)(tms.tv_sec * 1000 + tms.tv_nsec / 1000000));
}
