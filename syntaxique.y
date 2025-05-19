%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "ts.h"
#include "quad.h"
#include "assembly.h"

int nb_line=1;
int nb_character=0;
char *file_name;

char current_type[20];
char current_IDF[20];

char method_return_type[32];
bool has_returned=false;

int parameter_counter=0;
char parameters_value[20];
char *parameter_types[20];
char *argument_types[20];
char dimension_value[20];

int array_counter=0;

int dimension_counter=0;

char string_size[20];
char string_message[20];

int for_scope_parser_counter=0;

char i[20];
int qc;
int tmp=0;
char temp[20];
int cond_stack[100];
int cond_top = -1;

int deb_else;
int fin_if;
int deb_else_stack[100];
int fin_if_stack[100];
int if_stack_top = -1;

int fin_for;
int deb_for;
int for_deb_stack[100];
int for_fin_stack[100];
int for_stack_top = -1;

int fin_while;
int deb_while;
int while_deb_stack[100];
int while_fin_stack[100];
int while_stack_top = -1;

int fin_dowhile;
int deb_dowhile;
int do_deb_stack[100];
int do_fin_stack[100];
int do_stack_top = -1;

int   method_count = 0;
char *method_names[100];
int   method_entry_qc[100];
int   method_return_qc[100];

char partie1_1[20];
char partie2_1[20];

char tab[20];

 struct object{
      char *object_path;    
      char *nature_path;  
      char *attribute_type; 
      int   is_method; 
      char *value;
    } object;
 
struct object obj;
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
    struct {
      char *type;    
      int   count; 
    } array;
    struct {
      char *object_path;    
      char *nature_path;  
      char *attribute_type; 
      int   is_method; 
      char *value;
    } object;
}

%type <str>BASE_TYPE STRING_MESSAGE MESSAGE_CONCATENATION VARIABLE_MESSAGE INDEX IMPORT_PATH NUMERIC_TYPE TYPE OBJECT_TYPE OPTIONAL_MULTIDIMENSION METHOD_SUFFIX IMPORT_PATH_SUFFIX OBJECT_CREATION OBJECT_NAME
;

%type <expression> EXPRESSION GLOBAL_EXPRESSION PRIMARY UNARY MULTIPLICATIVE ADDITIVE RELATIONAL EQUALITY LOGICAL_AND LOGICAL_OR 
;

%type  <array> SUBARRAY_LIST SUBARRAY_ITEM ARRAY_INSTANCE
;

%type <object> OBJECT_ACCESS OBJECT_ACCESS_SUFFIX MULTIDIMENSION_ACCESS OBJECT_ACCESS_TAIL
;

%token <str>kwBOOLEAN kwBREAK kwCASE kwCHAR kwCATCH kwCLASS kwDEFAULT kwDO kwDOUBLE kwELSE kwFINALLY kwFLOAT kwFOR kwIF kwIMPORT kwINT kwMAIN kwNEW kwPUBLIC kwRETURN kwSTATIC kwSWITCH kwPRINT kwPRINTLN kwTHIS kwTRY kwVOID kwWHILE 
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
%left opOR
%left opAND 
%right opNOT
%nonassoc opGE opGT opEQ opLE opLT opNE
%left opADD opMINUS
%left opMUL opDIV opMOD

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
                          if (idf_exists_same_scope($2, current_scope, "Class")) {
                            printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                            YYABORT;
                          }
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

MAIN_METHOD: kwPUBLIC kwSTATIC kwVOID kwMAIN {enter_scope("Main");} po METHOD_PARAMETER_LIST pf acco INSTRUCTION_LIST accf {exit_scope();}
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

// ---------------------------- ENTITY BLOCK  ---------------------------------------------------------

ENTITY_LIST: ENTITY_LIST_NONEMPTY
           | /* empty */
;

ENTITY_LIST_NONEMPTY: ENTITY_ITEM
                    | ENTITY_LIST_NONEMPTY ENTITY_ITEM
;

ENTITY_ITEM: CONSTRUCTOR
           | METHOD_DECL
           | ATTRIBUTE_DECL 
;

// ------------------------------ ATTRIBUTE BLOCK ---------------------------------------------------------------------------

ATTRIBUTE_DECL: TYPE IDF 
                {
                  strcpy(current_IDF,$2); 
                }
                OPTIONAL_ASSIGN ATTRIBUTE_LIST pvg
                {
                  strcpy(parameters_value,"-");
                  strcpy(dimension_value,getArrayDimension($1));
                  if (idf_exists_same_scope($2, current_scope, "Attribute")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                  }
                  search($2, "Attribute", $1, "-", getArraySize($1), dimension_value,parameters_value ,current_scope, 0);
                }
;

