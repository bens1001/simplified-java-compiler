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
    int intg;
    float flt;
    double dbl;
    struct {
        char* value;
        char* type;
    } expression;
}

%type <str>BASE_TYPE STRING_MESSAGE MESSAGE_CONCATENATION VARIABLE_MESSAGE INDEX CONDITION LOGICAL_OPERATOR COMPARISON_OPERATOR IMPORT_PATH NUMERIC_TYPE TYPE OBJECT_TYPE OPTIONAL_MULTIDIMENSION METHOD_SUFFIX ENTITY_ITEM_SUFFIX OBJECT_NAME OBJECT_ACCESS_METHOD OBJECT_ACCESS_SUFFIX OBJECT_ACCESS_SEQUENCE IMPORT_PATH_SUFFIX MULTIDIMENSION_ACCESS OBJECT_ACCESS OBJECT_CREATION 
;

%type <expression> EXPRESSION_ITEM EXPRESSION ARRAY_INSTANCE SUBARRAY_LIST SUBARRAY_ITEM OPTIONAL_ASSIGN
;

%token <str>kwBOOLEAN kwBREAK kwCASE kwCHAR kwCATCH kwCLASS kwCONTINUE kwDEFAULT kwDO kwDOUBLE kwELSE kwFINAL kwFINALLY kwFLOAT kwFOR kwIF kwIMPORT kwINT kwMAIN kwNEW kwPRIVATE kwPUBLIC kwRETURN kwSTATIC kwSWITCH kwPRINT kwPRINTLN kwTHIS kwTRY kwVOID kwWHILE 
;

%token <str> EXCEPTION BOOL STRING IDF 
;

%token <str> opGE opGT opEQ opLE opLT opNE opOR opAND opNOT opADD opMINUS opMUL opDIV opMOD opASSIGN pvg po pf acco accf dimo dimf pt vg dp
;

%token <intg> INTEGER
;

%token <dbl> DOUBLE
;

%token <flt> FLOAT
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
                search($1, "Class", "-", "-", "-", "-", "-", current_scope, 0);
                $$ = strdup($1);
              } else {
                char buffer[256];
                search($1, "Package", "-", "-", "-", "-", "-", current_scope, 0);
                sprintf(buffer, "%s%s", $1, $2);
                $$ = strdup(buffer);
              }
            }
;

IMPORT_PATH_SUFFIX: pt IDF IMPORT_PATH_SUFFIX
                      {
                        char segment[256];
                        
                        if (strlen($3) == 0) {
                          search($2, "Class", "-", "-", "-", "-", "-", current_scope, 0);
                        } else {
                          search($2, "Package", "-", "-", "-", "-", "-", current_scope, 0);
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
                if (idf_exists_same_scope($2, current_scope, "Class")) {
                  printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                  YYABORT;
                }
                search($2, "Class", "-", "-", "-", "-", "-", current_scope, 0);
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
                  if (idf_exists_same_scope($2, current_scope, $4)) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                  }
                  search($2, $4, $1, "-1", getArraySize($1), dimension_value,parameters_value ,current_scope, 0);
                }
           | CONSTRUCTOR
;

ENTITY_ITEM_SUFFIX: METHOD_SUFFIX {$$=strdup("Method");}
                  | OPTIONAL_ASSIGN ATTRIBUTE_LIST pvg {$$ = strdup("Attribute");}
;

// ------------------------------ ATTRIBUTE BLOCK ---------------------------------------------------------------------------

