%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "ts.h"
#include "quad.h"

int nb_line=1;
int nb_character=0;
char *file_name;
char taille[20];
char empla[20];
int emp=1;
char typeIDF[20];
char savet[20];
int param=0;
char para[20];

char i[20];
int deb_else;
int fin_if;
int fin_dowhile;
int deb_dowhile;
int qc;

char partie1_1[20];
char partie2_1[20];
char partie1_2[20];
char partie2_2[20];
char ch[20];
char cat[20];
int tmp=0;
char temp[20];

char tab[20];

%}

%union {
    char* str;
}

%type <str>TYPE OBJECT EXPRESSION MESSAGE MESSAGEIDF MESSAGEVAR INDEX CONDITION OPLOG OPCOMP
;

%token <str>kwBOOLEAN kwBREAK kwCASE kwCHAR kwCATCH kwCLASS kwCONTINUE kwDEFAULT kwDO kwDOUBLE kwELSE kwFINAL kwFINALLY kwFLOAT kwIF kwINT kwMAIN kwNEW kwPRIVATE kwPUBLIC kwRETURN kwSTATIC kwSWITCH kwPRINTLN kwTHIS kwTRY kwVOID kwWHILE BOOL FLOAT DOUBLE INTEGER STRING IDF opGE opGT opEQ opLE opLT opNE opOR opAND opNOT opADD opMINUS opMUL opDIV opMOD opASSIGN pvg po pf acco accf dimo dimf pt vg dp
;

%start JAVA

%right opASSIGN 
%left opADD opMINUS
%left opMUL opDIV opMOD
%left opGE opGT opEQ opLE opLT opNE
%left opOR
%left opAND 

%%
JAVA: CLASSLIST MAIN {printf("\n\nCode correct!\n\n"); YYACCEPT;}
;

CLASS: kwCLASS IDF acco ENTITYLIST accf 
;

CLASSLIST: CLASS CLASSLIST
         | {emp=0;}

MAIN: kwMAIN acco kwPUBLIC kwSTATIC kwVOID kwMAIN po METHODPARAM pf acco INST accf accf

ENTITY: CONSTRUCTOR 
      | METHOD 
      | VARIABLE 
;

ENTITYLIST: ENTITY ENTITYLIST
          | ENTITY
;

CONSTRUCTOR: IDF po METHODPARAM pf acco INST accf
        
METHOD: TYPE IDF po METHODPARAM pf acco INST accf
;

METHODPARAM: IDF METHODPARA
           | 
;

METHODPARA: vg IDF METHODPARA
          |
;

TYPE: kwINT     {$$=strdup($1);strcpy(savet,$1);}
    | kwFLOAT   {$$=strdup($1);strcpy(savet,$1);}
    | kwDOUBLE  {$$=strdup($1);strcpy(savet,$1);}
    | kwBOOLEAN {$$=strdup($1);strcpy(savet,$1);}
    | kwCHAR    {$$=strdup($1);strcpy(savet,$1);}
    | kwVOID    {$$=strdup($1);strcpy(savet,$1);}
    | OBJECT    {$$=strdup($1);strcpy(savet,$1);}
;

OBJECT: IDF {$$=strdup($1);}

VARIABLE : VAR VARIABLE 
         | VARRAY  VARIABLE
         | VMAT  VARIABLE
         |
;

VAR: TYPE IDF LISTVARIABLE pvg 
              { 
                // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (emp==0)
                //   miseajour($2,"Variable",$1,"-1","/","/","/","GLOBAL","SYNTAXIQUE");
                // else {
                //   sprintf(empla,"LOCAL %d",emp); 
                //   miseajour($2,"Variable",$1,"-1","/","/","/",empla,"SYNTAXIQUE");
                // }
              }
    | TYPE IDF opASSIGN EXPRESSION LISTVARIABLE pvg 
              { 
                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (emp==0)
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(empla,"LOCAL %d",emp); 
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);
              }
; 

DIMENSIONARRAY: INTEGER
              | 
;

ARRAY : vg EXPRESSION ARRAY 
      | accf
;

VARRAY: TYPE dimo DIMENSIONARRAY dimf IDF LISTVARIABLE pvg 
            { 
              // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
              //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
              //   YYABORT;
              // }
              // if (emp==0)
              //   miseajour($2,"Vecteur",$1,"/",$4,$4,"/","GLOBAL","SYNTAXIQUE");
              // else {
              //   sprintf(empla,"LOCAL %d",emp); 
              //   miseajour($2,"Vecteur",$1,"/",$4,$4,"/",empla,"SYNTAXIQUE");
              // }
              // if(atof($5)<1){
              //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
              //   YYABORT;
              // }
              // remplir_quad("BOUNDS","1",$5,"<vide>");
              // remplir_quad("ADEC",$2,"<vide>","<vide>");
            }
      | TYPE dimo DIMENSIONARRAY dimf IDF opASSIGN acco EXPRESSION ARRAY LISTVARIABLE pvg 
              { 
                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (emp==0)
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(empla,"LOCAL %d",emp); 
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);
              }
;

MATRIX: ARRAY vg
      | accf
;

