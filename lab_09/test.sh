
echo MATH Operations
gcc ./asm_math.c -masm=intel -lm
./a.out

echo 
echo SSE
gcc -c main.cpp  -mno-80387 -O0
gcc main.cpp  -mno-80387 -O0
objdump -M intel-mnemonic -d main.o  > ./main_sse.txt
./a.out

echo
echo FPU
gcc -c main.cpp -DUSE_FLOAT_80 -m80387 -mno-sse -O0
gcc main.cpp -DUSE_FLOAT_80 -m80387 -mno-sse -O0
objdump -M intel-mnemonic -d main.o  > ./main_fpu.txt
./a.out

echo
echo Assembler Embending
gcc -c main.cpp -DUSE_ASM -masm=intel -O0
gcc main.cpp -DUSE_ASM -masm=intel -O0
objdump -M intel-mnemonic -d main.o  > ./main_asm.txt
./a.out