ATTRIBUTE_LIST: vg IDF OPTIONAL_ASSIGN ATTRIBUTE_LIST 
                  {  
                    if (idf_exists_same_scope($2, current_scope, "Attribute")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    strcpy(dimension_value,getArrayDimension(current_type));
                    search($2, "Attribute", current_type, "-", getArraySize(current_type), dimension_value,"-" ,current_scope, 0);

                    strcpy(current_IDF,$2);
                  }
            | /* empty */
;

// -------------------------- CONSTRUCTOR BLOCK ---------------------------------------------------------------------------------

CONSTRUCTOR: IDF 
              {
                method_entry_qc[method_count] = qc;
                method_names[method_count] = strdup($1);
              }
              CONSTRUCTOR_SUFFIX 
                {
                  if(!isConstructorValid($1,current_scope)) {
                    printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Unvalid constructor.\n",file_name,nb_line,nb_character,$1);
                    YYABORT;
                  }
                  sprintf(parameters_value,"%d",parameter_counter); 
                  search($1, "Constructor", "-", "-", "-", "-",parameters_value, current_scope, 0);
                  setParameterTypes($1, current_scope, "Constructor", parameter_types, parameter_counter);
                }
;

CONSTRUCTOR_SUFFIX: po {parameter_counter = 0;}  CONSTRUCTOR_PARAMETER_LIST pf acco INSTRUCTION_LIST accf 
                       {
                        for_scope_parser_counter=0;
                        method_return_qc[method_count] = qc;
                        remplir_quad("BR", " ", "<vide>", "<vide>");
                        method_count++;
                       } 
;

CONSTRUCTOR_PARAMETER_LIST: TYPE IDF
                                {
                                  parameter_counter++;
                                  parameter_types[parameter_counter-1] = strdup($1);
                                }
                            CONSTRUCTOR_PARAMETER_ITEM
                                {
                                    search($2, "Parameter", $1, "-", getArraySize($1),getArrayDimension($1), "-1", current_scope, 0);
                                }
                          | /* empty */

CONSTRUCTOR_PARAMETER_ITEM: vg TYPE IDF 
                                {
                                  parameter_counter++;
                                  parameter_types[parameter_counter-1] = strdup($2);
                                }
                           CONSTRUCTOR_PARAMETER_ITEM
                                {
                                    search($3, "Parameter", $2, "-", getArraySize($2),getArrayDimension($2), "-1", current_scope, 0);
                                }
                     | /* empty */
;                        

// -------------------------- METHOD BLOCK ---------------------------------------------------------------------------------

METHOD_DECL: TYPE IDF 
                {
                  enter_scope($2);
                  strcpy(method_return_type, $1);
                  method_entry_qc[method_count] = qc;
                  method_names[method_count] = strdup($2); 
                  parameter_counter = 0;
                }
             METHOD_SUFFIX
                {
                  sprintf(parameters_value,"%d",parameter_counter);
                  strcpy(dimension_value,"-");
                  if (idf_exists_same_scope($2, current_scope, "Method")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                  }
                  search($2, "Method", $1, "-", getArraySize($1), dimension_value,parameters_value ,current_scope, 0);
                  setParameterTypes($2, current_scope, "Method", parameter_types, parameter_counter);
                }
;

METHOD_SUFFIX: po METHOD_PARAMETER_LIST pf acco INSTRUCTION_LIST accf 
                {
                  if (strcmp(method_return_type, "void") == 0) {
                      method_return_qc[method_count] = qc;
                      remplir_quad("BR", " ", "<vide>", "<vide>");
                      method_count++;
                  } else if (!has_returned) {
                    printf("\nFile '%s', syntax error, line %d, column %d : Expected return for '%s'.\n",file_name,nb_line,nb_character,method_return_type);
                    YYABORT;
                  }
                  exit_scope();              
                  for_scope_parser_counter=0;
                  has_returned=false;
                }
;

METHOD_PARAMETER_LIST: TYPE IDF 
                          {
                            parameter_counter++; 
                            parameter_types[parameter_counter-1] = strdup($1);
                          } 
                        METHOD_PARAMETER_ITEM
                          {
                            search($2, "Parameter", $1, "-", getArraySize($1),getArrayDimension($1), "-1", current_scope, 0);
                          }
                     | /* empty */
;

METHOD_PARAMETER_ITEM: vg TYPE IDF 
                          {
                            parameter_counter++;
                            parameter_types[parameter_counter-1] = strdup($2);
                          } 
                        METHOD_PARAMETER_ITEM
                          {
                              search($3, "Parameter", $2, "-", getArraySize($2),getArrayDimension($2), "-1", current_scope, 0);
                          }
                     | /* empty */
;

// ----------------------------- TYPE BLOCK -----------------------------------------------------------------------------------

TYPE: BASE_TYPE OPTIONAL_MULTIDIMENSION 
        {
          strcpy(current_type,$1);
          strcat(current_type,$2);
          $$=strdup(current_type);
        }
    | OBJECT_TYPE {$$=strdup($1);strcpy(current_type,$1);}
;

BASE_TYPE: NUMERIC_TYPE {$$=strdup($1);}
         | kwBOOLEAN {$$=strdup($1);}
         | kwCHAR    {$$=strdup($1);}
         | kwVOID    {$$=strdup($1);}
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
              }
;

// ------------------------------ OBJECT BLOCK --------------------------------------------------------------------------------------

OBJECT_ACCESS: IDF 
                  {
                    int is_var = check_idf_recursive_scope($1, current_scope, "Variable");
                    int is_param = check_idf_recursive_scope($1, current_scope, "Parameter");
                    if (!is_var && !is_param && idf_exists_same_scope($1, current_scope, "Class")) {
                        printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Undeclared identifier.\n",file_name,nb_line,nb_character,$1);
                      YYABORT;
                    }
                    obj.object_path = strdup($1);
                    obj.nature_path = strdup(
                      is_var
                        ? "Variable"
                        : "Parameter"
                    );
                    obj.attribute_type = strdup(
                      is_var
                        ? getTypeRecursive($1, current_scope, "Variable")
                        : getTypeRecursive($1, current_scope, "Parameter")
                    );
                    obj.is_method = 0;
                    dimension_counter=0;
                  } 
                OBJECT_ACCESS_TAIL
                  {
                    $$.object_path = strdup(obj.object_path);
                    $$.nature_path = strdup(obj.nature_path);
                    $$.attribute_type = strdup(obj.attribute_type);
                    $$.is_method = obj.is_method;
                  }
             | kwTHIS 
                  {
                    char classScope[256];
                    if (strchr(current_scope, '.')) {
                      char *firstDot  = strchr(current_scope, '.');
                      char *secondDot = strchr(firstDot + 1, '.');
                      size_t len = secondDot
                                   ? (secondDot - current_scope)
                                   : strlen(current_scope);
                      strncpy(classScope, current_scope, len);
                      classScope[len] = '\0';
                    } else {
                      strcpy(classScope, current_scope);
                    } 
                    char *clsName = strchr(classScope, '.');
                    if (clsName) ++clsName; else clsName = classScope; 
                    obj.object_path = strdup("this");
                    obj.nature_path = strdup("Variable");
                    obj.attribute_type = strdup(clsName);
                    obj.is_method = 0;
                  } 
                OBJECT_ACCESS_TAIL
                  {
                    $$.object_path = strdup(obj.object_path);
                    $$.nature_path = strdup(obj.nature_path);
                    $$.attribute_type = strdup(obj.attribute_type);
                    $$.is_method = obj.is_method;
                  }