VMAT: TYPE dimo INTEGER vg INTEGER dimf IDF LISTVARIABLE pvg 
            { 
              // sprintf(taille,"%d",atoi($4)*atoi($6));
              // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
              //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
              //   YYABORT;
              // }
              // if (emp==0)
              //   miseajour($2,"Matrice",$1,"/",taille,$4,$6,"GLOBAL","SYNTAXIQUE");
              // else {
              //   sprintf(empla,"LOCAL %d",emp); 
              //   miseajour($2,"Matrice",$1,"/",taille,$4,$6,empla,"SYNTAXIQUE"); 
              // }
              // if(atof($4)<1 || atof($6)<1){
              //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
              //   YYABORT;
              // }
              // remplir_quad("BOUNDS","1",$4,"<vide>");
              // remplir_quad("BOUNDS","2",$6,"<vide>");
              // remplir_quad("ADEC",$2,"<vide>","<vide>");
            }
    | TYPE dimo INTEGER vg INTEGER dimf IDF opASSIGN acco ARRAY MATRIX LISTVARIABLE pvg 
              { 
                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (emp==0)
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(empla,"LOCAL %d",emp); 
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);
              }
;

LISTVARIABLE: LISTVAR
            | LISTVARRAY
            | LISTVMAT
            | 
;

LISTVAR: vg IDF LISTVARIABLE 
                  {  
                    // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (emp==0)
                    //   miseajour($2,"Variable",savet,"-1","/","/","/","GLOBAL","SYNTAXIQUE");
                    // else {
                    //   sprintf(empla,"LOCAL %d",emp); 
                    //   miseajour($2,"Variable",savet,"-1","/","/","/",empla,"SYNTAXIQUE");
                    // }
                  }
        | vg IDF opASSIGN EXPRESSION LISTVARIABLE 
                  { 
                    // diviserChaine($4,partie1_1,partie1_2);
                    // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (emp==0)
                    //   miseajour($2,"Variable",savet,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                    // else {
                    //   sprintf(empla,"LOCAL %d",emp); 
                    //   miseajour($2,"Variable",savet,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                    // }
                    // if (strcmp(getType($2,emp,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                    //   if(strcmp(getType($2,emp,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(getType($2,emp,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($2,emp,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // remplir_quad("=",partie1_2,"<vide>",$2);
                  }
;

LISTVARRAY: vg dimo DIMENSIONARRAY dimf IDF LISTVARIABLE 
                  { 
                    // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (emp==0)
                    //   miseajour($2,"Vecteur",savet,"/",$5,$5,"-1","GLOBAL","SYNTAXIQUE");
                    // else {
                    //   sprintf(empla,"LOCAL %d",emp); 
                    //   miseajour($2,"Vecteur",savet,"/",$5,$5,"-1",empla,"SYNTAXIQUE");
                    // }
                    // if(atof($5)<1){
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");
                  }
          | vg dimo DIMENSIONARRAY dimf IDF opASSIGN ARRAY LISTVARIABLE 
                  { 
                    // diviserChaine($4,partie1_1,partie1_2);
                    // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (emp==0)
                    //   miseajour($2,"Variable",savet,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                    // else {
                    //   sprintf(empla,"LOCAL %d",emp); 
                    //   miseajour($2,"Variable",savet,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                    // }
                    // if (strcmp(getType($2,emp,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                    //   if(strcmp(getType($2,emp,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(getType($2,emp,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($2,emp,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // remplir_quad("=",partie1_2,"<vide>",$2);
                  }
;

