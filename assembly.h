#ifndef ASSEMBLY_H
#define ASSEMBLY_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "quad.h"

// Global file pointer for the assembly file
static FILE *asm_file;

char *current_instance = NULL;

extern qdr quad[];
extern int qc;

int num_vars = 0;
typedef struct
{
    char *name;
    char *type;
    int size;
} VarInfo;

VarInfo variables[200];

// File management
void open_asm_file(const char *filename)
{
    asm_file = fopen(filename, "w");
    if (!asm_file)
    {
        perror("Failed to open assembly file");
        exit(1);
    }
}

void close_asm_file(void)
{
    if (asm_file)
    {
        fclose(asm_file);
        asm_file = NULL;
    }
}

void generate_title(const char *program_name)
{
    fprintf(asm_file, "TITLE %s\n", program_name);
}

void generate_stack_segment(void)
{
    fprintf(asm_file, "PILE SEGMENT STACK\n");
    fprintf(asm_file, "    DW 100 DUP(?)\n");
    fprintf(asm_file, "    base_pile EQU $\n");
    fprintf(asm_file, "PILE ENDS\n\n");
}

void generate_data_segment_start(void)
{
    fprintf(asm_file, "DONNEE SEGMENT\n");
}

void declare_variable(const char *name, const char *asm_type, int size)
{
    if (size > 1)
    {
        fprintf(asm_file, "    %s %s %d DUP (?)\n", name, asm_type, size);
    }
    else
    {
        fprintf(asm_file, "    %s %s ?\n", name, asm_type);
    }
}

void generate_data_segment_end(void)
{
    fprintf(asm_file, "DONNEE ENDS\n\n");
}

void generate_code_segment_start(void)
{
    fprintf(asm_file, "LECODE SEGMENT\n");
    fprintf(asm_file, "MAIN:\n");
    fprintf(asm_file, "    ASSUME CS:LECODE, DS:DONNEE\n");
    fprintf(asm_file, "    MOV AX, DONNEE\n");
    fprintf(asm_file, "    MOV DS, AX\n");
    fprintf(asm_file, "    ASSUME SS : PILE\n");
    fprintf(asm_file, "    MOV AX, PILE\n");
    fprintf(asm_file, "    MOV SS,AX\n");
    fprintf(asm_file, "    MOV SP,base_pile\n");
}

void generate_code_segment_end(void)
{
    fprintf(asm_file, "LECODE ENDS\n");
}

void generate_end(void)
{
    fprintf(asm_file, "END MAIN\n");
}

// Utility functions
int is_number(const char *str)
{
    int i;
    for (i = 0; str[i]; i++)
    {
        if (!isdigit((unsigned char)str[i]))
            return 0;
    }
    return 1;
}

int is_variable(const char *str)
{
    if (strcmp(str, "<vide>") == 0)
        return 0;
    if (is_number(str))
        return 0;
    return 1;
}

const char *get_jump_instruction(const char *operation)
{
    if (strcmp(operation, "BE") == 0)
        return "JE";
    if (strcmp(operation, "BNE") == 0)
        return "JNE";
    if (strcmp(operation, "BG") == 0)
        return "JG";
    if (strcmp(operation, "BGE") == 0)
        return "JGE";
    if (strcmp(operation, "BL") == 0)
        return "JL";
    if (strcmp(operation, "BLE") == 0)
        return "JLE";
    return NULL;
}

// Code generation helpers
void generate_label(const char *label)
{
    fprintf(asm_file, "%s:\n", label);
}

int is_byte_variable(const char *name)
{
    ElementNode *current = table.element_fifo_head;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            if (startsWith(current->type, "char") || startsWith(current->type, "boolean"))
            {
                return 1; // Byte
            }
            return 0; // Word
        }
        current = current->fifo_next;
    }
    return 0; // Default to word if not found
}

// Function to generate assignment code
void generate_assignment(const char *dest, const char *src)
{
    if (is_byte_variable(dest))
    {
        if (is_byte_variable(src))
        {
            fprintf(asm_file, "    MOV AL, %s\n", src);
            fprintf(asm_file, "    MOV %s, AL\n", dest);
        }
        else
        {
            fprintf(asm_file, "    MOV AX, %s\n", src);
            fprintf(asm_file, "    MOV %s, AL\n", dest);
        }
    }
    else
    {
        if (is_byte_variable(src))
        {
            fprintf(asm_file, "    MOV AL, %s\n", src);
            fprintf(asm_file, "    MOV %s, AX\n", dest);
        }
        else
        {
            fprintf(asm_file, "    MOV AX, %s\n", src);
            fprintf(asm_file, "    MOV %s, AX\n", dest);
        }
    }
}

