%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "ts.h"
#include "quad.h"

int nb_line=1;
int nb_character=0;
char *file_name;

char typeIDF[20];
char current_type[20];

int parameter_counter=0;
char parameters_value[20];
char dimension_value[20];

char string_size[20];
char string_message[20];

int for_scope_parser_counter=0;

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

%type <str>BASE_TYPE EXPRESSION_ITEM STRING_MESSAGE MESSAGE_CONCATENATION VARIABLE_MESSAGE INDEX CONDITION LOGICAL_OPERATOR COMPARISON_OPERATOR IMPORT_PATH NUMERIC_TYPE TYPE OBJECT_TYPE OPTIONAL_MULTIDIMENSION METHOD_SUFFIX ENTITY_ITEM_SUFFIX OBJECT_NAME OBJECT_ACCESS_METHOD OBJECT_ACCESS_SUFFIX OBJECT_ACCESS_SEQUENCE IMPORT_PATH_SUFFIX
;

%token <str>kwBOOLEAN kwBREAK kwCASE kwCHAR kwCATCH kwCLASS kwCONTINUE kwDEFAULT kwDO kwDOUBLE kwELSE EXCEPTION kwFINAL kwFINALLY kwFLOAT kwFOR kwIF kwIMPORT kwINT kwMAIN kwNEW kwPRIVATE kwPUBLIC kwRETURN kwSTATIC kwSWITCH kwPRINT kwPRINTLN kwTHIS kwTRY kwVOID kwWHILE BOOL FLOAT DOUBLE INTEGER STRING IDF opGE opGT opEQ opLE opLT opNE opOR opAND opNOT opADD opMINUS opMUL opDIV opMOD opASSIGN pvg po pf acco accf dimo dimf pt vg dp
;

%start JAVA

%right opASSIGN 
%left opADD opMINUS
%left opMUL opDIV opMOD
%left opGE opGT opEQ opLE opLT opNE
%left opOR
%left opAND 
%left opNOT

%%
JAVA: {set_scope("GLOBAL")} IMPORT_LIST  CLASS_LIST MAIN_CLASS { printf("\n\nCode compiled correctly.\n\n"); YYACCEPT; }
;

// ------------------------------- PACKAGE IMPORT BLOCK -------------------------------------------------------------------------

IMPORT_LIST: IMPORT_LIST IMPORT_ITEM
           | /* empty */
;

IMPORT_ITEM: kwIMPORT IMPORT_PATH pvg
;

IMPORT_PATH: IDF IMPORT_PATH_SUFFIX
            {
              if (strlen($2) == 0) {
                search($1, "Class", "-", "-", "-", "-", "-", current_scope, "SYNTAXIQUE",0);
                $$ = strdup($1);
              } else {
                char buffer[256];
                search($1, "Package", "-", "-", "-", "-", "-", current_scope, "SYNTAXIQUE",0);
                sprintf(buffer, "%s%s", $1, $2);
                $$ = strdup(buffer);
              }
            }
;

IMPORT_PATH_SUFFIX: pt IDF IMPORT_PATH_SUFFIX
                      {
                        char segment[256];
                        
                        if (strlen($3) == 0) {
                          search($2, "Class", "-", "-", "-", "-", "-", current_scope, "SYNTAXIQUE",0);
                        } else {
                          search($2, "Package", "-", "-", "-", "-", "-", current_scope, "SYNTAXIQUE",0);
                        }
                        sprintf(segment, ".%s%s", $2, $3);
                        $$ = strdup(segment);
                      }
                  |   /* empty */
                      { 
                        $$ = strdup(""); 
                      }
;


// ------------------------------ MAIN CLASS BLOCK ---------------------------------------------------------------------------

MAIN_CLASS: kwCLASS kwMAIN acco MAIN_METHOD accf 
          | /* empty */
;

MAIN_METHOD: kwPUBLIC kwSTATIC kwVOID kwMAIN po METHOD_PARAMETER_LIST pf 
                    {  
                      enter_scope("main");
                    }
             acco INSTRUCTION_LIST accf 
                    {
                      exit_scope();
                    }
;

// ------------------------------ CLASS BLOCK ----------------------------------------------------------------------------------

CLASS_LIST: CLASS_LIST CLASS 
          | /* empty */
;

CLASS: kwCLASS IDF 
              {     
                search($2, "Class", "-", "-", "-", "-", "-", current_scope, "SYNTAXIQUE",0);
                enter_scope($2);
              }
        acco ENTITY_LIST accf 
              {
                exit_scope();
              }
;

// ---------------------------- ENTITY BLOCK (ATTRIBUTES AND METHODS) ---------------------------------------------------------

ENTITY_LIST: ENTITY_LIST_NONEMPTY
           | /* empty */
;

ENTITY_LIST_NONEMPTY: ENTITY_ITEM
                    | ENTITY_LIST_NONEMPTY ENTITY_ITEM
;

ENTITY_ITEM: TYPE IDF {enter_scope($2);} ENTITY_ITEM_SUFFIX 
                {
                  if (strcmp($4,"Method")==0) { 
                    sprintf(parameters_value,"%d",parameter_counter); 
                    strcpy(dimension_value,"-");
                  }
                  else {
                    exit_scope();
                    strcpy(parameters_value,"-");
                    strcpy(dimension_value,getArrayDimension($1));
                  }
                  search($2, $4, $1, "-1", getArraySize($1), dimension_value,parameters_value ,current_scope, "SYNTAXIQUE",0); 
                }
           | CONSTRUCTOR
;

ENTITY_ITEM_SUFFIX: METHOD_SUFFIX {$$=strdup("Method");}
                  | VARIABLE_SUFFIX pvg {$$ = strdup("Attribute");}
;

// -------------------------- CONSTRUCTOR BLOCK ---------------------------------------------------------------------------------

CONSTRUCTOR: IDF CONSTRUCTOR_SUFFIX 
                {
                  enter_scope($1);
                  sprintf(parameters_value,"%d",parameter_counter); 
                  search($1, "Constructor", "-", "-", "-", "-",parameters_value, current_scope, "SYNTAXIQUE",0);
                }
;

CONSTRUCTOR_SUFFIX: po {parameter_counter = 0;}  CONSTRUCTOR_PARAMETER_LIST pf acco INSTRUCTION_LIST accf {exit_scope();} 
;

CONSTRUCTOR_PARAMETER_LIST: TYPE IDF {parameter_counter++;} CONSTRUCTOR_PARAMETER_ITEM
                          | /* empty */

CONSTRUCTOR_PARAMETER_ITEM: vg TYPE IDF {parameter_counter++;} CONSTRUCTOR_PARAMETER_ITEM
                     | /* empty */
;                        

// -------------------------- METHOD BLOCK ---------------------------------------------------------------------------------

METHOD_SUFFIX: po {parameter_counter = 0;} METHOD_PARAMETER_LIST pf acco INSTRUCTION_LIST accf {exit_scope();}
;

