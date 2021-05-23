
nasm -f elf64 funcs.nasm

g++ -c main.cpp -g3 -ggdb -masm=intel
g++ -o ./a_cpp_nasm.out  main.o funcs.o -lgtest -lpthread -g3 -ggdb 
./a_cpp_nasm.out