ATTRIBUTE_LIST: vg IDF OPTIONAL_ASSIGN ATTRIBUTE_LIST 
                  {  
                    if (idf_exists_same_scope($2, current_scope, "Attribute")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (strcmp(current_type,$3.type)!=0 && strcmp(current_type,"-")!=0 && strcmp($3.type,"-")!=0) {
                      if((strcmp(current_type,"float")!=0 && strcmp(current_type,"double")!=0 )|| strcmp($3.type,"int")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcpy(dimension_value,getArrayDimension($1));
                    search($2, "Attribute", current_type, "-1", getArraySize(current_type), dimension_value,"-" ,current_scope, 0);


                    // if(strcmp(getType($2,current_class_level,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }

                    // array
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");


                    // matrix
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("BOUNDS","2",$7,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");

                    // remplir_quad("=",$3.value,"<vide>",$2);
                  }
            |
;

// -------------------------- CONSTRUCTOR BLOCK ---------------------------------------------------------------------------------

CONSTRUCTOR: IDF CONSTRUCTOR_SUFFIX 
                {
                  if(!isConstructorValid($1,current_scope)) {
                    printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Unvalid constructor.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  sprintf(parameters_value,"%d",parameter_counter); 
                  search($1, "Constructor", "-", "-", "-", "-",parameters_value, current_scope, 0);
                }
;

CONSTRUCTOR_SUFFIX: po {parameter_counter = 0;}  CONSTRUCTOR_PARAMETER_LIST pf acco INSTRUCTION_LIST accf  
;

CONSTRUCTOR_PARAMETER_LIST: TYPE IDF {parameter_counter++;} CONSTRUCTOR_PARAMETER_ITEM
                                {
                                    search($2, "Parameter", $1, "-1", getArraySize($1),getArrayDimension($1), "-1", current_scope, 0);
                                }
                          | /* empty */

CONSTRUCTOR_PARAMETER_ITEM: vg TYPE IDF {parameter_counter++;} CONSTRUCTOR_PARAMETER_ITEM
                                {
                                    search($3, "Parameter", $2, "-1", getArraySize($2),getArrayDimension($2), "-1", current_scope, 0);
                                }
                     | /* empty */
;                        

// -------------------------- METHOD BLOCK ---------------------------------------------------------------------------------

METHOD_SUFFIX: po {parameter_counter = 0;} METHOD_PARAMETER_LIST pf acco INSTRUCTION_LIST accf {exit_scope();}
;

METHOD_PARAMETER_LIST: TYPE IDF {parameter_counter++;} METHOD_PARAMETER_ITEM
                        {
                            search($2, "Parameter", $1, "-1", getArraySize($1),getArrayDimension($1), "-1", current_scope, 0);
                        }
                     | /* empty */
;

METHOD_PARAMETER_ITEM: vg TYPE IDF {parameter_counter++;} METHOD_PARAMETER_ITEM
                        {
                            search($3, "Parameter", $2, "-1", getArraySize($2),getArrayDimension($2), "-1", current_scope, 0);
                        }
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
                if (!idf_exists_same_scope($1, "GLOBAL", "Class")) {
                  printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Undeclared Type.\n",file_name,nb_line,nb_character,$1);
                  YYABORT;
                }
                $$=strdup($1);
                strcpy(current_type,$1);
              }
;

// ------------------------------ OBJECT BLOCK --------------------------------------------------------------------------------------

OBJECT_CREATION: kwNEW IDF po ARGUMENT_LIST pf
                    {
                      if(!idf_exists_same_scope($2, "GLOBAL", "Class")) {
                        printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Undeclared constructor.\n",file_name,nb_line,nb_character,$2);
                        YYABORT;
                      }
                      $$=strdup($2);
                    }
;

OBJECT_ACCESS: OBJECT_ACCESS_SEQUENCE 
                  {
                    $$=strdup($1);
                  }
             | kwTHIS pt OBJECT_ACCESS_SEQUENCE 
                  {
                    strcat(tab,$1);
                    strcat(tab,$2);
                    strcat(tab,$3);
                    $$=strdup(tab);
                    strcpy(tab,"");
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

OBJECT_ACCESS_SUFFIX: OBJECT_NAME 
                        {
                          if (!check_idf_recursive_scope($1, current_scope, "Variable") && !check_idf_recursive_scope($1, current_scope, "Attribute") && !check_idf_recursive_scope($1, current_scope, "Parameter")) {
                                printf("\nFile '%s', semantic error, line %d, column %d: Undeclared entity '%s'.\n",
                                      file_name, nb_line, nb_character, $1);
                                YYABORT;
                          }
                          $$=strdup($1);
                        }
                    | OBJECT_ACCESS_METHOD {$$=strdup($1);}
;  

OBJECT_NAME: IDF {$$=strdup($1);}
;

// ------------------------------------------------ MULTIDIMENSION ACCESS -------------------------------------------------------------

MULTIDIMENSION_ACCESS: dimo INDEX dimf MULTIDIMENSION_ACCESS
                         {
                            strcat(tab,$1);
                            strcat(tab,$2);
                            strcat(tab,$3);
                            strcat(tab,$4);
                            $$=strdup(tab);
                            strcpy(tab,"");
                         }
                       | /*empty*/
                          {
                            $$=strdup(tab);
                            strcpy(tab,"");
                          }
;

INDEX: EXPRESSION_ITEM 
        { 
          if(strcmp($1.type,"int")!=0){
            printf("\nFile '%s', line %d, character %d: semantic error : Unexpected index type '%s'.\n",file_name,nb_line,nb_character,$1);
            YYABORT;
          }else if (atoi($1.value)<1){
            printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Negative dimension of vector.\n",file_name,nb_line,nb_character,$1.value);
            YYABORT;
          }
          $$=strdup($1.value);
        }
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
                    $$ = strdup($1);
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
                    {
                      $$=$2;
                    }
               | /* empty */
                    {
                      $$.value = "-";
                      $$.type = "-";
                    }
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

DECLARATION: TYPE IDF OPTIONAL_ASSIGN
                  { 
                    if (idf_exists_same_scope($2, current_scope, "Variable")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    search($2, "Variable", $1, "-1", getArraySize($1),getArrayDimension($1), "-", current_scope, 0);

                  // avec affectation

                  // diviserChaine($4,partie1_1,partie1_2);
                  // if (idf_existe($2,current_class_level,"Variable") || idf_existe($2,current_class_level,"Vecteur") || idf_existe($2,current_class_level,"Matrice")) {
                  //   printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,$2);
                  //   YYABORT;
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
                //   search($2,"Vecteur",$1,"-",$4,$4,"-","GLOBAL",0);
                // else {
                //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                //   search($2,"Vecteur",$1,"-",$4,$4,"-",class_emplacement,0);
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
                //   search($2,"Matrice",$1,"-",taille,$4,$6,"GLOBAL",0);
                // else {
                //   sprintf(class_emplacement,"LOCAL %d",current_class_level); 
                //   search($2,"Matrice",$1,"-",taille,$4,$6,class_emplacement,0); 
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
              VARIABLE_LIST 
;

VARIABLE_LIST: vg IDF OPTIONAL_ASSIGN VARIABLE_LIST 
                  {  
                    if (idf_exists_same_scope($2, current_scope, "Attribute")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if (strcmp(current_type,$3.type)!=0 && strcmp(current_type,"-")!=0 && strcmp($3.type,"-")!=0) {
                      if((strcmp(current_type,"float")!=0 && strcmp(current_type,"double")!=0 )|| strcmp($3.type,"int")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcpy(dimension_value,getArrayDimension($1));
                    search($2, "Attribute", current_type, "-1", getArraySize(current_type), dimension_value,"-" ,current_scope, 0);


                    // if(strcmp(getType($2,current_class_level,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                    //   if (!verif_char($2,current_class_level,"Variable",partie1_2)) {
                    //     printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                    //     YYABORT;
                    //   }
                    // }

                    // array
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");


                    // matrix
                    // remplir_quad("BOUNDS","1",$5,"<vide>");
                    // remplir_quad("BOUNDS","2",$7,"<vide>");
                    // remplir_quad("ADEC",$2,"<vide>","<vide>");

                    // remplir_quad("=",$3.value,"<vide>",$2);
                  }
            |
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
	                  search($1,"Output Message",string_message,"-",string_size,"1","-","-",0);
                  }
              | STRING
                  {
                    sprintf(string_size,"%d",strlen($1)-2);
	                  sprintf(string_message,"char[%d]",strlen($1)-2);
	                  search($1,"Output Message",string_message,"-",string_size,"1","-","-",0);
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

EXPRESSION: EXPRESSION_ITEM {$$=$1;}
          | ARRAY_INSTANCE {$$=$1;}
          | OBJECT_CREATION {$$.type=strdup($1);}
;

// ------------------------------ ARRAY BLOCK ---------------------------------------------------------------------------------------

ARRAY_INSTANCE: acco SUBARRAY_LIST accf
                  {
                    $$.type = strcat($2.type, "[]");
                    $$.value = malloc(strlen($2.value) + 3);
                    sprintf($$.value, "{%s}", $2.value);
                  }
;

SUBARRAY_LIST: SUBARRAY_ITEM {$$=$1;}
             | SUBARRAY_LIST vg SUBARRAY_ITEM
                  {
                    if (strcmp($1.type, $3.type) != 0) {
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                    }

                    char *new_value = malloc(strlen($1.value) + strlen($3.value) + 3);
                    sprintf(new_value, "%s, %s", $1.value, $3.value);
                    
                    $$.type = strdup($1.type);
                    $$.value = strdup(new_value);
                  }
;

SUBARRAY_ITEM: EXPRESSION_ITEM  {$$=$1;}
             | ARRAY_INSTANCE {$$=$1;}
;

// ------------------------------ EXPRESSION ITEM BLOCK ----------------------------------------------------------------------------

EXPRESSION_ITEM: EXPRESSION_ITEM opADD EXPRESSION_ITEM
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    char value[32];
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%lf", $1);
                     $$.type=strdup("double");
                      $$.value=strdup(value);
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%f", $1);
                     $$.type=strdup("float");
                      $$.value=strdup(value);
                    }
                    else{
                      sprintf(value, "%d", $1);
                     $$.type=strdup("int");
                      $$.value=strdup(value);
                    }

                    // sprintf(temp,"T%d",tmp);
                    // remplir_quad("+",$1.value,$3.value,temp);
                    // tmp++;
                  }  
          | EXPRESSION_ITEM opMINUS EXPRESSION_ITEM
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    char value[32];
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%lf", $1);
                     $$.type=strdup("double");
                      $$.value=strdup(value);
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%f", $1);
                     $$.type=strdup("float");
                      $$.value=strdup(value);
                    }
                    else{
                      sprintf(value, "%d", $1);
                     $$.type=strdup("int");
                      $$.value=strdup(value);
                    }

                    // sprintf(temp,"T%d",tmp);
                    // remplir_quad("-",$1.value,$3.value,temp);
                    // tmp++;
                  }  
          | EXPRESSION_ITEM opMUL EXPRESSION_ITEM
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    char value[32];
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%lf", $1);
                      $$.type=strdup("double");
                      $$.value=strdup(value);
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%f", $1);
                      $$.type=strdup("float");
                      $$.value=strdup(value);
                    }
                    else{
                      sprintf(value, "%d", $1);
                      $$.type=strdup("int");
                      $$.value=strdup(value);
                    }

                    // sprintf(temp,"T%d",tmp);
                    // remplir_quad("*",$1.value,$3.value,temp);
                    // tmp++;
                  }  
          | EXPRESSION_ITEM opMOD EXPRESSION_ITEM
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp($3.value,"0") == 0) { 
                      printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    char value[32];
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%lf", $1);
                     $$.type=strdup("double");
                      $$.value=strdup(value);
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      sprintf(value, "%f", $1);
                     $$.type=strdup("float");
                      $$.value=strdup(value);
                    }
                    else{
                      sprintf(value, "%d", $1);
                     $$.type=strdup("int");
                      $$.value=strdup(value);
                    }

                    // sprintf(temp,"T%d",tmp);
                    // remplir_quad("%",$1.value,$3.value,temp);
                    // tmp++;
                  }  
          | EXPRESSION_ITEM opDIV EXPRESSION_ITEM 
                  {  
                    if (strcmp($3.value,"0") == 0) { 
                      printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    char value[32];
                    sprintf(value, "%lf", $1);
                    $$.type=strdup("double");
                    $$.value=strdup(value);

                    // sprintf(temp,"T%d",tmp);
                    // remplir_quad("/",$1.value,$3.value,temp);
                    // tmp++;
                  } 
          | OBJECT_ACCESS MULTIDIMENSION_ACCESS
                  { 
                    char* base_name = get_element($1, false);

                    if (check_idf_recursive_scope(base_name, current_scope, "Variable")) {
                        $$.type = strdup(getType(base_name, current_scope, "Variable"));
                    } else {
                        $$.type = strdup(getType(base_name, current_scope, "Attribute"));
                    }

                    $$.value= strdup("base_name");

                    free(base_name);

                    // if (!verif_index($1,current_class_level,"Vecteur",$3,"Ligne")) {
                    //   printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s)'.\n",file_name,nb_line,nb_character,$1,$3);
                    //   YYABORT;
                    // }               
                  }             
          | DOUBLE    
              {
                char value[32];
                sprintf(value, "%lf", $1);
                $$.type=strdup("double");
                $$.value=strdup(value);
              }                
          | FLOAT    
              {
                char value[32];
                sprintf(value, "%f", $1);
                $$.type=strdup("float");
                $$.value=strdup(value);
              }                
          | INTEGER  
              {
                char value[32];
                sprintf(value, "%d", $1);
                $$.type=strdup("int");
                $$.value=strdup(value);
              }                  
          | BOOL  
              {
                $$.type=strdup("boolean");
                $$.value=strdup($1);
              }                    
          | STRING  
              {
                $$.type=strdup("char");
                $$.value=strdup($1);
              }                 
          | po EXPRESSION_ITEM pf  
              {
                $$=$2;
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
                      search($2,"Variable",$1, "-1", "-", "0", "-",current_scope, 0);
                  }
            | OBJECT_ACCESS OPTIONAL_ASSIGN
            |

FOR_LOOP_SIGNATURE: po NUMERIC_TYPE IDF dp OBJECT_ACCESS pf 
                        {
                          search($3,"Variable",$2, "-1", "-", "0", "-",current_scope, 0);
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
                    search($1, "Parameter", "-", "-", "-","-", "-", current_scope, 0);
                  }
               | EXCEPTION IDF
                  { 
                    search($2, "Parameter", $1, "-", "-","-", "-", current_scope, 0);
                  }
               |
;

OPTIONAL_FINALLY: kwFINALLY acco INSTRUCTION_LIST accf
                |
;

// --------------------------------- RETURN BLOCK -----------------------------------------------------------------------------------

RETURN: kwRETURN EXPRESSION_ITEM 
;

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