METHOD_PARAMETER_LIST: TYPE IDF {parameter_counter++;} METHOD_PARAMETER_ITEM
                        {
                            search($2, "Parameter", $1, "-1", getArraySize($1),getArrayDimension($1), "-1", current_scope, "SYNTAXIQUE",0);
                        }
                     | /* empty */
;

METHOD_PARAMETER_ITEM: vg TYPE IDF {parameter_counter++;} METHOD_PARAMETER_ITEM
                     | /* empty */
;

// ----------------------------- TYPE BLOCK -----------------------------------------------------------------------------------

TYPE: BASE_TYPE OPTIONAL_MULTIDIMENSION 
        {
          strcat(tab,$1);strcat(tab,$2);
          $$=strdup(tab);
          strcpy(tab,"");
        }
    | OBJECT_TYPE {$$=strdup($1);}
;

BASE_TYPE: NUMERIC_TYPE {$$=strdup($1);}
         | kwBOOLEAN {$$=strdup($1);strcpy(current_type,$1);}
         | kwCHAR    {$$=strdup($1);strcpy(current_type,$1);}
         | kwVOID    {$$=strdup($1);strcpy(current_type,$1);}
;

NUMERIC_TYPE: kwINT     {$$=strdup($1);strcpy(current_type,$1);}
            | kwFLOAT   {$$=strdup($1);strcpy(current_type,$1);}
            | kwDOUBLE  {$$=strdup($1);strcpy(current_type,$1);}
;

OBJECT_TYPE: IDF 
              {
                $$=strdup($1);
              }
;

// ------------------------------ OBJECT BLOCK --------------------------------------------------------------------------------------

OBJECT_CREATION: kwNEW IDF po ARGUMENT_LIST pf
;

OBJECT_ACCESS: OBJECT_ACCESS_SEQUENCE 
                  {

                  }
             | kwTHIS pt OBJECT_ACCESS_SEQUENCE 
                  {

                  }
;           

OBJECT_ACCESS_SEQUENCE: OBJECT_ACCESS_SUFFIX {$$=strdup($1);}
                      | OBJECT_ACCESS_SEQUENCE pt OBJECT_ACCESS_SUFFIX 
                          {
                            strcat(tab,$1);
                            strcat(tab,$2);
                            strcat(tab,$3);
                            $$=strdup(tab);
                            strcpy(tab,"");
                          }
;

OBJECT_ACCESS_SUFFIX: OBJECT_NAME {$$=strdup($1);}
                    | OBJECT_ACCESS_METHOD {$$=strdup($1);}
;  

OBJECT_NAME: IDF {$$=strdup($1);}
;

OBJECT_ACCESS_METHOD: IDF po ARGUMENT_LIST pf
                  { 
                    // if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // if (!idf_existe($4,-1,"Fonction")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared function '%s'.\n",file_name,nb_line,nb_character,$4);
                    //   YYABORT;
                    // }
                    // strcpy(typeIDF,getType($1,current_class_level,"Variable"));
                    // if (strcmp(typeIDF,getType($4,-1,"Fonction"))!=0 && strcmp(typeIDF,"-")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(getType($4,-1,"Fonction"),"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(!verif_param($4,parameter_counter)){
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Uncorrect number of arguments of '%s'.\n",file_name,nb_line,nb_character,$4);
                    //   YYABORT;
                    // }
                    // if (current_class_level==0)
                    //     search($4,"Idf","-","-","-","-","-","GLOBAL",3);
                    //   else {
                    //     sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                    //     search($4,"Idf","-","-","-","-","-",class_emplacement,3);
                    // }
                    $$=strdup($1);
                  }
;

// ------------------------------ ARGUMENT BLOCK ------------------------------------------------------------------------------------

ARGUMENT_LIST: ARGUMENT_ITEM 
             | 
;

ARGUMENT_ITEM:
      EXPRESSION_ITEM
      { 
        // parameter_counter++;
      }
    | ARGUMENT_ITEM vg EXPRESSION_ITEM
      { 
         // parameter_counter++
      }
;

// ------------------------------ OPTIONAL BLOCK ------------------------------------------------------------------------------

OPTIONAL_MULTIDIMENSION: dimo INDEX dimf OPTIONAL_MULTIDIMENSION
                         {
                           // if (atof($2)<1){
                           //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                           //   YYABORT;
                           // }
                            strcat(tab,$1);
                            strcat(tab,$2);
                            strcat(tab,$3);
                            strcat(tab,$4);
                            $$=strdup(tab);
                            strcpy(tab,"");
                         }
                       | dimo dimf OPTIONAL_MULTIDIMENSION
                          {
                            strcat(tab,$1);
                            strcat(tab,$2);
                            strcat(tab,$3);
                            $$=strdup(tab);
                            strcpy(tab,"");
                          }
                       | 
                          {
                            $$=strdup(tab);
                            strcpy(tab,"");
                          }
;

OPTIONAL_ASSIGN: opASSIGN EXPRESSION
               | 
;

INDEX: EXPRESSION_ITEM 
        { 
          // if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
          //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
          //   YYABORT;
          // }
          // strcpy(typeIDF,getType($1,current_class_level,"Variable"));
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

          // if(atof($1)<1){
          //     printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
          //     YYABORT;
          // }
          $$=strdup($1);
        }
;

// ------------------------------ ATTRIBUTE BLOCK ---------------------------------------------------------------------------

VARIABLE_SUFFIX: OPTIONAL_ASSIGN VARIABLE_LIST 
              { 
                // solo

                // sans affectation

                // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (current_class_level==0)
                //   search($2,"Variable",$1,"-1","-","-","-","GLOBAL","SYNTAXIQUE",0);
                // else {
                //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                //   search($2,"Variable",$1,"-1","-","-","-",class_emplacement,"SYNTAXIQUE",0);
                // }

                // avec affectation

                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (current_class_level==0)
                //   miseajour($2,"Variable",$1,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                //   miseajour($2,"Variable",$1,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);

                // array

                // sans affectation

              // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
              //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
              //   YYABORT;
              // }
              // if (current_class_level==0)
              //   search($2,"Vecteur",$1,"-",$4,$4,"-","GLOBAL","SYNTAXIQUE",0);
              // else {
              //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
              //   search($2,"Vecteur",$1,"-",$4,$4,"-",class_emplacement,"SYNTAXIQUE",0);
              // }
              // if(atof($5)<1){
              //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
              //   YYABORT;
              // }
              // remplir_quad("BOUNDS","1",$5,"<vide>");
              // remplir_quad("ADEC",$2,"<vide>","<vide>");

              // avec affectation 
                
                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (current_class_level==0)
                //   miseajour($2,"Variable",$1,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                //   miseajour($2,"Variable",$1,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);

                // matrix

                 // sans affectation

              // sprintf(taille,"%d",atoi($4)*atoi($6));
              // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
              //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
              //   YYABORT;
              // }
              // if (current_class_level==0)
              //   search($2,"Matrice",$1,"-",taille,$4,$6,"GLOBAL","SYNTAXIQUE",0);
              // else {
              //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
              //   search($2,"Matrice",$1,"-",taille,$4,$6,class_emplacement,"SYNTAXIQUE",0); 
              // }
              // if(atof($4)<1 || atof($6)<1){
              //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
              //   YYABORT;
              // }
              // remplir_quad("BOUNDS","1",$4,"<vide>");
              // remplir_quad("BOUNDS","2",$6,"<vide>");
              // remplir_quad("ADEC",$2,"<vide>","<vide>");

              // avec affectation

                // diviserChaine($4,partie1_1,partie1_2);
                // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                //   YYABORT;
                // }
                // if (current_class_level==0)
                //   miseajour($2,"Variable",$1,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                // else {
                //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                //   miseajour($2,"Variable",$1,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                // }
                // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // remplir_quad("=",partie1_2,"<vide>",$2);
              }