LISTVMAT: vg dimo INTEGER vg INTEGER dimf IDF LISTVARIABLE 
                  { 
                    // sprintf(taille,"%d",atoi($5)*atoi($7));
                    // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (emp==0)
                    //   miseajour($2,"Matrice",savet,"/",taille,$5,$7,"GLOBAL","SYNTAXIQUE");
                    // else {
                    //   sprintf(empla,"LOCAL %d",emp); 
                    //   miseajour($2,"Matrice",savet,"/",taille,$5,$7,empla,"SYNTAXIQUE");
                    // } 
                    // if(atof($5)<1 || atof($7)<1){
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("BOUNDS","2",$7,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");
                  }
          | vg dimo INTEGER vg INTEGER dimf IDF opASSIGN MATRIX LISTVARIABLE pvg 
              { 
                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (emp==0)
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(empla,"LOCAL %d",emp); 
                //   miseajour($2,"Variable",$1,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);
              }
;

INST: INSTS INST
    |
;

INSTS: OUTPUT    pvg 
     | ASSIGN    pvg 
     | CONTROLE        
     /* | BOUCLE     
     | CALLPROC  pvg   {param=0;} */
     | RETURN    pvg
; 

INDEX: IDF 
        { 
          // if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
          //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
          //   YYABORT;
          // }
          // strcpy(typeIDF,getType($1,emp,"Variable"));
          // if(strcmp(typeIDF,"INTEGER")!=0){
          //   printf("\nFile '%s', line %d, character %d: semantic error : Unexpected index type '%s'.\n",file_name,nb_line,nb_character,$1);
          //   YYABORT;
          // }
          // else{
          //   if(atof($1)<1){
          //     printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
          //     YYABORT;
          //   }
          // }
        }
     | INTEGER 
        {
          // if(atof($1)<1){
          //     printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
          //     YYABORT;
          // }
          // $$=strdup($1);
        }
;

OUTPUT: kwPRINTLN po MESSAGE pf 
          {
            // search($3,"Idf","STRING","/","-1","/","/","/",3);
          }
      | kwPRINTLN po MESSAGEVAR pf  
          {
            // search($3,"Idf","STRING","/","-1","/","/","/",3);
          }
; 

MESSAGE: STRING MESSAGEIDF
          {
            // strcat(tab,$1);strcat(tab,$2);
            // $$=strdup(tab);
            // strcpy(tab," ");
          }
       | STRING
          {
            // $$=strdup($1);
          }
       | MESSAGEVAR opADD MESSAGE
          {
            // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);
            // $$=strdup(tab);
            // strcpy(tab," ");
          }
;

MESSAGEIDF: opADD MESSAGEVAR opADD MESSAGE
              {
                // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                // $$=strdup(tab);
                // strcpy(tab," ");
              }
          | opADD MESSAGEVAR 
              {
                // strcat(tab,$1);strcat(tab,$2);
                // $$=strdup(tab);
                // strcpy(tab," ");
              }
;

MESSAGEVAR : IDF                      
                { 
                  // if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                  //   YYABORT;
                  // }
                  // $$=strdup($1);
                }
          | IDF dimo INDEX dimf 
                { 
                  // if (!idf_existe($1,emp,"Vecteur") && !idf_existe($1,emp,"Parametre")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                  //   YYABORT;
                  // }
                  // $$=strdup($1);
                }
          | IDF dimo INDEX vg INDEX dimf 
                { 
                  // if (!idf_existe($1,emp,"Matrice") && !idf_existe($1,emp,"Parametre")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                  //   YYABORT;
                  // }
                  // $$=strdup($1);
                }
;

ASSIGN: IDF opASSIGN EXPRESSION  
                  { 
                    // if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // diviserChaine($3,partie1_1,partie1_2);
                    // strcpy(typeIDF,getType($1,emp,"Variable"));
                    // if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //       printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($1,emp,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // remplir_quad("=",partie1_2,"<vide>",$1);
                    // miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                  }
        | IDF dimo INDEX dimf opASSIGN EXPRESSION
                  { 
                    // diviserChaine($6,partie1_1,partie1_2);
                    // if (!idf_existe($1,emp,"Vecteur") && !idf_existe($1,emp,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // strcpy(typeIDF,getType($1,emp,"Vecteur"));
                    // if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($1,emp,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    // remplir_quad("=",partie1_2,"<vide>",tab);
                    // miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    // strcpy(tab," ");
                  }   
           | IDF dimo INDEX vg INDEX dimf opASSIGN EXPRESSION
                  { 
                    // diviserChaine($8,partie1_1,partie1_2);
                    // if (!idf_existe($1,emp,"Matrice") && !idf_existe($1,emp,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // strcpy(typeIDF,getType($1,emp,"Matrice"));
                    // if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($1,emp,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);strcat(tab,$5);strcat(tab,$6);
                    // remplir_quad("=",partie1_2,"<vide>",tab);
                    // miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    // strcpy(tab," ");
                  }  
;

EXPRESSION: EXPRESSION opADD EXPRESSION
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                    //   strcpy(cat,"REAL-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // else{
                    //   strcpy(cat,"INTEGER-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // remplir_quad("+",partie1_2,partie2_2,temp);
                    // tmp++;
                  }  
          | EXPRESSION opMINUS EXPRESSION
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                    //   strcpy(cat,"REAL-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // else{
                    //   strcpy(cat,"INTEGER-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // remplir_quad("-",partie1_2,partie2_2,temp);
                    // tmp++;
                  }  
          | EXPRESSION opMUL EXPRESSION
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                    //   strcpy(cat,"REAL-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // else{
                    //   strcpy(cat,"INTEGER-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // remplir_quad("*",partie1_2,partie2_2,temp);
                    // tmp++;
                  }  
          | EXPRESSION opMOD EXPRESSION
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                    //   strcpy(cat,"REAL-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // else{
                    //   strcpy(cat,"INTEGER-");
                    //   strcat(cat,temp);
                    //   $$=strdup(cat);
                    // }
                    // remplir_quad("*",partie1_2,partie2_2,temp);
                    // tmp++;
                  }  
          | EXPRESSION opDIV EXPRESSION 
                  {  
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie2_2,"0") == 0) { 
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // strcpy(cat,"REAL-");
                    // strcat(cat,temp);
                    // $$=strdup(cat);
                    // remplir_quad("/",partie1_2,partie2_2,temp);
                    // tmp++;
                  } 
          | IDF  
                  { 
                    // if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // strcpy(ch,"-");
                    // strcat(ch,$1);
                    // if (idf_existe($1,emp,"Variable")) strcpy(cat,getType($1,emp,"Variable"));
                    // if (idf_existe($1,emp,"Parametre")) strcpy(cat,getType($1,emp,"Parametre"));
                    // strcat(cat,ch);
                    // $$=strdup(cat);
                  }      
          | IDF dimo INDEX dimf 
                  {
                    // if (!idf_existe($1,emp,"Vecteur") && !idf_existe($1,emp,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // if (!verif_index($1,emp,"Vecteur",$3,"Ligne")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s)'.\n",file_name,nb_line,nb_character,$1,$3);
                    //   YYABORT;
                    // }
                    // strcpy(ch,"-");
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    // strcat(ch,tab);
                    // strcpy(tab," ");
                    // if (idf_existe($1,emp,"Vecteur")) strcpy(cat,getType($1,emp,"Vecteur"));
                    // if (idf_existe($1,emp,"Parametre")) strcpy(cat,getType($1,emp,"Parametre"));
                    // strcat(cat,ch);
                    // $$=strdup(cat);
                  }
          | IDF dimo INDEX vg INDEX dimf
                  {
                    // if (!idf_existe($1,emp,"Matrice") && !idf_existe($1,emp,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // if (!verif_index($1,emp,"Matrice",$3,"Ligne") || !verif_index($1,emp,"Matrice",$5,"Colonne")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s,%s)'.\n",file_name,nb_line,nb_character,$1,$3,$5);
                    //   YYABORT;
                    // }
                    // strcpy(ch,"-");
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);strcat(tab,$5);strcat(tab,$6);
                    // strcat(ch,tab);
                    // strcpy(tab," ");
                    // if (idf_existe($1,emp,"Matrice")) strcpy(cat,getType($1,emp,"Matrice"));
                    // if (idf_existe($1,emp,"Parametre")) strcpy(cat,getType($1,emp,"Parametre"));
                    // strcat(cat,ch);
                    // $$=strdup(cat);
                  }             
          | DOUBLE    
              {
                // strcpy(cat,"REAL-");
                // strcat(cat,$1);
                // $$=strdup(cat);
              }                
          | FLOAT    
              {
                // strcpy(cat,"REAL-");
                // strcat(cat,$1);
                // $$=strdup(cat);
              }                
          | INTEGER  
              {
                // strcpy(cat,"INTEGER-");
                // strcat(cat,$1);
                // $$=strdup(cat);
              }                  
          | BOOL  
              {
                // strcpy(cat,"LOGICAL-");
                // strcat(cat,$1);
                // $$=strdup(cat);
              }                    
          | STRING  
              {
                // strcpy(cat,"CHARACTER-");
                // strcat(cat,$1);
                // $$=strdup(cat);
              }                 
          | po EXPRESSION pf  
              {
                // $$=strdup($2);
              }        