;            

OBJECT_NAME: IDF {$$=strdup($1);} 
;

OBJECT_ACCESS_TAIL: pt OBJECT_ACCESS_SUFFIX OBJECT_ACCESS_TAIL {$$=$2;}
                    | MULTIDIMENSION_ACCESS OBJECT_ACCESS_TAIL {$$=$1;}
                    | /* empty */ {}
;

OBJECT_ACCESS_SUFFIX: OBJECT_NAME 
                        {
                          char *old_p = obj.object_path;
                          char *old_n = obj.nature_path;
                          char *old_t = obj.attribute_type;
                          char cls_scope[256];
                          snprintf(cls_scope,sizeof(cls_scope),"GLOBAL.%s",old_t);
                          if (!check_idf_recursive_scope($1, cls_scope, "Attribute")) {
                            if (!startsWith(old_t, "int") || !startsWith(old_t, "float") || !startsWith(old_t, "double") || !startsWith(old_t, "boolean") || !startsWith(old_t, "char")){
                              printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Attribute not found in '%s'.\n",file_name,nb_line,nb_character,$1, old_t);
                              YYABORT;
                            }else{
                              printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Type '%s' is not a class.\n",file_name,nb_line,nb_character,$1, old_t);
                              YYABORT;
                            }
                          }
                          obj.object_path = concat(old_p, $1);
                          obj.nature_path = concat(old_n, "Attribute");
                          obj.attribute_type = strdup(getType($1, cls_scope, "Attribute"));
                          obj.is_method = 0;
                          dimension_counter=0;
                        }
                    | IDF {parameter_counter=0;} po ARGUMENT_LIST pf 
                        {
                          char *old_p = obj.object_path;
                          char *old_n = obj.nature_path;
                          char *old_t = obj.attribute_type;
                          char cls_scope[256];
                          snprintf(cls_scope,sizeof(cls_scope),"GLOBAL.%s",old_t);
                          if (!check_idf_recursive_scope($1, cls_scope, "Method") && !endsWith(old_t, "Exception")) {
                            if (startsWith(old_t, "int") || startsWith(old_t, "float") || startsWith(old_t, "double") || startsWith(old_t, "boolean") || startsWith(old_t, "char")){
                              printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Type '%s' is not a class.\n",file_name,nb_line,nb_character,$1, old_t);
                              YYABORT;
                            } else {
                              printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Method not found in '%s'.\n",file_name,nb_line,nb_character,$1, old_t);
                              YYABORT;
                            }
                            char buf[128];
                            sprintf(buf, "%s()", $1);
                            obj.object_path = concat(old_p, buf);
                          }

                          if(atoi(getNumParams($1, cls_scope, "Method"))< parameter_counter){
                            printf("\nFile '%s', syntaxic error, line %d, column %d, entity '%s': Too much arguments.\n",file_name,nb_line,nb_character,$1, old_p);
                            YYABORT;
                          } else if (atoi(getNumParams($1, cls_scope, "Method"))> parameter_counter){
                            printf("\nFile '%s', syntaxic error, line %d, column %d, entity '%s': Too few arguments.\n",file_name,nb_line,nb_character,$1, old_p);
                            YYABORT;
                          }

                          char **param_types = getParameterTypes($1, cls_scope, "Method");
                          if (param_types) {
                            int i;
                            for (i = 0; i < parameter_counter; i++) {
                              if (param_types[i] && argument_types[i] && strcmp(param_types[i], argument_types[i]) != 0) {
                                printf("\nFile '%s', semantic error, line %d, column %d: Argument type mismatch for parameter %d in method '%s': expected '%s', got '%s'.\n",
                                       file_name, nb_line, nb_character, i+1, $1, param_types[i], argument_types[i]);
                                YYABORT;
                              }
                            }
                          }

                          obj.nature_path = concat(old_n, "Method");
                          obj.attribute_type = strdup(getType($1, cls_scope, "Method"));
                          obj.is_method = 1;
                          dimension_counter=0;

                          int call_q = qc;
                          remplir_quad("BR", " ", "<vide>", "<vide>"); 
                          int i;
                          for (i = 0; i < method_count; i++) {
                            if (strcmp(method_names[i], $1) == 0) {
                              char target_entry[16],target_return[16];
                              sprintf(target_entry, "%d", method_entry_qc[i]);
                              sprintf(target_return, "%d", qc);
                              mise_jr_quad(call_q, 2, target_entry);
                              mise_jr_quad(method_return_qc[i], 2, target_return);
                              break;
                            }
                          }
                          obj.value = strdup(temp);
                        }
;

