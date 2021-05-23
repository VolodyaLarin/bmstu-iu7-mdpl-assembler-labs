#include <stdio.h>
#include <time.h>

#define define_mesure_gnu(type)                        \
  void mesure_##type(int times, type a, type b) {  \
    clock_t start = clock();                           \
    type res;                                          \
    for (size_t i = 0; i < times; ++i) {               \
      res = a + b;                                     \
    }                                                  \
    clock_t time_sum = clock() - start;                \
                                                       \
    start = clock();                                   \
    for (size_t i = 0; i < times; ++i) {               \
      res = a * b;                                     \
    }                                                  \
    clock_t time_mul = clock() - start;                \
                                                       \
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul); \
  }

#define define_mesure_asm(type)                        \
  void mesure_##type(int times, type a, type b) {  \
    clock_t start = clock();                           \
    type res;                                          \
    for (size_t i = 0; i < times; ++i) {               \
      asm("fld %1\n"                                   \
          "fld %2\n"                                   \
          "faddp\n"                                    \
          "fstp %0\n"                                  \
          : "=m"(res)                                  \
          : "m"(a), "m"(b));                           \
    }                                                  \
    clock_t time_sum = clock() - start;                \
                                                       \
    start = clock();                                   \
    for (size_t i = 0; i < times; ++i) {               \
      asm("fld %1\n"                                   \
          "fld %2\n"                                   \
          "fmulp\n"                                    \
          "fstp %0\n"                                  \
          : "=m"(res)                                  \
          : "m"(a), "m"(b));                           \
    }                                                  \
    clock_t time_mul = clock() - start;                \
                                                       \
    printf("Sum: %zu Mul: %zu\n", time_sum, time_mul); \
  }

#ifndef USE_ASM
#ifdef USE_FLOAT_80
define_mesure_gnu(__float80)
#endif
define_mesure_gnu(float);
define_mesure_gnu(double);
#endif

#ifdef USE_ASM
#define USE_FLOAT_80
define_mesure_asm(__float80);
define_mesure_asm(float);
define_mesure_asm(double);
#endif



int main() {
  int times = 1e7;

  double a = 10.2, b = -234.3;
  printf("Float ===");
  mesure_float(times, a, b);
  printf("Double ===");
  mesure_double(times, a, b);

#ifdef USE_FLOAT_80

  printf("Long double ===");
  mesure___float80(times, a, b);
#endif

  return 0;
}