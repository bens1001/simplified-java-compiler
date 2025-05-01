flex lexical.l
bison -d -v syntaxique.y 
gcc lex.yy.c syntaxique.tab.c -o projet -lfl -ly
projet.exe EXAMPLE3.txt < EXAMPLE3.txt