; 

VARIABLE_LIST: vg IDF OPTIONAL_ASSIGN VARIABLE_LIST 
                  {  
                    // solo

                    // sans affectation 

                    // if (idf_existe($2,current_class_level,"Variable")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (current_class_level==0)
                    //   search($2,"Variable",current_type,"-1","-","-","-","GLOBAL","SYNTAXIQUE",0);
                    // else {
                    //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                    //   search($2,"Variable",current_type,"-1","-","-","-",class_emplacement,"SYNTAXIQUE",0);
                    // }

                    // avec affectation

                    // diviserChaine($4,partie1_1,partie1_2);
                    // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (current_class_level==0)
                    //   miseajour($2,"Variable",current_type,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                    // else {
                    //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                    //   miseajour($2,"Variable",current_type,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                    // }
                    // if (strcmp(getType($2,current_class_level,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                    //   if(strcmp(getType($2,current_class_level,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(getType($2,current_class_level,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // remplir_quad("=",partie1_2,"<vide>",$2);

                    // array

                    // sans affectation

                    // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (current_class_level==0)
                    //   search($2,"Vecteur",current_type,"-",$5,$5,"-1","GLOBAL","SYNTAXIQUE",0);
                    // else {
                    //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                    //   search($2,"Vecteur",current_type,"-",$5,$5,"-1",class_emplacement,"SYNTAXIQUE",0);
                    // }
                    // if(atof($5)<1){
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");

                    //avec affectation

                     // diviserChaine($4,partie1_1,partie1_2);
                    // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (current_class_level==0)
                    //   miseajour($2,"Variable",current_type,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                    // else {
                    //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                    //   miseajour($2,"Variable",current_type,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                    // }
                    // if (strcmp(getType($2,current_class_level,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                    //   if(strcmp(getType($2,current_class_level,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(getType($2,current_class_level,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // remplir_quad("=",partie1_2,"<vide>",$2);

                    // matrix

                    // sans affectation 


                    // sprintf(taille,"%d",atoi($5)*atoi($7));
                    // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                    //   YYABORT;
                    // }
                    // if (current_class_level==0)
                    //   search($2,"Matrice",current_type,"-",taille,$5,$7,"GLOBAL","SYNTAXIQUE",0);
                    // else {
                    //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                    //   search($2,"Matrice",current_type,"-",taille,$5,$7,class_emplacement,"SYNTAXIQUE",0);
                    // } 
                    // if(atof($5)<1 || atof($7)<1){
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("BOUNDS","2",$7,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");

                    //avec affectation
                      // diviserChaine($4,partie1_1,partie1_2);
                      // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      //   YYABORT;
                      // }
                      // if (current_class_level==0)
                      //   miseajour($2,"Variable",$1,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                      // else {
                      //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      //   miseajour($2,"Variable",$1,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                      // }
                      // if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                      //   if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                      //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      //     YYABORT;
                      //   }
                      // }
                      // remplir_quad("=",partie1_2,"<vide>",$2);
                  }
            |
;

// ------------------------------ INSTRUCTION BLOCK ---------------------------------------------------------------------------

INSTRUCTION_LIST: INSTRUCTION_ITEM INSTRUCTION_LIST
                | INSTRUCTION_ITEM
;

INSTRUCTION_ITEM: OUTPUT    pvg 
                | DECLARATION pvg
                | ASSIGN    pvg 
                | INCREMENT pvg
                | IF_ELSE_BLOCK        
                | LOOP_BLOCK     
                | SWITCH_CASE_BLOCK 
                | TRY_CATCH_BLOCK
                | OBJECT_ACCESS pvg  
                | RETURN    pvg
; 

// ------------------------------ DECLARATION BLOCK -------------------------------------------------------------------------------

DECLARATION: TYPE IDF VARIABLE_SUFFIX 
                {
                  search($2, "Variable", $1, "-1", getArraySize($1),getArrayDimension($1), "-", current_scope, "SYNTAXIQUE",0);
                }
;

// ------------------------------ PRINT BLOCK -------------------------------------------------------------------------------------

OUTPUT: PRINT po STRING_MESSAGE pf 
      | PRINT po VARIABLE_MESSAGE pf  
;

PRINT: kwPRINTLN
     | kwPRINT

STRING_MESSAGE: STRING MESSAGE_CONCATENATION
                  {
                    sprintf(string_size,"%d",strlen($1)-2);
	                  sprintf(string_message,"char[%d]",strlen($1)-2);
	                  search($1,"Output Message",string_message,"-",string_size,"1","-","-","SYNTAXIQUE",0);
                  }
              | STRING
                  {
                    sprintf(string_size,"%d",strlen($1)-2);
	                  sprintf(string_message,"char[%d]",strlen($1)-2);
	                  search($1,"Output Message",string_message,"-",string_size,"1","-","-","SYNTAXIQUE",0);
                  }
              | VARIABLE_MESSAGE opADD STRING_MESSAGE
                  {}
              | {}
;

MESSAGE_CONCATENATION: opADD VARIABLE_MESSAGE opADD STRING_MESSAGE
                     | opADD VARIABLE_MESSAGE 
;

VARIABLE_MESSAGE : OBJECT_ACCESS                      
                { 
                  // if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                  //   YYABORT;
                  // }
                  // $$=strdup($1);
                }
          | OBJECT_ACCESS dimo INDEX dimf 
                { 
                  // if (!idf_existe($1,current_class_level,"Vecteur") && !idf_existe($1,current_class_level,"Parametre")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                  //   YYABORT;
                  // }
                  // $$=strdup($1);
                }
          | OBJECT_ACCESS dimo INDEX vg INDEX dimf 
                { 
                  // if (!idf_existe($1,current_class_level,"Matrice") && !idf_existe($1,current_class_level,"Parametre")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                  //   YYABORT;
                  // }
                  // $$=strdup($1);
                }
;

// ------------------------------ ASSIGN BLOCK -------------------------------------------------------------------------------------

ASSIGN: OBJECT_ACCESS opASSIGN EXPRESSION_ITEM  
                  { 
                    // if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // diviserChaine($3,partie1_1,partie1_2);
                    // strcpy(typeIDF,getType($1,current_class_level,"Variable"));
                    // if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //       printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($1,current_class_level,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // remplir_quad("=",partie1_2,"<vide>",$1);
                    // miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                  }
        | OBJECT_ACCESS dimo INDEX dimf opASSIGN EXPRESSION
                  { 
                    // diviserChaine($6,partie1_1,partie1_2);
                    // if (!idf_existe($1,current_class_level,"Vecteur") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // strcpy(typeIDF,getType($1,current_class_level,"Vecteur"));
                    // if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($1,current_class_level,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    // remplir_quad("=",partie1_2,"<vide>",tab);
                    // miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    // strcpy(tab," ");
                  }   
           | OBJECT_ACCESS dimo INDEX vg INDEX dimf opASSIGN EXPRESSION
                  { 
                    // diviserChaine($8,partie1_1,partie1_2);
                    // if (!idf_existe($1,current_class_level,"Matrice") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // strcpy(typeIDF,getType($1,current_class_level,"Matrice"));
                    // if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                    //   if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }
                    // if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($1,current_class_level,"Variable",partie1_2)) {
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

// ------------------------------ EXPRESSION BLOCK -----------------------------------------------------------------------------------

EXPRESSION: EXPRESSION_ITEM
          | ARRAY_INSTANCE
          | OBJECT_CREATION
;

// ------------------------------ ARRAY BLOCK ---------------------------------------------------------------------------------------

ARRAY_INSTANCE: acco SUBARRAY_LIST accf
;

SUBARRAY_LIST: SUBARRAY_ITEM
             | SUBARRAY_LIST vg SUBARRAY_ITEM
;

SUBARRAY_ITEM: EXPRESSION_ITEM
             | ARRAY_INSTANCE
;

// ------------------------------ EXPRESSION ITEM BLOCK ----------------------------------------------------------------------------

EXPRESSION_ITEM: EXPRESSION_ITEM opADD EXPRESSION_ITEM
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM opMINUS EXPRESSION_ITEM
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM opMUL EXPRESSION_ITEM
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM opMOD EXPRESSION_ITEM
                  { 
                    // diviserChaine($1,partie1_1,partie1_2);
                    // diviserChaine($3,partie2_1,partie2_2);
                    // sprintf(temp,"T%d",tmp);
                    // if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    //   YYABORT;
                    // }
                    // if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM opDIV EXPRESSION_ITEM 
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
                    // remplir_quad("-",partie1_2,partie2_2,temp);
                    // tmp++;
                  } 
          | OBJECT_ACCESS  
                  { 
                    // if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // strcpy(ch,"-");
                    // strcat(ch,$1);
                    // if (idf_existe($1,current_class_level,"Variable")) strcpy(cat,getType($1,current_class_level,"Variable"));
                    // if (idf_existe($1,current_class_level,"Parametre")) strcpy(cat,getType($1,current_class_level,"Parametre"));
                    // strcat(cat,ch);
                    // $$=strdup(cat);
                  }      
          | OBJECT_ACCESS dimo INDEX dimf 
                  {
                    // if (!idf_existe($1,current_class_level,"Vecteur") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // if (!verif_index($1,current_class_level,"Vecteur",$3,"Ligne")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s)'.\n",file_name,nb_line,nb_character,$1,$3);
                    //   YYABORT;
                    // }
                    // strcpy(ch,"-");
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    // strcat(ch,tab);
                    // strcpy(tab," ");
                    // if (idf_existe($1,current_class_level,"Vecteur")) strcpy(cat,getType($1,current_class_level,"Vecteur"));
                    // if (idf_existe($1,current_class_level,"Parametre")) strcpy(cat,getType($1,current_class_level,"Parametre"));
                    // strcat(cat,ch);
                    // $$=strdup(cat);
                  }
          | OBJECT_ACCESS dimo INDEX vg INDEX dimf
                  {
                    // if (!idf_existe($1,current_class_level,"Matrice") && !idf_existe($1,current_class_level,"Parametre")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    //   YYABORT;
                    // }
                    // if (!verif_index($1,current_class_level,"Matrice",$3,"Ligne") || !verif_index($1,current_class_level,"Matrice",$5,"Colonne")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s,%s)'.\n",file_name,nb_line,nb_character,$1,$3,$5);
                    //   YYABORT;
                    // }
                    // strcpy(ch,"-");
                    // strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);strcat(tab,$5);strcat(tab,$6);
                    // strcat(ch,tab);
                    // strcpy(tab," ");
                    // if (idf_existe($1,current_class_level,"Matrice")) strcpy(cat,getType($1,current_class_level,"Matrice"));
                    // if (idf_existe($1,current_class_level,"Parametre")) strcpy(cat,getType($1,current_class_level,"Parametre"));
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
          | po EXPRESSION_ITEM pf  
              {
                // $$=strdup($2);
              }
;

// --------------------------------- INCREMENT AND DECREMENT BLOCK ---------------------------------------------------------------------------

INCREMENT: POSTFIX_INCREMENT
         /* | PREFIX_INCREMENT */
         | INCREMENT_ASSIGN
;

POSTFIX_INCREMENT: OBJECT_ACCESS opADD opADD
                 | OBJECT_ACCESS opMINUS opMINUS
;

/* PREFIX_INCREMENT: opADD opADD OBJECT_ACCESS
                | opMINUS opMINUS OBJECT_ACCESS
; */

INCREMENT_ASSIGN : OBJECT_ACCESS opADD opASSIGN EXPRESSION_ITEM
                 | OBJECT_ACCESS opMINUS opASSIGN EXPRESSION_ITEM
                 | OBJECT_ACCESS opMUL opASSIGN EXPRESSION_ITEM
;

// --------------------------------- CONDITION BLOCK ---------------------------------------------------------------------------

CONDITION: po EXPRESSION_ITEM COMPARISON_OPERATOR EXPRESSION_ITEM pf
              { 
                // diviserChaine($2,partie1_1,partie1_2);
                // diviserChaine($6,partie2_1,partie2_2);
                // sprintf(temp,"T%d",tmp);
                // if (strcmp(partie2_1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0) {
                //   if(!((strcmp(partie1_1,"REAL")==0 && strcmp(partie2_1,"INTEGER")==0) || (strcmp(partie2_1,"REAL")==0 && strcmp(partie1_1,"INTEGER")==0))){
                //     printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                //     YYABORT;
                //   }
                // }
                // $$=strdup(temp);
                // remplir_quad($4,partie1_2,partie2_2,temp);
                // tmp++;
              }
         | po CONDITION LOGICAL_OPERATOR CONDITION pf
              {
                // sprintf(temp,"T%d",tmp);
                // $$=strdup(temp);
                // remplir_quad($4,$2,$6,temp);
                // tmp++;
              }
         | po CONDITION pf
              {
                $$=strdup($2);
              }
         | opNOT CONDITION 
              {
                // sprintf(temp,"T%d",tmp);
                // $$=strdup(temp);
                // remplir_quad("NOT",$2,"<vide>",temp);
                // tmp++;
              }
;               

LOGICAL_OPERATOR: opAND {$$=strdup($1);}
                | opOR  {$$=strdup($1);}
;

COMPARISON_OPERATOR: opGT {$$=strdup($1);}
                   | opGE {$$=strdup($1);} 
                   | opEQ {$$=strdup($1);}
                   | opLE {$$=strdup($1);}
                   | opLT {$$=strdup($1);}
                   | opNE {$$=strdup($1);}
;

// --------------------------------- IF/ELSE BLOCK ---------------------------------------------------------------------------

R2_1_CONTROLE: kwIF CONDITION 
              {
                // deb_else=qc;
                // fin_if=qc;
                // remplir_quad("BNZ"," ",$2,"<vide>");
              }
;

R1_2_CONTROLE: R2_1_CONTROLE acco INSTRUCTION_LIST accf
              {
                // fin_if=qc;
                // remplir_quad("BR"," ","<vide>","<vide>");
                // sprintf(i,"%d",qc); 
                // mise_jr_quad(deb_else,2,i);
              }
;

R3_1_CONTROLE: kwIF EXPRESSION_ITEM 
              {
                // diviserChaine($2,partie1_1,partie1_2);
                // if (strcmp(partie1_1,"LOGICAL")!=0 && strcmp(partie1_1,"-")!=0){
                //   printf("\nFile '%s', line %d, character %d: semantic error : Unexpected expression type.\n",file_name,nb_line,nb_character);
                //   YYABORT;
                // }
                // deb_else=qc;
                // fin_if=qc;
                // remplir_quad("BNZ"," ",partie1_2,"<vide>");
                
              }
;

R4_2_CONTROLE: R3_1_CONTROLE acco INSTRUCTION_LIST accf
              {
                // fin_if=qc;
                // remplir_quad("BR"," ","<vide>","<vide>");
                // sprintf(i,"%d",qc); 
                // mise_jr_quad(deb_else,2,i);
              }
;

IF_ELSE_BLOCK: R1_2_CONTROLE kwELSE acco INSTRUCTION_LIST accf 
                  {
                    // sprintf(i,"%d",qc);
                    // mise_jr_quad(fin_if,2,i);
                  }
            | R2_1_CONTROLE acco INSTRUCTION_LIST accf 
                  {
                    // sprintf(i,"%d",qc);
                    // mise_jr_quad(fin_if,2,i);
                  }
            | R3_1_CONTROLE acco INSTRUCTION_LIST accf 
                  {
                    // sprintf(i,"%d",qc);
                    // mise_jr_quad(fin_if,2,i);
                  }
            | R4_2_CONTROLE kwELSE acco INSTRUCTION_LIST accf 
                  {
                    // sprintf(i,"%d",qc);
                    // mise_jr_quad(fin_if,2,i);
                  }
;

// --------------------------------- LOOP BLOCK -----------------------------------------------------------------------------------

LOOP_BLOCK: FOR_LOOP
          | WHILE_LOOP
          | DOWHILE_LOOP
;

// --------------------------------- FOR LOOP BLOCK -----------------------------------------------------------------------------------

FOR_LOOP: kwFOR 
            {
              char new_scope[256];
              for_scope_parser_counter++;
              sprintf(new_scope,"for_loop_%d",for_scope_parser_counter);
              enter_scope(new_scope);
            }
          FOR_LOOP_SIGNATURE acco INSTRUCTION_LIST accf
            {
              // remplir_quad("BR"," ","<vide>","<vide>");
              // sprintf(i,"%d",qc); 
              // mise_jr_quad($2,2,i);
              exit_scope();
              for_scope_parser_counter=0;
            }
;

COUNTER_INIT: NUMERIC_TYPE IDF OPTIONAL_ASSIGN
                  {
                      search($2,"Variable",$1, "-1", "-", "0", "-",current_scope, "SYNTAXIQUE",0);
                  }
            | OBJECT_ACCESS OPTIONAL_ASSIGN
            |

FOR_LOOP_SIGNATURE: po NUMERIC_TYPE IDF dp OBJECT_ACCESS pf 
                        {
                          search($3,"Variable",$2, "-1", "-", "0", "-",current_scope, "SYNTAXIQUE",0);
                        }
                  | po OBJECT_ACCESS dp OBJECT_ACCESS pf
                  | po COUNTER_INIT pvg CONDITION pvg INCREMENT pf
;

// --------------------------------- WHILE LOOP BLOCK -----------------------------------------------------------------------------------
R1_1_WHILE: kwWHILE CONDITION 
                {
                  // fin_dowhile=qc;
                  // deb_dowhile=qc;
                  // remplir_quad("BNZ"," ",$2,"<vide>");
                }
;

R2_1_WHILE: kwWHILE EXPRESSION_ITEM
                {
                  // diviserChaine($2,partie1_1,partie1_2);
                  // fin_dowhile=qc;
                  // remplir_quad("BNZ"," ",partie1_1,"<vide>");
                }
;

WHILE_LOOP: R1_1_WHILE acco INSTRUCTION_LIST accf 
                {
                  // sprintf(i,"%d",deb_dowhile);
                  // remplir_quad("BR",i,"<vide>","<vide>");
                  // sprintf(i,"%d",qc);
                  // mise_jr_quad(fin_dowhile,2,i);
                }
          | R2_1_WHILE acco INSTRUCTION_LIST accf
                {
                  // sprintf(i,"%d",deb_dowhile);
                  // remplir_quad("BR",i,"<vide>","<vide>");
                  // sprintf(i,"%d",qc);
                  // mise_jr_quad(fin_dowhile,2,i);
                }
;
// --------------------------------- DO WHILE LOOP BLOCK -----------------------------------------------------------------------------------

DOWHILE_LOOP: kwDO acco INSTRUCTION_LIST accf R1_1_WHILE 
            | kwDO acco INSTRUCTION_LIST accf R2_1_WHILE
; 

// --------------------------------- SWITCH CASE BLOCK -----------------------------------------------------------------------------------

SWITCH_CASE_BLOCK: kwSWITCH po IDF pf acco CASE_LIST OPTIONAL_DEFAULT accf
;

CASE_LIST: kwCASE EXPRESSION_ITEM dp INSTRUCTION_LIST kwBREAK pvg CASE_LIST
         | kwCASE EXPRESSION_ITEM dp INSTRUCTION_LIST kwBREAK pvg
;

OPTIONAL_DEFAULT: kwDEFAULT dp INSTRUCTION_LIST
                |
;

// --------------------------------- TRY CATCH BLOCK -----------------------------------------------------------------------------------

TRY_CATCH_BLOCK: kwTRY acco INSTRUCTION_LIST accf CATCH_LIST OPTIONAL_FINALLY
;

CATCH_LIST: kwCATCH po CATCH_PARAMETER pf acco INSTRUCTION_LIST accf CATCH_LIST
          |
;

CATCH_PARAMETER: IDF 
                  {
                    search($1, "Catch Parameter", "-", "-", "-","-", "-", current_scope, "SYNTAXIQUE",0);
                  }
               | EXCEPTION IDF
                  { 
                    search($2, "Catch Parameter", $1, "-", "-","-", "-", current_scope, "SYNTAXIQUE",0);
                  }
               |
;

OPTIONAL_FINALLY: kwFINALLY acco INSTRUCTION_LIST accf
                |
;

// --------------------------------- RETURN BLOCK -----------------------------------------------------------------------------------

RETURN: kwRETURN EXPRESSION_ITEM 
;

/* COMPIL: PROC MAIN {printf("\n\nCode correct!\n\n"); YYACCEPT;}
; */

/* PROC: SIGNATURE ROUTINE PROC
    | {current_class_level=0;}
; */

/* SIGNATURE: TYPEPROC kwROUTINE idf po PARAM pf 
          { 
            if (idf_existe($3,-1,"Fonction")) {
              printf("\nFile '%s', line %d, character %d: semantic error : Double function declaration '%s'.\n",file_name,nb_line,nb_character,$3);
              YYABORT;
            }
            sprintf(parameters_value,"%d",parameter_counter); 
            miseajour($3,"Fonction",$1,"-1",parameters_value,"-","-","-1","SYNTAXIQUE");
            parameter_counter=0;
          }
; */

/* TYPEPROC: kwINTEGER   {$$=strdup($1);}
        | kwREAL      {$$=strdup($1);}
        | kwLOGICAL   {$$=strdup($1);}
        | kwCHARACTER {$$=strdup($1);}
; */

/* PARAM: idf PARA
          { 
            sprintf(class_emplacement,"LOCAL %d",current_class_level);
            miseajour($1,"Parametre","-","-","-","-","-",class_emplacement,"SYNTAXIQUE");
            parameter_counter++;
          }
     | 
; */

/* PARA: vg idf PARA
          { 
            sprintf(class_emplacement,"LOCAL %d",current_class_level);
            miseajour($2,"Parametre","-","-","-","-","-",class_emplacement,"SYNTAXIQUE");
            parameter_counter++;
          }
    |
; */

/* ROUTINE: DEC INSTPROC kwENDR {current_class_level++;}
; */

/* INSTPROC: EQU         INSTSPROC        
        | ENTREE      INSTSPROC      
        | SORTIE      INSTSPROC 
        | AFFECTATION INSTSPROC   
        | CALLPROC    INSTSPROC     {parameter_counter=0;}
        | IF_ELSE_BLOCK    INSTSPROCBLOC
        | BOUCLE      INSTSPROCBLOC
        | RETOUR
; */

/* INSTSPROC: pvg EQU          INSTSPROC 
         | pvg ENTREE       INSTSPROC
         | pvg SORTIE       INSTSPROC
         | pvg AFFECTATION  INSTSPROC
         | pvg IF_ELSE_BLOCK     INSTSPROCBLOC
         | pvg BOUCLE       INSTSPROCBLOC
         | pvg CALLPROC     INSTSPROC     {parameter_counter=0;}
         | pvg RETOUR
;  */

/* INSTSPROCBLOC: EQU          INSTSPROC 
             | ENTREE       INSTSPROC
             | SORTIE       INSTSPROC
             | AFFECTATION  INSTSPROC
             | IF_ELSE_BLOCK     INSTSPROCBLOC
             | BOUCLE       INSTSPROCBLOC
             | CALLPROC     INSTSPROC     {parameter_counter=0;}
             | RETOUR
; */

/* RETOUR: idf aff EXPRESSION_ITEM  
            { 
              diviserChaine($3,partie1_1,partie1_2);
              if (!idf_existe($1,current_class_level,"Fonction")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Wrong function return '%s'.\n",file_name,nb_line,nb_character,$1);
                YYABORT;
              }
              strcpy(typeIDF,getType($1,current_class_level,"Fonction"));
              if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
              }
              remplir_quad("=",partie1_2,"<vide>",$1);
              miseajour($1,"Fonction","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
            }
; */

/* MAIN: kwPROGRAM idf DEC INSTRUCTION_LIST kwEND pt { miseajour($2,"Programme Principal","-","-","-","-","-","GLOBAL","SYNTAXIQUE");}
; */

/* DEC: DECSOLO DEC 
   | DECTAB  DEC
   | DECMAT  DEC
   |
; */

/* TYPE: kwINTEGER  {$$=strdup($1);strcpy(current_type,$1);}
    | kwREAL     {$$=strdup($1);strcpy(current_type,$1);}
    | kwLOGICAL  {$$=strdup($1);strcpy(current_type,$1);}
; */

/* DECSOLO: TYPE idf LISTVAR pvg 
              { 
                if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (current_class_level==0)
                  miseajour($2,"Variable",$1,"-1","-","-","-","GLOBAL","SYNTAXIQUE");
                else {
                  sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                  miseajour($2,"Variable",$1,"-1","-","-","-",class_emplacement,"SYNTAXIQUE");
                }
              }
       | TYPE idf aff EXPRESSION_ITEM LISTVAR pvg 
              { 
                diviserChaine($4,partie1_1,partie1_2);
                if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (current_class_level==0)
                  miseajour($2,"Variable",$1,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                else {
                  sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                  miseajour($2,"Variable",$1,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                }
                if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                  if(strcmp($1,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                remplir_quad("=",partie1_2,"<vide>",$2);
              }
       | kwCHARACTER idf MULCHAR LISTVARSOLOCHAR pvg 
              { 
                if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (current_class_level==0)
                  miseajour($2,"Variable",$1,"-1",$3,"-","-","GLOBAL","SYNTAXIQUE");
                else {
                  sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                  miseajour($2,"Variable",$1,"-1",$3,"-","-",class_emplacement,"SYNTAXIQUE");
                }
              } 
       | kwCHARACTER idf MULCHAR aff EXPRESSION_ITEM LISTVARSOLOCHAR pvg 
              {
                diviserChaine($5,partie1_1,partie1_2);
                if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                if (current_class_level==0)
                  miseajour($2,"Variable",$1,partie1_2,$3,"-","-","GLOBAL","SEMANTIQUE");
                else {
                  sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                  miseajour($2,"Variable",$1,partie1_2,$3,"-","-",class_emplacement,"SEMANTIQUE");
                }
                if (strcmp($1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
                  printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                remplir_quad("=",partie1_2,"<vide>",$2);
              }  
;  */

/* DECTAB: TYPE idf kwDIMENSION po integer pf LISTVAR pvg 
            { 
              if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (current_class_level==0)
                miseajour($2,"Vecteur",$1,"-",$5,$5,"-","GLOBAL","SYNTAXIQUE");
              else {
                sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                miseajour($2,"Vecteur",$1,"-",$5,$5,"-",class_emplacement,"SYNTAXIQUE");
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
              if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (current_class_level==0)
                miseajour($2,"Vecteur",$1,"-",taille,$6,"-","GLOBAL","SYNTAXIQUE");  
              else {
                sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                miseajour($2,"Vecteur",$1,"-",taille,$6,"-",class_emplacement,"SYNTAXIQUE");  
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
              if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (current_class_level==0)
                miseajour($2,"Matrice",$1,"-",taille,$5,$7,"GLOBAL","SYNTAXIQUE");
              else {
                sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                miseajour($2,"Matrice",$1,"-",taille,$5,$7,class_emplacement,"SYNTAXIQUE"); 
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
              if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                YYABORT;
              }
              if (current_class_level==0)
                miseajour($2,"Matrice",$1,"-",taille,$6,$8,"GLOBAL","SYNTAXIQUE");
              else {
                sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                miseajour($2,"Matrice",$1,"-",taille,$6,$8,class_emplacement,"SYNTAXIQUE"); 
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
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Variable",current_type,"-1","-","-","-","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Variable",current_type,"-1","-","-","-",class_emplacement,"SYNTAXIQUE");
                    }
                  }
           | vg idf aff EXPRESSION_ITEM LISTVAR 
                  { 
                    diviserChaine($4,partie1_1,partie1_2);
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Variable",current_type,partie1_2,"-","-","-","GLOBAL","SEMANTIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Variable",current_type,partie1_2,"-","-","-",class_emplacement,"SEMANTIQUE");
                    }
                    if (strcmp(getType($2,current_class_level,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                      if(strcmp(getType($2,current_class_level,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(getType($2,current_class_level,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",$2);
                  }
; */

/* LISTVARSOLOCHAR: vg idf MULCHAR LISTVARSOLOCHAR 
                  { 
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Variable","CHARACTER","-1",$3,"-","-","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Variable","CHARACTER","-1",$3,"-","-",class_emplacement,"SYNTAXIQUE");
                    }
                  } 
               | vg idf MULCHAR aff EXPRESSION_ITEM LISTVARSOLOCHAR 
                  { 
                    diviserChaine($5,partie1_1,partie1_2);
                    if (current_class_level==0)
                      miseajour($2,"Variable","CHARACTER",partie1_2,$3,"-","-","GLOBAL","SEMANTIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Variable","CHARACTER",partie1_2,$3,"-","-",class_emplacement,"SEMANTIQUE");
                    }
                    if (strcmp(getType($2,current_class_level,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"-")!=0) {
                      if(strcmp(getType($2,current_class_level,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(getType($2,current_class_level,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
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
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Vecteur",current_type,"-",$5,$5,"-1","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Vecteur",current_type,"-",$5,$5,"-1",class_emplacement,"SYNTAXIQUE");
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
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Vecteur","CHARACTER","-",taille,$6,"-1","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Vecteur","CHARACTER","-",taille,$6,"-1",class_emplacement,"SYNTAXIQUE");
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
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Matrice",current_type,"-",taille,$5,$7,"GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Matrice",current_type,"-",taille,$5,$7,class_emplacement,"SYNTAXIQUE");
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
                    if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (current_class_level==0)
                      miseajour($2,"Matrice","CHARACTER","-",taille,$6,$8,"GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                      miseajour($2,"Matrice","CHARACTER","-",taille,$6,$8,class_emplacement,"SYNTAXIQUE");
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

/* INSTRUCTION_LIST: INSTRUCTION_ITEM INSTRUCTION_LIST
    |
; */

/* INSTRUCTION_ITEM: EQU         pvg 
     | ENTREE      pvg 
     | SORTIE      pvg 
     | AFFECTATION pvg 
     | IF_ELSE_BLOCK        
     | BOUCLE     
     | CALLPROC    pvg   {parameter_counter=0;}
;  */

/* AFFECTATION: idf aff EXPRESSION_ITEM  
                  { 
                    if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    diviserChaine($3,partie1_1,partie1_2);
                    strcpy(typeIDF,getType($1,current_class_level,"Variable"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                          printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($1,current_class_level,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",$1);
                    miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                  }
           | idf po INDEX pf aff EXPRESSION_ITEM
                  { 
                    diviserChaine($6,partie1_1,partie1_2);
                    if (!idf_existe($1,current_class_level,"Vecteur") && !idf_existe($1,current_class_level,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    strcpy(typeIDF,getType($1,current_class_level,"Vecteur"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($1,current_class_level,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    remplir_quad("=",partie1_2,"<vide>",tab);
                    miseajour($1,"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    strcpy(tab," ");
                  }   
           | idf po INDEX vg INDEX pf aff EXPRESSION_ITEM
                  { 
                    diviserChaine($8,partie1_1,partie1_2);
                    if (!idf_existe($1,current_class_level,"Matrice") && !idf_existe($1,current_class_level,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    strcpy(typeIDF,getType($1,current_class_level,"Matrice"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"-")!=0 && strcmp(partie1_1,"-")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char($1,current_class_level,"Variable",partie1_2)) {
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
 
/* EXPRESSION_ITEM: EXPRESSION_ITEM plus EXPRESSION_ITEM
                  { 
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM minus EXPRESSION_ITEM
                  { 
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM mul EXPRESSION_ITEM
                  { 
                    diviserChaine($1,partie1_1,partie1_2);
                    diviserChaine($3,partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
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
          | EXPRESSION_ITEM divi EXPRESSION_ITEM 
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
                    remplir_quad("-",partie1_2,partie2_2,temp);
                    tmp++;
                  } 
          | idf  
                  { 
                    if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(ch,$1);
                    if (idf_existe($1,current_class_level,"Variable")) strcpy(cat,getType($1,current_class_level,"Variable"));
                    if (idf_existe($1,current_class_level,"Parametre")) strcpy(cat,getType($1,current_class_level,"Parametre"));
                    strcat(cat,ch);
                    $$=strdup(cat);
                  }      
          | idf po INDEX pf 
                  {
                    if (!idf_existe($1,current_class_level,"Vecteur") && !idf_existe($1,current_class_level,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    if (!verif_index($1,current_class_level,"Vecteur",$3,"Ligne")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s)'.\n",file_name,nb_line,nb_character,$1,$3);
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);
                    strcat(ch,tab);
                    strcpy(tab," ");
                    if (idf_existe($1,current_class_level,"Vecteur")) strcpy(cat,getType($1,current_class_level,"Vecteur"));
                    if (idf_existe($1,current_class_level,"Parametre")) strcpy(cat,getType($1,current_class_level,"Parametre"));
                    strcat(cat,ch);
                    $$=strdup(cat);
                  }
          | idf po INDEX vg INDEX pf
                  {
                    if (!idf_existe($1,current_class_level,"Matrice") && !idf_existe($1,current_class_level,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    if (!verif_index($1,current_class_level,"Matrice",$3,"Ligne") || !verif_index($1,current_class_level,"Matrice",$5,"Colonne")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s,%s)'.\n",file_name,nb_line,nb_character,$1,$3,$5);
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);strcat(tab,$4);strcat(tab,$5);strcat(tab,$6);
                    strcat(ch,tab);
                    strcpy(tab," ");
                    if (idf_existe($1,current_class_level,"Matrice")) strcpy(cat,getType($1,current_class_level,"Matrice"));
                    if (idf_existe($1,current_class_level,"Parametre")) strcpy(cat,getType($1,current_class_level,"Parametre"));
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
          | po EXPRESSION_ITEM pf  
              {
                $$=strdup($2);
              }        
; */

/* INDEX: idf 
        { 
          if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
            printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
            YYABORT;
          }
          strcpy(typeIDF,getType($1,current_class_level,"Variable"));
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

R1_2_CONTROLE: R2_1_CONTROLE kwTHEN INSTRUCTION_LIST 
              {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              }
;

R3_1_CONTROLE: kwIF EXPRESSION_ITEM 
              {
                diviserChaine($2,partie1_1,partie1_2);
                if (strcmp(partie1_1,"LOGICAL")!=0 && strcmp(partie1_1,"-")!=0){
                  printf("\nFile '%s', line %d, character %d: semantic error : Unexpected expression type.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",partie1_2,"<vide>");
                
              }
;

R4_2_CONTROLE: R3_1_CONTROLE kwTHEN INSTRUCTION_LIST 
              {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              }
;

IF_ELSE_BLOCK: R1_2_CONTROLE kwELSE INSTRUCTION_LIST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R2_1_CONTROLE kwTHEN INSTRUCTION_LIST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R3_1_CONTROLE kwTHEN INSTRUCTION_LIST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
        | R4_2_CONTROLE kwELSE INSTRUCTION_LIST kwENDIF 
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              }
; */

/* CONDITION: po EXPRESSION_ITEM pt COMPARISON_OPERATOR pt EXPRESSION_ITEM pf
              { 
                diviserChaine($2,partie1_1,partie1_2);
                diviserChaine($6,partie2_1,partie2_2);
                sprintf(temp,"T%d",tmp);
                if (strcmp(partie2_1,partie1_1)!=0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0) {
                  if(!((strcmp(partie1_1,"REAL")==0 && strcmp(partie2_1,"INTEGER")==0) || (strcmp(partie2_1,"REAL")==0 && strcmp(partie1_1,"INTEGER")==0))){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                $$=strdup(temp);
                remplir_quad($4,partie1_2,partie2_2,temp);
                tmp++;
              }
         | po CONDITION pt LOGICAL_OPERATOR pt CONDITION pf
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

/* LOGICAL_OPERATOR: kwAND {$$=strdup($1);}
     | kwOR  {$$=strdup($1);}
; */

/* COMPARISON_OPERATOR: kwGT {$$=strdup($1);}
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

R2_1_BOUCLE: kwDOWHILE EXPRESSION_ITEM
                {
                  diviserChaine($2,partie1_1,partie1_2);
                  fin_dowhile=qc;
                  remplir_quad("BNZ"," ",partie1_1,"<vide>");
                }
;

BOUCLE: R1_1_BOUCLE INSTRUCTION_LIST kwENDDO 
                {
                  sprintf(i,"%d",deb_dowhile);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_dowhile,2,i);
                }
      | R2_1_BOUCLE INSTRUCTION_LIST kwENDDO 
                {
                  sprintf(i,"%d",deb_dowhile);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_dowhile,2,i);
                }
; */

/* MEMBREIDF : idf                      
                { 
                  if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  $$=strdup($1);
                }
          | idf po INDEX pf 
                { 
                  if (!idf_existe($1,current_class_level,"Vecteur") && !idf_existe($1,current_class_level,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  $$=strdup($1);
                }
          | idf po INDEX vg INDEX pf 
                { 
                  if (!idf_existe($1,current_class_level,"Matrice") && !idf_existe($1,current_class_level,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  $$=strdup($1);
                }
; */

/* SORTIE: kwWRITE po STRING_MESSAGE pf 
          {
            search($3,"Idf","CHARACTER","-","-1","-","-","-",3);
          }
      | kwWRITE po MEMBREIDF pf  
          {
            search($3,"Idf","CHARACTER","-","-1","-","-","-",3);
          }
;  */

/* STRING_MESSAGE: character MESSAGE_CONCATENATION
          {
            strcat(tab,$1);strcat(tab,$2);
            $$=strdup(tab);
            strcpy(tab," ");
          }
       | character
          {
            $$=strdup($1);
          }
       | MEMBREIDF vg STRING_MESSAGE
          {
            strcat(tab,$1);strcat(tab,$2);strcat(tab,$3);
            $$=strdup(tab);
            strcpy(tab," ");
          }
; */

/* MESSAGE_CONCATENATION: vg MEMBREIDF vg STRING_MESSAGE
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
              if (!idf_existe($1,current_class_level,"Variable") && !idf_existe($1,current_class_level,"Parametre")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,$1);
                YYABORT;
              }
              if (!idf_existe($4,-1,"Fonction")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Undeclared function '%s'.\n",file_name,nb_line,nb_character,$4);
                YYABORT;
              }
              strcpy(typeIDF,getType($1,current_class_level,"Variable"));
              if (strcmp(typeIDF,getType($4,-1,"Fonction"))!=0 && strcmp(typeIDF,"-")!=0) {
                if(strcmp(typeIDF,"REAL")!=0 || strcmp(getType($4,-1,"Fonction"),"INTEGER")!=0 ){
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
              }
              if(!verif_param($4,parameter_counter)){
                printf("\nFile '%s', line %d, character %d: semantic error : Uncorrect number of arguments of '%s'.\n",file_name,nb_line,nb_character,$4);
                YYABORT;
              }
              if (current_class_level==0)
                  search($4,"Idf","-","-","-","-","-","GLOBAL",3);
                else {
                  sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                  search($4,"Idf","-","-","-","-","-",class_emplacement,3);
              }
            }
; */

/* PARAMETRE: MEMBREIDF PARAMETRES
            {
              parameter_counter++;
            }
         | 
; */

/* PARAMETRES: vg MEMBREIDF PARAMETRES
            {
              parameter_counter++;
            }
          |
; */

%%

int yyerror(char *msg) { 
  printf("\nFile '%s', syntax error, line %d, column %d, entity '%s' \n",file_name,nb_line,nb_character,yylval.str);
  return 1; 
}

int main(int argc,char *argv[]){
  file_name=argv[1];
  initialisation();
  yyparse();
  afficher();
  affiche_quad();
  liberer_table();
  return 0;
}

int yywrap(){
  return 0;
}