MULTIDIMENSION_ACCESS: dimo INDEX dimf 
                        {
                          char *old_path = obj.object_path;
                          char *old_nature = obj.nature_path;
                          char *old_type = obj.attribute_type;
                          if (atoi(getArrayDimension(old_type)) == 0 && dimension_counter==0) {
                              printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Unexpected indexing on non-array.\n",file_name,nb_line,nb_character,old_path);
                              YYABORT;
                          }
                          else {
                            int type_sizes[100];
                            getArraySizes(old_type, type_sizes);
                            if (type_sizes[dimension_counter] != -1  && atoi($2) > type_sizes[dimension_counter]) {
                                printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Array access out of bounds '%s'.\n",file_name,nb_line,nb_character,old_path,old_type);
                                YYABORT;
                            }
                            dimension_counter++;
                          }
                          char idxbuf[64]; sprintf(idxbuf, "[%s]", $2);
                          char *new_path = malloc(strlen(old_path) + strlen(idxbuf) + 1);
                          strcpy(new_path, old_path);
                          strcat(new_path, idxbuf);
                          char *new_nature = concat(old_nature, "index");
                          char *new_type = strdup(old_type);
                          char *b = strchr(new_type, '['); if (b) *b = '\0';
                          obj.object_path = new_path;
                          obj.nature_path = new_nature;
                          obj.attribute_type = new_type;
                          obj.is_method = 0;
                        }
;

INDEX: EXPRESSION 
        { 
          if(strcmp($1.type,"int")!=0){
            printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Unexpected index type.\n",file_name,nb_line,nb_character,$1.value);
            YYABORT;
          } 
          if (atoi($1.value)<0){
            printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Negative dimension of vector.\n",file_name,nb_line,nb_character,$1.value);
            YYABORT;
          }
          $$=strdup($1.value);
        }
;

OBJECT_CREATION: kwNEW IDF {parameter_counter=0;} po ARGUMENT_LIST pf
                    {
                      if(!idf_exists_same_scope($2, "GLOBAL", "Class")) {
                        printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Undeclared constructor.\n",file_name,nb_line,nb_character,$2);
                        YYABORT;
                      }

                      if(atoi(getNumParams($2, concat("GLOBAL",$2), "Constructor"))< parameter_counter){
                        printf("\nFile '%s', syntaxic error, line %d, column %d, entity '%s': Too much arguments.\n",file_name,nb_line,nb_character,$2);
                        YYABORT;
                      } else if (atoi(getNumParams($2, concat("GLOBAL",$2), "Constructor"))> parameter_counter){
                        printf("\nFile '%s', syntaxic error, line %d, column %d, entity '%s': Too few arguments.\n",file_name,nb_line,nb_character,$2);
                        YYABORT;
                      }

                      char **param_types = getParameterTypes($2, concat("GLOBAL",$2), "Constructor");
                      if (param_types) {
                        int i;
                        for (i = 0; i < parameter_counter; i++) {
                          if (param_types[i] && argument_types[i] && strcmp(param_types[i], argument_types[i]) != 0) {
                            printf("\nFile '%s', semantic error, line %d, column %d: Argument type mismatch for parameter %d in constructor '%s': expected '%s', got '%s'.\n",
                                   file_name, nb_line, nb_character, i+1, $2, param_types[i], argument_types[i]);
                            YYABORT;
                          }
                        }
                      }
                      
                      int call_q = qc;
                      remplir_quad("BR", " ", "<vide>", "<vide>"); 
                      int i;
                      for (i = 0; i < method_count; i++) {
                          if (strcmp(method_names[i], $2) == 0) {
                              char target_entry[16],target_return[16];
                              sprintf(target_entry, "%d", method_entry_qc[i]);
                              sprintf(target_return, "%d", qc);
                              mise_jr_quad(call_q, 2, target_entry);
                              mise_jr_quad(method_return_qc[i], 2, target_return);
                              break;
                          }
                      }
                      $$=strdup($2);
                    }
;

// ------------------------------ ARGUMENT BLOCK ------------------------------------------------------------------------------------

ARGUMENT_LIST: ARGUMENT_ITEM 
             | 
;

ARGUMENT_ITEM:
      EXPRESSION
      { 
        parameter_counter++;
        argument_types[parameter_counter-1] = strdup($1.type);
      }
    | ARGUMENT_ITEM vg EXPRESSION
      { 
        parameter_counter++;
        argument_types[parameter_counter-1] = strdup($3.type);
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
                       | /* empty */
                          {
                            $$=strdup(tab);
                            strcpy(tab,"");
                          }
;

OPTIONAL_ASSIGN: opASSIGN GLOBAL_EXPRESSION
                    {
                      char *dst_base = getBaseType(current_type);
                      char *src_base = getBaseType($2.type);
                      int   dimension_dest = atoi(getArrayDimension(current_type));
                      int   dimension_src  = atoi(getArrayDimension($2.type));
                      if (!(strcmp(dst_base, "char") == 0 && strcmp(src_base, "char") == 0) && dimension_dest != dimension_src) {
                         printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,current_IDF,current_type,$2.type);
                         YYABORT;
                      }

                      if (dimension_dest > 0) {
                          int dst_sizes[100], src_sizes[100];
                          int count = getArraySizes(current_type, dst_sizes);
                          getArraySizes($2.type, src_sizes);
                          int i;
                          for (i = 0; i < count; ++i) {
                              if (dst_sizes[i] != -1 && src_sizes[i] != -1 && src_sizes[i] > dst_sizes[i]) {
                                  printf("\nFile '%s', line %d, character %d: semantic error : Array too large '%s'.\n",file_name, nb_line, nb_character, $2.type);
                                  YYABORT;
                              }
                          }
                      }

                      if (strcmp(dst_base, src_base) != 0) {
                          if (isNumericType(dst_base) && isNumericType(src_base)) {
                              if (dimension_dest == 0) {
                                  double temp = atof($2.value);
                                  char   buf[64];
                                  if      (strcmp(dst_base, "int")    == 0) sprintf(buf, "%d",   (int)temp);
                                  else if (strcmp(dst_base, "float")  == 0) sprintf(buf, "%f",   (float)temp);
                                  else if (strcmp(dst_base, "double") == 0) sprintf(buf, "%lf",  temp);
                                  else    strcpy(buf, $2.value);

                                  free($2.value);
                                  $2.value = strdup(buf);
                              }
                          }
                          else {
                              printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,current_IDF,current_type,$2.type);
                              YYABORT;
                          }
                      }

                      free(dst_base);
                      free(src_base);

                      update(current_IDF,"Attribute","-1",$2.value,"-1","-1","-1",current_scope);
                      remplir_quad("=",$2.value,"<vide>",current_IDF);
                    }
               | /* empty */
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