;

R2_1_CONTROLE: kwIF CONDITION 
              {
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",$2,"<vide>");
              }
;

R1_2_CONTROLE: R2_1_CONTROLE acco INST 
              {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              }
;

R3_1_CONTROLE: kwIF EXPRESSION 
              {
                diviserChaine($2,partie1_1,partie1_2);
                if (strcmp(partie1_1,"LOGICAL")!=0 && strcmp(partie1_1,"/")!=0){
                  printf("\nFile '%s', line %d, character %d: semantic error : Unexpected expression type.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",partie1_2,"<vide>");
                
              }
;

R4_2_CONTROLE: R3_1_CONTROLE acco INST 
              {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              }
;

CONTROLE: R1_2_CONTROLE kwELSE INST accf 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R2_1_CONTROLE acco INST accf 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R3_1_CONTROLE acco INST accf 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R4_2_CONTROLE kwELSE INST accf 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
;

CONDITION: po EXPRESSION pt OPCOMP pt EXPRESSION pf
              { 
                diviserChaine($2,partie1_1,partie1_2);
                diviserChaine($6,partie2_1,partie2_2);
                sprintf(temp,"T%d",tmp);
                if (strcmp(partie2_1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0) {
                  if(!((strcmp(partie1_1,"REAL")==0 && strcmp(partie2_1,"INTEGER")==0) || (strcmp(partie2_1,"REAL")==0 && strcmp(partie1_1,"INTEGER")==0))){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                $$=strdup(temp);
                remplir_quad($4,partie1_2,partie2_2,temp);
                tmp++;
              }
         | po CONDITION pt OPLOG pt CONDITION pf
              {
                sprintf(temp,"T%d",tmp);
                $$=strdup(temp);
                remplir_quad($4,$2,$6,temp);
                tmp++;
              }
         | po CONDITION pf
              {
                $$=strdup($2);
              }
;               

OPLOG: opAND {$$=strdup($1);}
     | opOR  {$$=strdup($1);}
;

OPCOMP: opGT {$$=strdup($1);}
      | opGE {$$=strdup($1);} 
      | opEQ {$$=strdup($1);}
      | opLE {$$=strdup($1);}
      | opLT {$$=strdup($1);}
      | opNE {$$=strdup($1);}
;

RETURN: kwRETURN EXPRESSION 
;

/* COMPIL: PROC MAIN {printf("\n\nCode correct!\n\n"); YYACCEPT;}
; */

/* PROC: SIGNATURE ROUTINE PROC
    | {emp=0;}
; */

/* SIGNATURE: TYPEPROC kwROUTINE idf po PARAM pf 
          { 
            if (idf_existe($3,-1,"Fonction")) {
              printf("\nFile '%s', line %d, character %d: semantic error : Double function declaration '%s'.\n",file_name,nb_line,nb_character,$3);
              YYABORT;
            }
            sprintf(para,"%d",param); 
            miseajour($3,"Fonction",$1,"-1",para,"/","/","-1","SYNTAXIQUE");
            param=0;
          }
; */

/* TYPEPROC: kwINTEGER   {$$=strdup($1);}
        | kwREAL      {$$=strdup($1);}
        | kwLOGICAL   {$$=strdup($1);}
        | kwCHARACTER {$$=strdup($1);}
; */

/* PARAM: idf PARA
          { 
            sprintf(empla,"LOCAL %d",emp);
            miseajour($1,"Parametre","/","/","/","/","/",empla,"SYNTAXIQUE");
            param++;
          }
     | 
; */

/* PARA: vg idf PARA
          { 
            sprintf(empla,"LOCAL %d",emp);
            miseajour($2,"Parametre","/","/","/","/","/",empla,"SYNTAXIQUE");
            param++;
          }
    |
; */

/* ROUTINE: DEC INSTPROC kwENDR {emp++;}
; */

/* INSTPROC: EQU         INSTSPROC        
        | ENTREE      INSTSPROC      
        | SORTIE      INSTSPROC 
        | AFFECTATION INSTSPROC   
        | CALLPROC    INSTSPROC     {param=0;}
        | CONTROLE    INSTSPROCBLOC
        | BOUCLE      INSTSPROCBLOC
        | RETOUR
; */

/* INSTSPROC: pvg EQU          INSTSPROC 
         | pvg ENTREE       INSTSPROC
         | pvg SORTIE       INSTSPROC
         | pvg AFFECTATION  INSTSPROC
         | pvg CONTROLE     INSTSPROCBLOC
         | pvg BOUCLE       INSTSPROCBLOC
         | pvg CALLPROC     INSTSPROC     {param=0;}
         | pvg RETOUR
;  */

/* INSTSPROCBLOC: EQU          INSTSPROC 
             | ENTREE       INSTSPROC
             | SORTIE       INSTSPROC
             | AFFECTATION  INSTSPROC
             | CONTROLE     INSTSPROCBLOC
             | BOUCLE       INSTSPROCBLOC
             | CALLPROC     INSTSPROC     {param=0;}
             | RETOUR
; */

/* RETOUR: idf aff EXPRESSION  
            { 
              diviserChaine($3,partie1_1,partie1_2);
              if (!idf_existe($1,emp,"Fonction")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Wrong function return '%s'.\n",file_name,nb_line,nb_character,$1);
                YYABORT;
              }
              strcpy(typeIDF,getType($1,emp,"Fonction"));
              if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
              }
              remplir_quad("=",partie1_2,"<vide>",$1);
              miseajour($1,"Fonction","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
            }
; */

/* MAIN: kwPROGRAM idf DEC INST kwEND pt { miseajour($2,"Programme Principal","/","/","/","/","/","GLOBAL","SYNTAXIQUE");}
; */

/* DEC: DECSOLO DEC 
   | DECTAB  DEC
   | DECMAT  DEC
   |
; */

/* TYPE: kwINTEGER  {$$=strdup($1);strcpy(savet,$1);}
    | kwREAL     {$$=strdup($1);strcpy(savet,$1);}
    | kwLOGICAL  {$$=strdup($1);strcpy(savet,$1);}
; */

/* DECSOLO: TYPE idf LISTVAR pvg 
              { 
                if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (emp==0)
                  miseajour($2,"Variable",$1,"-1","/","/","/","GLOBAL","SYNTAXIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour($2,"Variable",$1,"-1","/","/","/",empla,"SYNTAXIQUE");
                }
              }
       | TYPE idf aff EXPRESSION LISTVAR pvg 
              { 
                diviserChaine($4,partie1_1,partie1_2);
                if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (emp==0)
                  miseajour($2,"Variable",$1,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour($2,"Variable",$1,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                }
                if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                  if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                remplir_quad("=",partie1_2,"<vide>",$2);
              }
       | kwCHARACTER idf MULCHAR LISTVARSOLOCHAR pvg 
              { 
                if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (emp==0)
                  miseajour($2,"Variable",$1,"-1",$3,"/","/","GLOBAL","SYNTAXIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour($2,"Variable",$1,"-1",$3,"/","/",empla,"SYNTAXIQUE");
                }
              } 
       | kwCHARACTER idf MULCHAR aff EXPRESSION LISTVARSOLOCHAR pvg 
              {
                diviserChaine($5,partie1_1,partie1_2);
                if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (emp==0)
                  miseajour($2,"Variable",$1,partie1_2,$3,"/","/","GLOBAL","SEMANTIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour($2,"Variable",$1,partie1_2,$3,"/","/",empla,"SEMANTIQUE");
                }
                if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                if (!verif_char($2,emp,"Variable",partie1_2)) {
                  printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                remplir_quad("=",partie1_2,"<vide>",$2);
              }  
;  */

/* DECTAB: TYPE idf kwDIMENSION po integer pf LISTVAR pvg 
            { 
              if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (emp==0)
                miseajour($2,"Vecteur",$1,"/",$5,$5,"/","GLOBAL","SYNTAXIQUE");
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour($2,"Vecteur",$1,"/",$5,$5,"/",empla,"SYNTAXIQUE");
              }
              if(atof($5)<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",$5,"<vide>");
              remplir_quad("ADEC",$2,"<vide>","<vide>");
            }
      | kwCHARACTER idf MULCHAR kwDIMENSION po integer pf LISTVARTABCHAR pvg   
            { 
              sprintf(taille,"%d",atoi($6)*atoi($3));
              if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (emp==0)
                miseajour($2,"Vecteur",$1,"/",taille,$6,"/","GLOBAL","SYNTAXIQUE");  
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour($2,"Vecteur",$1,"/",taille,$6,"/",empla,"SYNTAXIQUE");  
              }
              if(atof($6)<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",$5,"<vide>");
              remplir_quad("ADEC",$2,"<vide>","<vide>");
            }
; */

/* DECMAT: TYPE idf kwDIMENSION po integer vg integer pf LISTVAR pvg 
            { 
              sprintf(taille,"%d",atoi($5)*atoi($7));
              if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (emp==0)
                miseajour($2,"Matrice",$1,"/",taille,$5,$7,"GLOBAL","SYNTAXIQUE");
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour($2,"Matrice",$1,"/",taille,$5,$7,empla,"SYNTAXIQUE"); 
              }
              if(atof($5)<1 || atof($7)<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",$5,"<vide>");
              remplir_quad("BOUNDS","2",$7,"<vide>");
              remplir_quad("ADEC",$2,"<vide>","<vide>");
            }
      | kwCHARACTER idf MULCHAR kwDIMENSION po integer vg integer pf LISTVARMATCHAR pvg 
            { 
              sprintf(taille,"%d",atoi($6)*atoi($8)*atoi($3));
              if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (emp==0)
                miseajour($2,"Matrice",$1,"/",taille,$6,$8,"GLOBAL","SYNTAXIQUE");
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour($2,"Matrice",$1,"/",taille,$6,$8,empla,"SYNTAXIQUE"); 
              }
              if(atof($6)<1 || atof($8)<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",$5,"<vide>");
              remplir_quad("BOUNDS","2",$7,"<vide>");
              remplir_quad("ADEC",$2,"<vide>","<vide>");
            }
; */

/* MULCHAR: mul integer 
            {
              $$=strdup($2);
            }
       |    
            {
              $$=strdup("1");
            }
; */

/* LISTVAR: LISTVARSOLO
       | LISTVARTAB
       | LISTVARMAT
       | 
; */

/* LISTVARSOLO: vg idf LISTVAR 
                  {  
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Variable",savet,"-1","/","/","/","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Variable",savet,"-1","/","/","/",empla,"SYNTAXIQUE");
                    }
                  }
           | vg idf aff EXPRESSION LISTVAR 
                  { 
                    diviserChaine($4,partie1_1,partie1_2);
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Variable",savet,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Variable",savet,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                    }
                    if (strcmp(getType($2,emp,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(getType($2,emp,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(getType($2,emp,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($2,emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",$2);
                  }
; */

/* LISTVARSOLOCHAR: vg idf MULCHAR LISTVARSOLOCHAR 
                  { 
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Variable","CHARACTER","-1",$3,"/","/","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Variable","CHARACTER","-1",$3,"/","/",empla,"SYNTAXIQUE");
                    }
                  } 
               | vg idf MULCHAR aff EXPRESSION LISTVARSOLOCHAR 
                  { 
                    diviserChaine($5,partie1_1,partie1_2);
                    if (emp==0)
                      miseajour($2,"Variable","CHARACTER",partie1_2,$3,"/","/","GLOBAL","SEMANTIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Variable","CHARACTER",partie1_2,$3,"/","/",empla,"SEMANTIQUE");
                    }
                    if (strcmp(getType($2,emp,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(getType($2,emp,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(getType($2,emp,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($2,emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",$2);
                  } 
               |
; */

/* LISTVARTAB: vg idf kwDIMENSION po integer pf LISTVAR 
                  { 
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Vecteur",savet,"/",$5,$5,"-1","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Vecteur",savet,"/",$5,$5,"-1",empla,"SYNTAXIQUE");
                    }
                    if(atof($5)<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",$5,"<vide>");
                    remplir_quad("ADEC",$2,"<vide>","<vide>");
                  }
; */

/* LISTVARTABCHAR: vg idf MULCHAR kwDIMENSION po integer pf LISTVARTABCHAR 
                  { 
                    sprintf(taille,"%d",atoi($6)*atoi($3));
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Vecteur","CHARACTER","/",taille,$6,"-1","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Vecteur","CHARACTER","/",taille,$6,"-1",empla,"SYNTAXIQUE");
                    } 
                    if(atof($6)<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",$5,"<vide>");
                    remplir_quad("ADEC",$2,"<vide>","<vide>");
                  }
              |
; */

/* LISTVARMAT: vg idf kwDIMENSION po integer vg integer pf LISTVAR 
                  { 
                    sprintf(taille,"%d",atoi($5)*atoi($7));
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Matrice",savet,"/",taille,$5,$7,"GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Matrice",savet,"/",taille,$5,$7,empla,"SYNTAXIQUE");
                    } 
                    if(atof($5)<1 || atof($7)<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",$5,"<vide>");
                    remplir_quad("BOUNDS","2",$7,"<vide>");
                    remplir_quad("ADEC",$2,"<vide>","<vide>");
                  }
; */

/* LISTVARMATCHAR: vg idf MULCHAR kwDIMENSION po integer vg integer pf LISTVARMATCHAR 
                  { 
                    sprintf(taille,"%d",atoi($6)*atoi($8)*atoi($3));
                    if (idf_existe($2,emp,"Variable") || idf_existe($2,emp,"Vecteur") || idf_existe($2,emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour($2,"Matrice","CHARACTER","/",taille,$6,$8,"GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour($2,"Matrice","CHARACTER","/",taille,$6,$8,empla,"SYNTAXIQUE");
                    } 
                    if(atof($6)<1 || atof($8)<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",$5,"<vide>");
                    remplir_quad("BOUNDS","2",$7,"<vide>");
                    remplir_quad("ADEC",$2,"<vide>","<vide>");
                  }
              |
; */

/* INST: INSTS INST
    |
; */

/* INSTS: EQU         pvg 
     | ENTREE      pvg 
     | SORTIE      pvg 
     | AFFECTATION pvg 
     | CONTROLE        
     | BOUCLE     
     | CALLPROC    pvg   {param=0;}
;  */

/* AFFECTATION: idf aff EXPRESSION  
                  { 
                    if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    diviserChaine($3,partie1_1,partie1_2);
                    strcpy(typeIDF,getType($1,emp,"Variable"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                          printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($1,emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",$1);
                    miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                  }
           | idf po INDEX pf aff EXPRESSION
                  { 
                    diviserChaine($6,partie1_1,partie1_2);
                    if (!idf_existe($1,emp,"Vecteur") && !idf_existe($1,emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    strcpy(typeIDF,getType($1,emp,"Vecteur"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($1,emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    remplir_quad("=",partie1_2,"<vide>",tab);
                    miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    strcpy(tab," ");
                  }   
           | idf po INDEX vg INDEX pf aff EXPRESSION
                  { 
                    diviserChaine($8,partie1_1,partie1_2);
                    if (!idf_existe($1,emp,"Matrice") && !idf_existe($1,emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    strcpy(typeIDF,getType($1,emp,"Matrice"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($1,emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);strcat(tab,$5);strcat(tab,$6);
                    remplir_quad("=",partie1_2,"<vide>",tab);
                    miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    strcpy(tab," ");
                  }  
; */
 
/* EXPRESSION: EXPRESSION plus EXPRESSION
                  { 
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                      strcpy(cat,"REAL-");
                      strcat(cat,temp);
                      $$=strdup(cat);
                    }
                    else{
                      strcpy(cat,"INTEGER-");
                      strcat(cat,temp);
                      $$=strdup(cat);
                    }
                    remplir_quad("+",partie1_2,partie2_2,temp);
                    tmp++;
                  }  
          | EXPRESSION minus EXPRESSION
                  { 
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                      strcpy(cat,"REAL-");
                      strcat(cat,temp);
                      $$=strdup(cat);
                    }
                    else{
                      strcpy(cat,"INTEGER-");
                      strcat(cat,temp);
                      $$=strdup(cat);
                    }
                    remplir_quad("-",partie1_2,partie2_2,temp);
                    tmp++;
                  }  
          | EXPRESSION mul EXPRESSION
                  { 
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                      strcpy(cat,"REAL-");
                      strcat(cat,temp);
                      $$=strdup(cat);
                    }
                    else{
                      strcpy(cat,"INTEGER-");
                      strcat(cat,temp);
                      $$=strdup(cat);
                    }
                    remplir_quad("*",partie1_2,partie2_2,temp);
                    tmp++;
                  }  
          | EXPRESSION divi EXPRESSION 
                  {  
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie2_2,"0") == 0) { 
                      printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    strcpy(cat,"REAL-");
                    strcat(cat,temp);
                    $$=strdup(cat);
                    remplir_quad("/",partie1_2,partie2_2,temp);
                    tmp++;
                  } 
          | idf  
                  { 
                    if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(ch,$1);
                    if (idf_existe($1,emp,"Variable")) strcpy(cat,getType($1,emp,"Variable"));
                    if (idf_existe($1,emp,"Parametre")) strcpy(cat,getType($1,emp,"Parametre"));
                    strcat(cat,ch);
                    $$=strdup(cat);
                  }      
          | idf po INDEX pf 
                  {
                    if (!idf_existe($1,emp,"Vecteur") && !idf_existe($1,emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    if (!verif_index($1,emp,"Vecteur",$3,"Ligne")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s)'.\n",file_name,nb_line,nb_character,$1,$3);
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    strcat(ch,tab);
                    strcpy(tab," ");
                    if (idf_existe($1,emp,"Vecteur")) strcpy(cat,getType($1,emp,"Vecteur"));
                    if (idf_existe($1,emp,"Parametre")) strcpy(cat,getType($1,emp,"Parametre"));
                    strcat(cat,ch);
                    $$=strdup(cat);
                  }
          | idf po INDEX vg INDEX pf
                  {
                    if (!idf_existe($1,emp,"Matrice") && !idf_existe($1,emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    if (!verif_index($1,emp,"Matrice",$3,"Ligne") || !verif_index($1,emp,"Matrice",$5,"Colonne")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s,%s)'.\n",file_name,nb_line,nb_character,$1,$3,$5);
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);strcat(tab,$5);strcat(tab,$6);
                    strcat(ch,tab);
                    strcpy(tab," ");
                    if (idf_existe($1,emp,"Matrice")) strcpy(cat,getType($1,emp,"Matrice"));
                    if (idf_existe($1,emp,"Parametre")) strcpy(cat,getType($1,emp,"Parametre"));
                    strcat(cat,ch);
                    $$=strdup(cat);
                  }             
          | real    
              {
                strcpy(cat,"REAL-");
                strcat(cat,$1);
                $$=strdup(cat);
              }                
          | integer  
              {
                strcpy(cat,"INTEGER-");
                strcat(cat,$1);
                $$=strdup(cat);
              }                  
          | boolean  
              {
                strcpy(cat,"LOGICAL-");
                strcat(cat,$1);
                $$=strdup(cat);
              }                    
          | character  
              {
                strcpy(cat,"CHARACTER-");
                strcat(cat,$1);
                $$=strdup(cat);
              }                 
          | po EXPRESSION pf  
              {
                $$=strdup($2);
              }        
; */

/* INDEX: idf 
        { 
          if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
            printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
            YYABORT;
          }
          strcpy(typeIDF,getType($1,emp,"Variable"));
          if(strcmp(typeIDF,"INTEGER")!=0){
            printf("\nFile '%s', line %d, character %d: semantic error : Unexpected index type '%s'.\n",file_name,nb_line,nb_character,$1);
            YYABORT;
          }
          else{
            if(atof($1)<1){
              printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
              YYABORT;
            }
          }
        }
     | integer 
        {
          if(atof($1)<1){
              printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
              YYABORT;
          }
          $$=strdup($1);
        }
; */

/* R2_1_CONTROLE: kwIF CONDITION 
              {
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",$2,"<vide>");
              }
;

R1_2_CONTROLE: R2_1_CONTROLE kwTHEN INST 
              {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              }
;

R3_1_CONTROLE: kwIF EXPRESSION 
              {
                diviserChaine($2,partie1_1,partie1_2);
                if (strcmp(partie1_1,"LOGICAL")!=0 && strcmp(partie1_1,"/")!=0){
                  printf("\nFile '%s', line %d, character %d: semantic error : Unexpected expression type.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",partie1_2,"<vide>");
                
              }
;

R4_2_CONTROLE: R3_1_CONTROLE kwTHEN INST 
              {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              }
;

CONTROLE: R1_2_CONTROLE kwELSE INST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R2_1_CONTROLE kwTHEN INST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R3_1_CONTROLE kwTHEN INST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R4_2_CONTROLE kwELSE INST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
; */

/* CONDITION: po EXPRESSION pt OPCOMP pt EXPRESSION pf
              { 
                diviserChaine($2,partie1_1,partie1_2);
                diviserChaine($6,partie2_1,partie2_2);
                sprintf(temp,"T%d",tmp);
                if (strcmp(partie2_1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0) {
                  if(!((strcmp(partie1_1,"REAL")==0 && strcmp(partie2_1,"INTEGER")==0) || (strcmp(partie2_1,"REAL")==0 && strcmp(partie1_1,"INTEGER")==0))){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                $$=strdup(temp);
                remplir_quad($4,partie1_2,partie2_2,temp);
                tmp++;
              }
         | po CONDITION pt OPLOG pt CONDITION pf
              {
                sprintf(temp,"T%d",tmp);
                $$=strdup(temp);
                remplir_quad($4,$2,$6,temp);
                tmp++;
              }
         | po CONDITION pf
              {
                $$=strdup($2);
              }
;                */

/* OPLOG: kwAND {$$=strdup($1);}
     | kwOR  {$$=strdup($1);}
; */

/* OPCOMP: kwGT {$$=strdup($1);}
      | kwGE {$$=strdup($1);} 
      | kwEQ {$$=strdup($1);}
      | kwLE {$$=strdup($1);}
      | kwLT {$$=strdup($1);}
      | kwNE {$$=strdup($1);}
; */

/* R1_1_BOUCLE: kwDOWHILE CONDITION 
                {
                  fin_dowhile=qc;
                  deb_dowhile=qc;
                  remplir_quad("BNZ"," ",$2,"<vide>");
                }
;

R2_1_BOUCLE: kwDOWHILE EXPRESSION
                {
                  diviserChaine($2,partie1_1,partie1_2);
                  fin_dowhile=qc;
                  remplir_quad("BNZ"," ",partie1_1,"<vide>");
                }
;

BOUCLE: R1_1_BOUCLE INST kwENDDO 
                {
                  sprintf(i,"%d",deb_dowhile);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_dowhile,2,i);
                }
      | R2_1_BOUCLE INST kwENDDO 
                {
                  sprintf(i,"%d",deb_dowhile);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_dowhile,2,i);
                }
; */

/* MEMBREIDF : idf                      
                { 
                  if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  $$=strdup($1);
                }
          | idf po INDEX pf 
                { 
                  if (!idf_existe($1,emp,"Vecteur") && !idf_existe($1,emp,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  $$=strdup($1);
                }
          | idf po INDEX vg INDEX pf 
                { 
                  if (!idf_existe($1,emp,"Matrice") && !idf_existe($1,emp,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  $$=strdup($1);
                }
; */

/* SORTIE: kwWRITE po MESSAGE pf 
          {
            search($3,"Idf","CHARACTER","/","-1","/","/","/",3);
          }
      | kwWRITE po MEMBREIDF pf  
          {
            search($3,"Idf","CHARACTER","/","-1","/","/","/",3);
          }
;  */

/* MESSAGE: character MESSAGEIDF
          {
            strcat(tab,$1);strcat(tab,$2);
            $$=strdup(tab);
            strcpy(tab," ");
          }
       | character
          {
            $$=strdup($1);
          }
       | MEMBREIDF vg MESSAGE
          {
            strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);
            $$=strdup(tab);
            strcpy(tab," ");
          }
; */

/* MESSAGEIDF: vg MEMBREIDF vg MESSAGE
              {
                strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                $$=strdup(tab);
                strcpy(tab," ");
              }
          | vg MEMBREIDF 
              {
                strcat(tab,$1);strcat(tab,$2);
                $$=strdup(tab);
                strcpy(tab," ");
              }
; */

/* CALLPROC: idf aff kwCALL idf po PARAMETRE pf 
            { 
              if (!idf_existe($1,emp,"Variable") && !idf_existe($1,emp,"Parametre")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                YYABORT;
              }
              if (!idf_existe($4,-1,"Fonction")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Undeclared function '%s'.\n",file_name,nb_line,nb_character,$4);
                YYABORT;
              }
              strcpy(typeIDF,getType($1,emp,"Variable"));
              if (strcmp(typeIDF,getType($4,-1,"Fonction"))!=0 && strcmp(typeIDF,"/")!=0) {
                if(strcmp(typeIDF,"REAL")!=0 || strcmp(getType($4,-1,"Fonction"),"INTEGER")!=0 ){
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
              }
              if(!verif_param($4,param)){
                printf("\nFile '%s', line %d, character %d: semantic error : Uncorrect number of arguments of '%s'.\n",file_name,nb_line,nb_character,$4);
                YYABORT;
              }
              if (emp==0)
                  search($4,"Idf","/","/","/","/","/","GLOBAL",3);
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  search($4,"Idf","/","/","/","/","/",empla,3);
              }
            }
; */

/* PARAMETRE: MEMBREIDF PARAMETRES
            {
              param++;
            }
         | 
; */

/* PARAMETRES: vg MEMBREIDF PARAMETRES
            {
              param++;
            }
          |
; */

%%

int yyerror(char *msg) { 
  printf("\nFile '%s', syntax error, line %d, column %d, entity %s. \n",file_name,nb_line,nb_character,yylval.str);
  return 1; 
}

int main(int argc,char *argv[]){
  file_name=argv[1];
  initialisation();
  yyparse();
  afficher();
  affiche_quad();
  return 0;
}

int yywrap(){
  return 0;
}

