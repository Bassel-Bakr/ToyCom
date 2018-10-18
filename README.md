# Compilation
```
bison test.y -d -o test.cpp
flex -o a.cpp test.l
g++ -std=c++17 -c a.cpp test.cpp
g++ -std=c++17 a.o test.o -o a
rlwrap ./a < in
```