DECLARATION: TYPE IDF
                  { 
                    if (idf_exists_same_scope($2, current_scope, "Variable")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    if(atoi(getArrayDimension($1))> 0){
                      int type_sizes[100];
                      int count = getArraySizes($1,type_sizes);
                      char buffer_dim[100],buffer_size[100];
                      int dim_counter;
                      for(dim_counter=0;dim_counter<count;dim_counter++){
                        if (type_sizes[dim_counter] != -1) {
                          sprintf(buffer_dim,"%d",dim_counter+1);
                          sprintf(buffer_size,"%d",type_sizes[dim_counter]);
                          remplir_quad("BOUNDS",buffer_dim,buffer_size,"<vide>");
                        }
                      }
                      remplir_quad("ADEC",$2,"<vide>","<vide>");
                    }
                    search($2, "Variable", $1, "NULL", getArraySize($1),getArrayDimension($1), "-", current_scope, 0);
                    strcpy(current_IDF,$2);
                  } 
              OPTIONAL_ASSIGN VARIABLE_LIST 
;

VARIABLE_LIST: vg IDF OPTIONAL_ASSIGN VARIABLE_LIST 
                  {  
                    if (idf_exists_same_scope($2, current_scope, "Variable")) {
                      printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Double declaration.\n",file_name,nb_line,nb_character,$2);
                      YYABORT;
                    }
                    strcpy(dimension_value,getArrayDimension(current_type));
                    search($2, "Variable", current_type, "NULL", getArraySize(current_type), dimension_value,"-" ,current_scope, 0);
                    strcpy(current_IDF,$2);
                  }
            | /* empty */
;

// ------------------------------ PRINT BLOCK -------------------------------------------------------------------------------------

OUTPUT: PRINT po STRING_MESSAGE pf 
      | PRINT po VARIABLE_MESSAGE pf  
;

PRINT: kwPRINTLN
     | kwPRINT
;

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
              | /* empty */ {}
;

MESSAGE_CONCATENATION: opADD VARIABLE_MESSAGE opADD STRING_MESSAGE
                     | opADD VARIABLE_MESSAGE 
;

VARIABLE_MESSAGE : OBJECT_ACCESS  {$$=$1.object_path;}                    
;

// ------------------------------ ASSIGN BLOCK -------------------------------------------------------------------------------------

ASSIGN: OBJECT_ACCESS opASSIGN GLOBAL_EXPRESSION 
                  { 
                    char* base_name = get_element($1.object_path, false);

                    char *dst_base = getBaseType($1.attribute_type);
                    char *src_base = getBaseType($3.type);
                    int dimension_dest = atoi(getArrayDimension($1.attribute_type));
                    int dimension_src = atoi(getArrayDimension($3.type));
                    if (!(strcmp(dst_base, "char") == 0 && strcmp(src_base, "char") == 0) && dimension_dest != dimension_src) {
                        printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.object_path,$1.attribute_type,$3.type);
                        YYABORT;
                    }
                    if (dimension_dest > 0) {
                        int dst_sizes[100], src_sizes[100];
                        int count = getArraySizes($1.attribute_type, dst_sizes);
                        getArraySizes($3.type, src_sizes);
                        int i;
                        for (i = 0; i < count; ++i) {
                            if (dst_sizes[i] != -1 && src_sizes[i] != -1 && src_sizes[i] > dst_sizes[i]) {
                                printf("\nFile '%s', line %d, character %d: semantic error : Array too large '%s'.\n",file_name, nb_line, nb_character, $3.type);
                                YYABORT;
                            }
                        }
                    }
                    if (strcmp(dst_base, src_base) != 0) {
                        if (isNumericType(dst_base) && isNumericType(src_base)) {
                            if (dimension_dest == 0) {
                                double temp = atof($3.value);
                                char   buf[64];
                                if      (strcmp(dst_base, "int")    == 0) sprintf(buf, "%d",   (int)temp);
                                else if (strcmp(dst_base, "float")  == 0) sprintf(buf, "%f",   (float)temp);
                                else if (strcmp(dst_base, "double") == 0) sprintf(buf, "%lf",  temp);
                                else    strcpy(buf, $3.value);
                                free($3.value);
                                $3.value = strdup(buf);
                            }
                        }
                        else {
                            printf("\nFile '%s', semantic error, line %d, column %d, entity '%s': Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.object_path,$1.attribute_type,$3.type);
                            YYABORT;
                        }
                    }

                    remplir_quad("=", $3.value, "<vide>", $1.object_path);

                    char* base_nature = get_element($1.nature_path, false);
                    if (strcmp(base_nature,"Variable")==0) update(base_name,base_nature,"-1",$3.value,"-1","-1","-1",current_scope);

                    free(dst_base);
                    free(src_base);
                    free(base_name);  
                  }
;

// ------------------------------ EXPRESSION BLOCK -----------------------------------------------------------------------------------

GLOBAL_EXPRESSION: EXPRESSION {$$=$1;}
                 | ARRAY_INSTANCE 
                     {
                       $$.type = strdup($1.type);
                       sprintf(temp,"T%d",tmp);
                       $$.value=strdup(temp);
                       tmp++;
                     }
                 | OBJECT_CREATION 
                     {
                       $$.type=strdup($1);
                       sprintf(temp,"T%d",tmp);
                       $$.value=strdup(temp);
                       tmp++;
                     }
;

// ------------------------------ ARRAY BLOCK ---------------------------------------------------------------------------------------

ARRAY_INSTANCE: acco SUBARRAY_LIST accf
                  {
                    int n = $2.count;
                    $$.type = malloc(strlen($2.type) + 8);
                    sprintf($$ .type, "%s[%d]", $2.type, n);
                    $$.count = n;
                  }
;

SUBARRAY_LIST: SUBARRAY_ITEM {$$=$1;}
             | SUBARRAY_LIST vg SUBARRAY_ITEM
                  {
                    if (strcmp($1.type, $3.type) != 0) {
                        printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.type,$3.type);
                        YYABORT;
                    }                    
                    $$.type = strdup($1.type);
                    $$.count = $1.count + 1;
                  }