// Function to generate array access (e.g., t[i] = value or value = t[i])
void generate_array_access(FILE *asm_file, const char *array, const char *index, const char *value, int is_store)
{
    int is_byte = is_byte_variable(array);
    fprintf(asm_file, "    MOV SI, %s\n", index); // Load index into SI
    if (!is_byte)
    {
        fprintf(asm_file, "    ADD SI, SI\n"); // Scale by 2 for word elements
    }
    if (is_store)
    {
        if (is_byte)
        {
            fprintf(asm_file, "    MOV AL, %s\n", value);     // Load value into AL
            fprintf(asm_file, "    MOV %s[SI], AL\n", array); // Store AL into array[i]
        }
        else
        {
            fprintf(asm_file, "    MOV AX, %s\n", value);     // Load value into AX
            fprintf(asm_file, "    MOV %s[SI], AX\n", array); // Store AX into array[i]
        }
    }
    else
    {
        if (is_byte)
        {
            fprintf(asm_file, "    MOV AL, %s[SI]\n", array); // Load array[i] into AL
        }
        else
        {
            fprintf(asm_file, "    MOV AX, %s[SI]\n", array); // Load array[i] into AX
        }
    }
}

void generate_add(const char *dest, const char *src)
{
    fprintf(asm_file, "    ADD %s, %s\n", dest, src);
}

void generate_sub(const char *dest, const char *src)
{
    fprintf(asm_file, "    SUB %s, %s\n", dest, src);
}

void generate_cmp(const char *op1, const char *op2)
{
    fprintf(asm_file, "    CMP %s, %s\n", op1, op2);
}

void generate_jmp(const char *label)
{
    fprintf(asm_file, "    JMP %s\n", label);
}

void generate_conditional_jump(const char *jump_inst, const char *label)
{
    fprintf(asm_file, "    %s %s\n", jump_inst, label);
}

// Quad code generation
void generate_code_for_quad(const qdr *q, int index)
{
    char *mapped_opr1 = strdup(q->opr1);
    char *mapped_opr2 = strdup(q->opr2);
    char *mapped_tempo = strdup(q->tempo);

    if (current_instance)
    {
        if (strncmp(q->opr1, "this.", 5) == 0)
        {
            free(mapped_opr1);
            mapped_opr1 = malloc(strlen(current_instance) + strlen(q->opr1) - 4);
            sprintf(mapped_opr1, "%s_%s", current_instance, q->opr1 + 5);
        }
        if (strncmp(q->opr2, "this.", 5) == 0)
        {
            free(mapped_opr2);
            mapped_opr2 = malloc(strlen(current_instance) + strlen(q->opr2) - 4);
            sprintf(mapped_opr2, "%s_%s", current_instance, q->opr2 + 5);
        }
        if (strncmp(q->tempo, "this.", 5) == 0)
        {
            free(mapped_tempo);
            mapped_tempo = malloc(strlen(current_instance) + strlen(q->tempo) - 4);
            sprintf(mapped_tempo, "%s_%s", current_instance, q->tempo + 5);
        }
    }

    if (strcmp(q->operation, "NEW") == 0)
    {
        free(current_instance);
        current_instance = strdup(q->tempo);
    }

    if (strcmp(q->operation, "=") == 0)
    {
        if (strcmp(q->opr2, "<vide>") == 0)
        {
            generate_assignment(q->tempo, q->opr1);
        }
    }
    else if (strcmp(q->operation, "+") == 0)
    {
        fprintf(asm_file, "    MOV AX, %s\n", q->opr1);
        generate_add("AX", q->opr2);
        fprintf(asm_file, "    MOV %s, AX\n", q->tempo);
    }
    else if (strcmp(q->operation, "-") == 0)
    {
        fprintf(asm_file, "    MOV AX, %s\n", q->opr1);
        generate_sub("AX", q->opr2);
        fprintf(asm_file, "    MOV %s, AX\n", q->tempo);
    }
    else if (strcmp(q->operation, "*") == 0)
    {
        fprintf(asm_file, "    MOV AX, %s\n", q->opr1);
        if (is_number(q->opr2))
        {
            fprintf(asm_file, "    MOV BX, %s\n", q->opr2);
            fprintf(asm_file, "    IMUL BX\n");
        }
        else
        {
            fprintf(asm_file, "    IMUL %s\n", q->opr2);
        }
        fprintf(asm_file, "    MOV %s, AX\n", q->tempo);
    }
    else if (strcmp(q->operation, "/") == 0)
    {
        fprintf(asm_file, "    MOV AX, %s\n", q->opr1);
        if (is_number(q->opr2))
        {
            fprintf(asm_file, "    MOV BX, %s\n", q->opr2);
            fprintf(asm_file, "    IDIV BX\n");
        }
        else
        {
            fprintf(asm_file, "    IDIV %s\n", q->opr2);
        }
        fprintf(asm_file, "    MOV %s, AX\n", q->tempo);
    }
    else if (strcmp(q->operation, "BR") == 0)
    {
        char label[10];
        sprintf(label, "L%s", q->opr1);
        generate_jmp(label);
    }
    else
    {
        const char *jump_inst = get_jump_instruction(q->operation);
        if (jump_inst)
        {
            fprintf(asm_file, "    MOV AX, %s\n", q->opr1);
            generate_cmp("AX", q->opr2);
            char label[10];
            sprintf(label, "L%s", q->opr1);
            generate_conditional_jump(jump_inst, label);
        }
    }
}

