#ifndef ASSEMBLY_H
#define ASSEMBLY_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "quad.h"

// Global file pointer for the assembly file
static FILE *asm_file;

extern qdr quad[];
extern int qc; // Assumed global variable for number of quadruples

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

// Program structure
void generate_title(const char *program_name)
{
    fprintf(asm_file, "TITLE %s\n", program_name);
}

void generate_stack_segment(void)
{
    fprintf(asm_file, "PILE SEGMENT STACK\n");
    fprintf(asm_file, "    DW 100 DUP(?)\n");
    fprintf(asm_file, "PILE ENDS\n\n");
}

void generate_data_segment_start(void)
{
    fprintf(asm_file, "DONNEE SEGMENT\n");
}

void declare_variable(const char *name, const char *type, const char *initial_value)
{
    fprintf(asm_file, "    %s %s %s\n", name, type, initial_value);
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
    if (strcmp(operation, "BEQ") == 0)
        return "JE";
    if (strcmp(operation, "BNE") == 0)
        return "JNE";
    if (strcmp(operation, "BGT") == 0)
        return "JG";
    if (strcmp(operation, "BGE") == 0)
        return "JGE";
    if (strcmp(operation, "BLT") == 0)
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

void generate_assignment(const char *dest, const char *src)
{
    fprintf(asm_file, "    MOV AX, %s\n", src);
    fprintf(asm_file, "    MOV %s, AX\n", dest);
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
        fprintf(asm_file, "    IMUL %s\n", q->opr2);
        fprintf(asm_file, "    MOV %s, AX\n", q->tempo);
    }
    else if (strcmp(q->operation, "/") == 0)
    {
        fprintf(asm_file, "    MOV AX, %s\n", q->opr1);
        fprintf(asm_file, "    CWD\n");
        fprintf(asm_file, "    IDIV %s\n", q->opr2);
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
            sprintf(label, "L%s", q->tempo);
            generate_conditional_jump(jump_inst, label);
        }
    }
}

// Main assembly file generator
void generate_asm_file(const char *filename)
{
    // Collect variables from symbol table
    char *variables[100]; // Adjust size as needed
    int num_vars = 0;
    int i, j;
    ElementNode *current = table.element_fifo_head;
    while (current != NULL)
    {
        if (strcmp(current->code, "Variable") == 0)
        {
            variables[num_vars] = strdup(current->name);
            num_vars++;
        }
        current = current->fifo_next;
    }

    // Collect temporaries from quadruples
    for (i = 0; i < qc; i++)
    {
        if (is_variable(quad[i].opr1))
        {
            int found = 0;
            for (j = 0; j < num_vars; j++)
            {
                if (strcmp(variables[j], quad[i].opr1) == 0)
                {
                    found = 1;
                    break;
                }
            }
            if (!found)
            {
                variables[num_vars] = strdup(quad[i].opr1);
                num_vars++;
            }
        }
        if (is_variable(quad[i].opr2))
        {
            int found = 0;
            for (j = 0; j < num_vars; j++)
            {
                if (strcmp(variables[j], quad[i].opr2) == 0)
                {
                    found = 1;
                    break;
                }
            }
            if (!found)
            {
                variables[num_vars] = strdup(quad[i].opr2);
                num_vars++;
            }
        }
        if (is_variable(quad[i].tempo))
        {
            int found = 0;
            for (j = 0; j < num_vars; j++)
            {
                if (strcmp(variables[j], quad[i].tempo) == 0)
                {
                    found = 1;
                    break;
                }
            }
            if (!found)
            {
                variables[num_vars] = strdup(quad[i].tempo);
                num_vars++;
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
            target_field = quad[i].tempo;
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
        declare_variable(variables[i], "DW", "?");
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
    fprintf(asm_file, "    MOV AH, 4Ch\n");
    fprintf(asm_file, "    INT 21h\n");

    generate_code_segment_end();
    generate_end();
    close_asm_file();

    // Clean up
    for (i = 0; i < num_vars; i++)
    {
        free(variables[i]);
    }
    free(targets);
}

#endif