;

SUBARRAY_ITEM: EXPRESSION  
                  {
                    $$.type = strdup($1.type);
                    $$.count = 1; 
                  }
             | ARRAY_INSTANCE 
                  {
                    $$.type  = strdup($1.type);
                    $$.count = 1;
                  }
;

// ------------------------------ EXPRESSION ITEM BLOCK ----------------------------------------------------------------------------

EXPRESSION: LOGICAL_OR {$$=$1;}
;

LOGICAL_OR: LOGICAL_AND {$$=$1;}
          | LOGICAL_OR opOR LOGICAL_AND
                  {
                    // int false_label = qc++;
                    // int exit_label = qc++;
                      
                    // remplir_quad("BNZ",false_label, $1.value, "<vide>");
                    // remplir_quad("BNZ",false_label, $3.value,"<vide>");

                    // sprintf(temp,"T%d",tmp++);
                    // remplir_quad("=", "0", "<vide>", temp);
                    // remplir_quad("BR", exit_label, "<vide>","<vide>" );
                    
                    // sprintf(temp,"T%d",tmp++);
                    // remplir_quad("=", "1", "", temp);
                    
                    $$.type = strdup("boolean");
                    
                    // $$.value = temp;
                  }
;

LOGICAL_AND: EQUALITY {$$=$1;}
           | LOGICAL_AND opAND EQUALITY
                  {
                    // int true_label = qc++;
                    // int exit_label = qc++;
                    
                    // remplir_quad("BZ",true_label, $1.value, "<vide>");
                    // remplir_quad("BZ",true_label, $3.value,"<vide>");

                    // sprintf(temp,"T%d",tmp++);
                    // remplir_quad("=", "1", "<vide>", temp);
                    // remplir_quad("BR", exit_label, "<vide>","<vide>");
                    
                    // sprintf(temp,"T%d",tmp++);
                    // remplir_quad("=", "0", "", temp);
                    
                    $$.type = strdup("boolean");
                  
                    // $$.value = temp;
                  }
;

EQUALITY: RELATIONAL {$$=$1;}
        | EQUALITY opEQ RELATIONAL
                  {
                    $$.type=strdup("boolean");
                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("BNE"," ",$1.value,$3.value);
                    tmp++;
                  }
        | EQUALITY opNE RELATIONAL
                  {
                    $$.type=strdup("boolean");
                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("BE"," ",$1.value,$3.value);
                    tmp++;
                  }
;

RELATIONAL: ADDITIVE {$$=$1;}
          | RELATIONAL opLT ADDITIVE
                  {
                    $$.type=strdup("boolean");
                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("BGE"," ",$1.value,$3.value);
                    tmp++;
                  }
          | RELATIONAL opLE ADDITIVE
                  {
                    $$.type=strdup("boolean");
                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("BG"," ",$1.value,$3.value);
                    tmp++;
                  }
          | RELATIONAL opGT ADDITIVE
                  {
                    $$.type=strdup("boolean");
                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("BLE"," ",$1.value,$3.value);
                    tmp++;
                  }
          | RELATIONAL opGE ADDITIVE
                  {
                    $$.type=strdup("boolean");
                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("BL"," ",$1.value,$3.value);
                    tmp++;
                  }
;

ADDITIVE: MULTIPLICATIVE {$$=$1;}
        | ADDITIVE opADD MULTIPLICATIVE
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.type,$3.type);
                      YYABORT;
                    }
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      $$.type=strdup("double");
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      $$.type=strdup("float");
                    }
                    else{
                      $$.type=strdup("int");
                    }

                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("+",$1.value,$3.value,temp);
                    tmp++;
                  } 
        | ADDITIVE opMINUS MULTIPLICATIVE
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.type,$3.type);
                      YYABORT;
                    }
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      $$.type=strdup("double");
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      $$.type=strdup("float");
                    }
                    else{
                      $$.type=strdup("int");
                    }

                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("-",$1.value,$3.value,temp);
                    tmp++;
                  }  
;

MULTIPLICATIVE: UNARY {$$=$1;}
             | MULTIPLICATIVE opMUL UNARY
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.type,$3.type);
                      YYABORT;
                    }
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      $$.type=strdup("double");
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                      $$.type=strdup("float");
                    }
                    else{
                      $$.type=strdup("int");
                    }

                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("*",$1.value,$3.value,temp);
                    tmp++;
                  } 
             | MULTIPLICATIVE opMOD UNARY
                  { 
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.type,$3.type);
                      YYABORT;
                    }
                    if (strcmp($3.value,"0") == 0) { 
                      printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp($1.type,"double") == 0  ||  strcmp($3.type,"double") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                     $$.type=strdup("double");
                    }
                    else if(strcmp($1.type,"float") == 0 || strcmp($3.type,"float") == 0 && strcmp(partie1_1,"-")!=0 && strcmp(partie2_1,"-")!=0){
                     $$.type=strdup("float");
                    }
                    else{
                     $$.type=strdup("int");
                    }

                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("%",$1.value,$3.value,temp);
                    tmp++;
                  } 
             | MULTIPLICATIVE opDIV UNARY
                  {  
                    if (strcmp($3.value,"0") == 0) { 
                      printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp($1.type,"char") == 0 || strcmp($1.type,"boolean") == 0 || strcmp($3.type,"char") == 0 || strcmp($3.type,"boolean") == 0) {
                      printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.type,$3.type);
                      YYABORT;
                    }

                    $$.type=strdup("double");

                    sprintf(temp,"T%d",tmp);
                    $$.value=strdup(temp);
                    remplir_quad("/",$1.value,$3.value,temp);
                    tmp++;
                  }
