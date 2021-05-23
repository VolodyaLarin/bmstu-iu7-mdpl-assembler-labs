
fasm funcs.asm

g++ -c main.cpp -g3 -ggdb -masm=intel
g++ -o ./a_cpp.out  main.o funcs.o -lgtest -lpthread -g3 -ggdb 

./a_cpp.out