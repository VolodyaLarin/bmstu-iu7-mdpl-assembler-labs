#include <float.h>
#include <stdio.h>
#include <time.h>

typedef struct {
  float buf[4];
} vector_t;

void c_scalar_prod(float *dst, const float *a, const float *b, int n) {
  float tmp = 0;
  for (size_t i = 0; i < n; i++) {
    tmp += a[i] * b[i];
  }

  *dst = tmp;
}

void sse_scalar_prod(float *dst, float *src_a, float *src_b, int n) {
  float tmp;
  *dst = 0;
  __float128 *a = src_a;
  __float128 *b = src_b;
  for (size_t i = 0; i < n; i += 4, a++, b++) {
    __asm__(
        "movaps xmm0, %1\n"
        "movaps xmm1, %2\n"
        "mulps xmm0, xmm1\n"
        "movhlps xmm1, xmm0\n"
        "addps xmm0, xmm1\n"
        "movaps xmm1, xmm0\n"
        "shufps xmm0, xmm0, 1\n"
        "addps xmm0, xmm1\n"
        "movss %0, xmm0\n"
        : "=m"(tmp)
        : "m"(*a), "m"(*b)
        : "xmm0", "xmm1");
    *dst += tmp;
  }
}
int main() {
  size_t count = 1e7;
  float a = 20.0;
  float b = 20.0;
  float c = 10.0;
  float d = 12.0;

  float res_c = 0;

  int n = 16;
  float vec_a[16] = {a, b, c, d, a, b, d, c, b, a, c, d, a, b, c, d};
  float vec_b[16] = {d, c, b, a, d, a, b, d, c, b, a, c, d, a, b, b};

  clock_t start = clock();
  printf("TEST C IMPLEMENTATION \n");
  for (size_t i = 0; i < count; i++) {
    c_scalar_prod(&res_c, vec_a, vec_b, n);
  }
  clock_t time_c = clock() - start;

  printf("C scalar multiply\n\t%zu\n", time_c);
  printf("TEST SSE ASSEMBLY\n");
  float res_asm = 0;
  start = clock();
  for (size_t i = 0; i < count; i++) {
    sse_scalar_prod(&res_asm, vec_a, vec_b, n);
  }
  clock_t time_asm = clock() - start;
  printf("SSE ASM scalar multiply\n\t%zu\n", time_asm);
  printf("LAST VALUES ARE EQUALS %d\n", res_asm == res_c);
  printf("C/ASM = %lf\n", (double)time_c / (double)time_asm);

  return 0;
}