;

UNARY: opNOT UNARY
          {
            $$.type = strdup("boolean");
            // sprintf(temp,"T%d",tmp++);
            // $$.value = temp;
            // remplir_quad("BZ", $2.value, "", $$.value);
          }
     /* | opMINUS UNARY */
     | PRIMARY {$$=$1;}
;

PRIMARY: OBJECT_ACCESS
            { 
              $$.type  = strdup($1.attribute_type);
              if ($1.is_method) {
                  sprintf(temp,"T%d",tmp);
                  $$.value = strdup(temp);  
                  tmp++;
              } else {
                $$.value = strdup($1.object_path);
              }     
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
       | STRING
            {
              sprintf(string_size,"%d",strlen($1)-2);
	            sprintf(string_message,"char[%d]",strlen($1)-2);
	            search($1,"String",string_message,"-",string_size,"1","-","-",0);
              $$.type=strdup(string_message);
              $$.value=strdup($1);
            } 
       | BOOL
            {
              $$.type=strdup("boolean");
              $$.value=strdup($1);
            } 
       | po EXPRESSION pf {$$=$2;}
;

// --------------------------------- INCREMENT AND DECREMENT BLOCK ---------------------------------------------------------------------------

INCREMENT: POSTFIX_INCREMENT
         | INCREMENT_ASSIGN
;

POSTFIX_INCREMENT: OBJECT_ACCESS opADD opADD
                      {
                        sprintf(temp,"T%d",tmp);
                        remplir_quad("+",$1.object_path,"1",temp);
                        tmp++;
                        remplir_quad("=",temp,"<vide>",$1.object_path);
                      }
                 | OBJECT_ACCESS opMINUS opMINUS
                      {
                        sprintf(temp,"T%d",tmp);
                        remplir_quad("-",$1.object_path,"1",temp);
                        tmp++;
                        remplir_quad("=",temp,"<vide>",$1.object_path);
                      }
;

INCREMENT_ASSIGN : OBJECT_ACCESS opADD opASSIGN EXPRESSION
                      {
                        if (strcmp($1.attribute_type,"char") == 0 || strcmp($1.attribute_type,"boolean") == 0 || strcmp($4.type,"char") == 0 || strcmp($4.type,"boolean") == 0) {
                          printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.attribute_type,$4.type);
                          YYABORT;
                        }
                        sprintf(temp,"T%d",tmp);
                        remplir_quad("+",$1.object_path,$4.value,temp);
                        tmp++;
                        remplir_quad("=",temp,"<vide>",$1.object_path);
                      }
                 | OBJECT_ACCESS opMINUS opASSIGN EXPRESSION
                      {
                        if (strcmp($1.attribute_type,"char") == 0 || strcmp($1.attribute_type,"boolean") == 0 || strcmp($4.type,"char") == 0 || strcmp($4.type,"boolean") == 0) {
                          printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.attribute_type,$4.type);
                          YYABORT;
                        }
                        sprintf(temp,"T%d",tmp);
                        remplir_quad("-",$1.object_path,$4.value,temp);
                        tmp++;
                        remplir_quad("=",temp,"<vide>",$1.object_path);
                      }
                 | OBJECT_ACCESS opMUL opASSIGN EXPRESSION
                      {
                        if (strcmp($1.attribute_type,"char") == 0 || strcmp($1.attribute_type,"boolean") == 0 || strcmp($4.type,"char") == 0 || strcmp($4.type,"boolean") == 0) {
                          printf("\nFile '%s', semantic error, line %d, column %d : Type incompatibility '%s' vs '%s'.\n",file_name,nb_line,nb_character,$1.attribute_type,$4.type);
                          YYABORT;
                        }
                        sprintf(temp,"T%d",tmp);
                        remplir_quad("*",$1.object_path,$4.value,temp);
                        tmp++;
                        remplir_quad("=",temp,"<vide>",$1.object_path);
                      }
;

// --------------------------------- IF/ELSE BLOCK ---------------------------------------------------------------------------

IF_PREFIX: kwIF po EXPRESSION pf 
              {
                if (strcmp($3.type, "boolean") != 0) {
                  printf("\nFile '%s', semantic error, line %d, column %d, entity '%s' is not a boolean type.\n",file_name, nb_line, nb_character, $3.value);
                  YYABORT;
                }
                if_stack_top++;
                deb_else = qc-1;
                fin_if = qc-1;
                deb_else_stack[if_stack_top] = deb_else;
                fin_if_stack[if_stack_top] = fin_if;

              }
;

IF_BLOCK: IF_PREFIX acco INSTRUCTION_LIST accf
              {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
                deb_else = deb_else_stack[if_stack_top];
                fin_if = fin_if_stack[if_stack_top];
                if_stack_top--;
              }
;

