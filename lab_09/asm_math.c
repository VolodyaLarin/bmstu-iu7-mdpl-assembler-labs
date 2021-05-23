#include <stdio.h>
#include <math.h>

#define ldpres "%.20lf"
int main(void)
{
    double half = 0.5;
    double res;

	printf("LIB sin(3.14): " ldpres "\n", sin(3.14));
	printf("LIB sin(3.141596): " ldpres "\n", sin(3.141596));
	printf("LIB sin(M_PI): " ldpres "\n", sin(M_PI));
	asm(
		"fldpi\n"
        "fsin\n"
        "fstp %0\n" 
        : "=m" (res)
	);
	printf("FPU sin(pi): %.10f\n", res);
	
	printf("LIB sin(3.14 / 2): " ldpres "\n", sin(3.14 / 2));
	printf("LIB sin(3.141596 / 2): " ldpres "\n", sin(3.141596 / 2));
    printf("LIB sin(M_PI_2): " ldpres "\n", sin(M_PI_2));

	asm(
		"fld %1\n"
		"fldpi\n"
		"fmulp\n"
        "fsin\n"
        "fstp %0\n" 
        : "=m" (res)
		: "m" (half)
	);
	printf("FPU sin(pi / 2): " ldpres "\n", res);

}