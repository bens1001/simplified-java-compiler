flex lexical.l
bison -d syntaxique.y 
gcc lex.yy.c syntaxique.tab.c -o projet.exe -lfl -ly
projet.exe EXAMPLE.txt < EXAMPLE.txt