// Function to add a variable if not already present
void add_variable(const char *name, const char *type, int size)
{
    int j;
    for (j = 0; j < num_vars; j++)
    {
        if (strcmp(variables[j].name, name) == 0)
        {
            return; // Already added
        }
    }
    variables[num_vars].name = strdup(name);
    variables[num_vars].type = strdup(type);
    variables[num_vars].size = size;
    num_vars++;
}

void get_asm_type_and_size(const char *var_type, char *asm_type, int *size)
{
    if (strstr(var_type, "char") || strstr(var_type, "boolean"))
    {
        strcpy(asm_type, "DB");
        *size = 1;
    }
    else
    { // int, double (simplified to 16-bit for 8086)
        strcpy(asm_type, "DW");
        *size = 1;
    }
    // For arrays, size should be parsed from symbol table (simplified here)
}

void generate_asm_file(const char *filename)
{
    int i;

    // Step 1: Collect main and global variables used in quadruples
    ElementNode *current = table.element_fifo_head;
    while (current != NULL)
    {
        if (strcmp(current->code, "Variable") == 0 || strcmp(current->code, "Attribute") == 0)
        {
            int is_used = 0;
            for (i = 0; i < qc; i++)
            {
                if (strcmp(quad[i].opr1, current->name) == 0 ||
                    strcmp(quad[i].opr2, current->name) == 0 ||
                    strcmp(quad[i].tempo, current->name) == 0)
                {
                    is_used = 1;
                    break;
                }
            }
            if (is_used)
            {
                char asm_type[10];
                int size;
                get_asm_type_and_size(current->type, asm_type, &size);
                if (atoi(current->dimensions) > 0)
                {
                    size = atoi(current->taille);
                }
                else
                {
                    size = 1;
                }
                add_variable(current->name, asm_type, size);
            }
        }
        current = current->fifo_next;
    }

    // Step 2: Collect temporaries from quadruples
    for (i = 0; i < qc; i++)
    {
        if (is_variable(quad[i].opr1) && strstr(quad[i].opr1, "T") == quad[i].opr1)
        {
            add_variable(quad[i].opr1, "DW", 1);
        }
        if (is_variable(quad[i].opr2) && strstr(quad[i].opr2, "T") == quad[i].opr2)
        {
            add_variable(quad[i].opr2, "DW", 1);
        }
        if (is_variable(quad[i].tempo) && strstr(quad[i].tempo, "T") == quad[i].tempo)
        {
            add_variable(quad[i].tempo, "DW", 1);
        }
    }

    // Step 3: Collect object attributes for instantiated objects
    for (i = 0; i < qc; i++)
    {
        if (strcmp(quad[i].operation, "NEW") == 0)
        {
            char *class_name = quad[i].opr1;
            char *instance_name = quad[i].tempo;

            current = table.element_fifo_head;
            while (current != NULL)
            {
                if (strcmp(current->code, "Attribute") == 0 && strstr(current->scope, class_name) != NULL)
                {
                    char attr_name[50];
                    snprintf(attr_name, sizeof(attr_name), "%s_%s", instance_name, current->name);
                    char asm_type[10];
                    int size;
                    get_asm_type_and_size(current->type, asm_type, &size);
                    if (atoi(current->dimensions) > 0)
                    {
                        size = atoi(current->taille);
                    }
                    else
                    {
                        size = 1;
                    }
                    add_variable(attr_name, asm_type, size);
                }
                current = current->fifo_next;
            }
        }
    }

    // Collect jump targets
    int *targets = calloc(qc, sizeof(int));
    if (!targets)
    {
        perror("Failed to allocate memory for targets");
        exit(1);
    }
    for (i = 0; i < qc; i++)
    {
        char *target_field = NULL;
        if (strcmp(quad[i].operation, "BR") == 0)
        {
            target_field = quad[i].opr1;
        }
        else if (get_jump_instruction(quad[i].operation))
        {
            target_field = quad[i].opr1;
        }
        if (target_field && is_number(target_field))
        {
            int target = atoi(target_field);
            if (target >= 0 && target < qc)
            {
                targets[target] = 1;
            }
        }
    }

    // Generate assembly file
    open_asm_file(filename);
    generate_title("prog");
    generate_stack_segment();
    generate_data_segment_start();
    for (i = 0; i < num_vars; i++)
    {
        declare_variable(variables[i].name, variables[i].type, variables[i].size);
    }
    generate_data_segment_end();
    generate_code_segment_start();

    // Generate code from quads
    for (i = 0; i < qc; i++)
    {
        if (targets[i])
        {
            char label[10];
            sprintf(label, "L%d", i);
            generate_label(label);
        }
        generate_code_for_quad(&quad[i], i);
    }

    // Exit program
    fprintf(asm_file, "LEND:           \n");
    fprintf(asm_file, "    MOV AH, 4Ch\n");
    fprintf(asm_file, "    INT 21h\n");

    generate_code_segment_end();
    generate_end();
    close_asm_file();

    // Clean up
    for (i = 0; i < num_vars; i++)
    {
        free(variables[i].name);
        free(variables[i].type);
    }
    free(targets);
    free(current_instance);
    current_instance = NULL;
}

#endif
