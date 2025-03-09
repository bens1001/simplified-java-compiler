flex lexical.l
gcc lex.yy.c -o projet -lfl
projet.exe EXAMPLE.txt < EXAMPLE.txt