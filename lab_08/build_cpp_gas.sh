
as funcs.S -o funcs.o

g++ -c main.cpp -g3 -ggdb -masm=intel
g++ -o ./a_cpp_gas.out  main.o funcs.o -lgtest -lpthread -g3 -ggdb 
./a_cpp_gas.out