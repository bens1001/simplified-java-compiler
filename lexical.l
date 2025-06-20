
%{
	#include "syntaxique.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern int nb_line;
	extern int nb_character;
	extern char *file_name;
	int precision;
	extern YYSTYPE yylval;
	extern char string_size[20];
	extern char string_message[20];
	extern char current_scope[256];
%}
letter [a-zA-Z]
number [0-9]
IDF {letter}({letter}|{number})*
integer [-+]?{number}+
real [-+]?{number}+"."{number}+
string  (\"([^\"\n]+)\"|'([^'\n]+)')
bool "TRUE"|"FALSE"|"true"|"false"
commentaire "\/\/"[^\n]*
exception {letter}*"Exception"
%%
"boolean" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwBOOLEAN;
}
"break" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwBREAK;
}
"case" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwCASE;
}
"catch" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwCATCH;
}
"char" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwCHAR;
}
"class" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwCLASS;
}
"default" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwDEFAULT;
}
"do" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwDO;
}
"double" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwDOUBLE;
}
"else" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwELSE;
}
"finally" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwFINALLY;
}
"float" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwFLOAT;
}
"for" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwFOR;
}
"if" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwIF;
}
"import" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwIMPORT;
}
"int" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwINT;
}
"main"|"Main" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str = strdup(yytext);
	return kwMAIN;
}
"new" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwNEW;
}
"public" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwPUBLIC;
}
"return" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwRETURN;
}
"static" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwSTATIC;
}
"switch" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwSWITCH;
}
"System.out.println" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwPRINTLN;
}
"System.out.print" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwPRINT;
}
"this" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwTHIS;
}
"try" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwTRY;
}
"void" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwVOID;
}
"while" {
	ECHO; 
	nb_character += strlen(yytext);
	search(yytext,"Keyword","-1","-1","-1","-1","-1","-1",1);
	yylval.str=strdup(yytext);
	return kwWHILE;
}

{exception} {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Exception Type","-","-","-","-","-",current_scope,0);
	yylval.str = strdup(yytext);
	return EXCEPTION;
}
{bool} {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"IDF","boolean","-","-","-","-","-",0);
	yylval.str=strdup(yytext);
	return BOOL;
}
{real} {
    precision = 0;
    // Vérifier le nombre de chiffres après la virgule
    if (strchr(yytext, '.') != NULL) {
        precision = strlen(strchr(yytext, '.')) - 1;
    }

    if (atof(yytext) >= -3.4e38 && atof(yytext) <= 3.4e38 && precision <= 7) {
        ECHO;
        nb_character += strlen(yytext);
		search(yytext,"Constant","float","-","-","-","-","-",0);
        yylval.flt = atof(yytext);
        return FLOAT;
    }
    else if (atof(yytext) >= -1.7e308 && atof(yytext) <= 1.7e308 && precision <= 16) {
        ECHO;
        nb_character += strlen(yytext);
		search(yytext,"Constant","double","-","-","-","-","-",0);
       	yylval.dbl = atof(yytext);
        return DOUBLE;
    }
    else {
        printf("\nFile '%s', lexical error, line %d, column %d, entity '%s' \n",file_name,nb_line,nb_character,yytext);
    }
}
{integer} {	
	if (atoi(yytext) >= -32768 && atoi(yytext) <= 32767) { 
		ECHO;
		nb_character += strlen(yytext);
		search(yytext,"Constant","int","-","-","-","-","-",0);
		yylval.intg=atoi(yytext);
		return INTEGER;
    } 
	else{
		printf("\nFile '%s', lexical error, line %d, column %d, entity '%s' \n",file_name,nb_line,nb_character,yytext);
	}	
}
{string} {
	ECHO;
	nb_character += strlen(yytext);
	yylval.str=strdup(yytext);
	return STRING;
}
{IDF} {
	if(strlen(yytext)>256){		
		printf("\nFile '%s', lexical error, line %d, column %d, entity '%s' \n",file_name,nb_line,nb_character,yytext);
	}
	else{
		ECHO;
		nb_character += strlen(yytext);
		yylval.str=strdup(yytext);
		return IDF;
	}
}

">=" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opGE;
}
">" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opGT;
}
"==" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opEQ;
}
"<=" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opLE;
}
"<" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opLT;
}
"!=" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opNE;
}
"||" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opOR;
}
"&&" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opAND;
}
"!" { 
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opNOT;
}
"+" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opADD;
}
"-" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opMINUS;
}
"*" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opMUL;
}
"/" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opDIV;
}
"%" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opMOD;
}
"=" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return opASSIGN;
}
";" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return pvg;
}
"(" {
    ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return po;
}
")" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return pf;
}
"{" {
    ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return acco;
}
"}" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return accf;
}
"[" {
    ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return dimo;
}
"]" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return dimf;
}
"." {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return pt;
}
"," {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return vg;
}
":" {
	ECHO;
	nb_character += strlen(yytext);
	search(yytext,"Separateur","-1","-1","-1","-1","-1","-1",2);
	yylval.str=strdup(yytext);
	return dp;
}


{commentaire} {
	ECHO;
	nb_character += strlen(yytext);
}

[ \t] {
	ECHO;
	nb_character += strlen(yytext);
}

\n {ECHO; nb_line++; nb_character=0;}

. {
	nb_character += strlen(yytext);
	printf("\nFile '%s', lexical error, line %d, column %d, entity '%s' \n",file_name,nb_line,nb_character,yytext);
}