IF_ELSE_BLOCK: IF_BLOCK kwELSE acco INSTRUCTION_LIST accf 
                  {
                    sprintf(i,"%d",qc);
                    mise_jr_quad(fin_if,2,i);

                    deb_else = deb_else_stack[if_stack_top];
                    fin_if = fin_if_stack[if_stack_top];
                    if_stack_top--;
                  }
              | IF_BLOCK  
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

              for_stack_top++;
              for_deb_stack[for_stack_top] = deb_for;
              for_fin_stack[for_stack_top] = fin_for;

              deb_for = qc + 1;
              fin_for = qc + 1;
            }
          FOR_LOOP_SIGNATURE acco INSTRUCTION_LIST accf
            {
              sprintf(i,"%d",deb_for);
              remplir_quad("BR",i,"<vide>","<vide>");
              sprintf(i,"%d",qc);
              mise_jr_quad(fin_for,2,i);

              deb_for = for_deb_stack[for_stack_top];
              fin_for = for_fin_stack[for_stack_top];
              for_stack_top--;

              exit_scope();
            }
;

COUNTER_INIT: NUMERIC_TYPE IDF 
                {
                  strcpy(current_IDF,$2); 
                  search($2,"Variable",$1, "-1", "-", "0", "-",current_scope, 0);
                }
              OPTIONAL_ASSIGN
            | OBJECT_ACCESS 
                {
                  strcpy(current_IDF,get_element($1.object_path,false));
                }
              OPTIONAL_ASSIGN
            | /* empty */

FOR_LOOP_SIGNATURE: FOR_LOOP_LIST
                  | FOR_LOOP_CONDITIONAL
;

FOR_LOOP_LIST: po NUMERIC_TYPE IDF dp OBJECT_ACCESS pf 
                  {
                    search($3,"Variable",$2, "NULL", "-", "0", "-",current_scope, 0);
                  }
              | po OBJECT_ACCESS dp OBJECT_ACCESS pf
;

FOR_LOOP_CONDITIONAL: po COUNTER_INIT pvg EXPRESSION pvg INCREMENT pf
                        {
                          if (strcmp($4.type, "boolean") != 0) {
                            printf("\nFile '%s', semantic error, line %d, column %d, entity '%s' is not a boolean type.\n",file_name, nb_line, nb_character, $4.value);
                            YYABORT;
                          }
                        }
;

// --------------------------------- WHILE LOOP BLOCK -----------------------------------------------------------------------------------
WHILE_PREFIX: kwWHILE po EXPRESSION pf 
                {
                  if (strcmp($3.type, "boolean") != 0) {
                    printf("\nFile '%s', semantic error, line %d, column %d, entity '%s' is not a boolean type.\n",file_name, nb_line, nb_character, $3.value);
                    YYABORT;
                  }
                  while_stack_top++;
                  while_deb_stack[while_stack_top] = deb_while;
                  while_fin_stack[while_stack_top] = fin_while;

                  deb_while = qc - 1;
                  fin_while = qc - 1;
                }
;

WHILE_LOOP: WHILE_PREFIX acco INSTRUCTION_LIST accf 
                {
                  sprintf(i,"%d",deb_while);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_while,2,i);

                  deb_while = while_deb_stack[while_stack_top];
                  fin_while = while_fin_stack[while_stack_top];
                  while_stack_top--;
                }
;
// --------------------------------- DO WHILE LOOP BLOCK -----------------------------------------------------------------------------------

DOWHILE_PREFIX: kwDO 
                  {
                    do_stack_top++;
                    do_deb_stack[do_stack_top] = deb_dowhile;

                    deb_dowhile = qc;
                  }
;

DOWHILE_LOOP: DOWHILE_PREFIX acco INSTRUCTION_LIST accf kwWHILE po EXPRESSION pf
                  {
                    if (strcmp($7.type, "boolean") != 0) {
                    printf("\nFile '%s', semantic error, line %d, column %d, entity '%s' is not a boolean type.\n",file_name, nb_line, nb_character, $7.value);
                    YYABORT;
                    }

                    sprintf(i,"%d",deb_dowhile);
                    mise_jr_quad(qc-1,2,i);

                    deb_dowhile = do_deb_stack[do_stack_top];
                    do_stack_top--;
                  }
; 

// --------------------------------- SWITCH CASE BLOCK -----------------------------------------------------------------------------------

SWITCH_CASE_BLOCK: kwSWITCH po OBJECT_ACCESS pf acco CASE_LIST OPTIONAL_DEFAULT accf
;

CASE_LIST: kwCASE EXPRESSION dp INSTRUCTION_LIST kwBREAK pvg CASE_LIST
         | kwCASE EXPRESSION dp INSTRUCTION_LIST kwBREAK pvg
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

RETURN: kwRETURN EXPRESSION 
          {
            if (strcmp(method_return_type, "void") == 0) {
                printf("\nFile '%s', semantic error, line %d, column %d: void method cannot return a value.\n",
                       file_name, nb_line, nb_character);
                YYABORT;
            }

            char *dst = getBaseType(method_return_type);
            char *src = getBaseType($2.type);
            if (strcmp(dst, src) != 0) {
                printf("\nFile '%s', semantic error, line %d, column %d: return type '%s' does not match method return type '%s'.\n",
                       file_name, nb_line, nb_character, $2.type, method_return_type);
                YYABORT;
            }
            free(dst);
            free(src);

            method_return_qc[method_count] = qc;
            remplir_quad("BR", " ", "<vide>", "<vide>");
            method_count++;
            remplir_quad("BR", " ", "<vide>", "<vide>");

            has_returned=true;
          }
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
  int i;
  for(i=0;i<method_count;i++){
    printf("\n%s %d %d\n",method_names[i],method_entry_qc[i],method_return_qc[i]);
  }
  affiche_quad_simple();
  optimize();
  generate_asm_file("example.asm");
  liberer_table();
  return 0;
}

int yywrap(){
  return 0;
}