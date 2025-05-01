#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int qc;

typedef struct qdr
{
	char operation[100]; // l'operation
	char opr1[100];		 // 1er operande
	char opr2[100];		 // 2eme operande
	char tempo[100];	 // temporaire
} qdr;

qdr quad[200];

// creation et remplissage du quadruplet
void remplir_quad(char opr[], char opr1[], char opr2[], char tempo[])
{
	strcpy(quad[qc].operation, opr);
	strcpy(quad[qc].opr1, opr1);
	strcpy(quad[qc].opr2, opr2);
	strcpy(quad[qc].tempo, tempo);

	qc++;
}

// mise a jour d'une colonne du quadruplet
void mise_jr_quad(int num_quad, int colonne_quad, char val[]) // au lieu de QUAD(num_quad)=(val,colone)
{
	if (colonne_quad == 1)
		strcpy(quad[num_quad].operation, val); // remplir la 1ere colonne
	else if (colonne_quad == 2)
		strcpy(quad[num_quad].opr1, val); // remplir la 2eme colonne
	else if (colonne_quad == 3)
		strcpy(quad[num_quad].opr2, val); // remplir la 3eme colonne
	else if (colonne_quad == 4)
		strcpy(quad[num_quad].tempo, val); // remplir la 4eme colonne
}

void affiche_quad()
{
	printf("\n~~~~~~~~~~~~~~~~~~~~ Les Quadruplets ~~~~~~~~~~~~~~~~~~~~\n");

	int i;

	for (i = 0; i < qc; i++)
	{

		printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )", i, quad[i].operation, quad[i].opr1, quad[i].opr2, quad[i].tempo);
		printf("\n--------------------------------------------\n");
	}
}

// 1. Propagation de copie (Copy Propagation) with logging
void copy_propagation()
{
	struct Entry
	{
		char *dest;
		char *src;
	};
	struct Entry *copies = NULL;
	int count = 0;
	int i, j;

	// First pass: Build copy map and replace uses
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		if (strcmp(q->operation, "=") == 0 && strcmp(q->opr2, "<vide>") == 0)
		{
			copies = (struct Entry *)realloc(copies, (count + 1) * sizeof(struct Entry));
			copies[count].dest = strdup(q->tempo);
			copies[count].src = strdup(q->opr1);
			count++;
		}
		else
		{
			// Track changes for logging
			char orig_opr1[100], orig_opr2[100];
			strcpy(orig_opr1, q->opr1);
			strcpy(orig_opr2, q->opr2);

			for (j = 0; j < count; ++j)
			{
				if (strcmp(q->opr1, copies[j].dest) == 0)
				{
					strcpy(q->opr1, copies[j].src);
				}
				if (strcmp(q->opr2, copies[j].dest) == 0)
				{
					strcpy(q->opr2, copies[j].src);
				}
			}

			// Print if any changes occurred
			if (strcmp(orig_opr1, q->opr1) != 0)
			{
				printf("Copy Propagation: Quad %d - Replaced %s with %s in opr1\n",
					   i, orig_opr1, q->opr1);
			}
			if (strcmp(orig_opr2, q->opr2) != 0)
			{
				printf("Copy Propagation: Quad %d - Replaced %s with %s in opr2\n",
					   i, orig_opr2, q->opr2);
			}
		}
	}

	// Second pass: Remove redundant copy assignments
	int new_qc = 0;
	qdr new_quad[200];
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		if (strcmp(q->operation, "=") == 0 && strcmp(q->opr2, "<vide>") == 0)
		{
			char *dest = q->tempo;
			int used = 0;
			for (j = i + 1; j < qc; ++j)
			{
				if (strcmp(quad[j].opr1, dest) == 0 || strcmp(quad[j].opr2, dest) == 0)
				{
					used = 1;
					break;
				}
			}
			if (!used)
			{
				printf("Copy Propagation: Deleting Quad %d - %s = %s\n",
					   i, q->tempo, q->opr1);
				continue; // Skip this quad
			}
		}
		new_quad[new_qc++] = *q;
	}
	memcpy(quad, new_quad, new_qc * sizeof(qdr));
	qc = new_qc;

	// Cleanup
	for (i = 0; i < count; ++i)
	{
		free(copies[i].dest);
		free(copies[i].src);
	}
	free(copies);
}

// 2. Propagation d’expression (Expression Propagation) with logging
void expression_propagation()
{
	struct Expr
	{
		char *var;
		char *op;
		char *op1;
		char *op2;
	};
	struct Expr *exprs = NULL;
	int count = 0;
	int i, j;

	// First pass: Collect expressions
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		if (strcmp(q->operation, "=") != 0 && strcmp(q->operation, "BR") != 0)
		{
			exprs = (struct Expr *)realloc(exprs, (count + 1) * sizeof(struct Expr));
			exprs[count].var = strdup(q->tempo);
			exprs[count].op = strdup(q->operation);
			exprs[count].op1 = strdup(q->opr1);
			exprs[count].op2 = strdup(q->opr2);
			count++;
		}
	}

	// Second pass: Replace uses and log
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		for (j = 0; j < count; ++j)
		{
			if (strcmp(q->opr1, exprs[j].var) == 0)
			{
				printf("Expression Propagation: Quad %d - Replaced %s with %s %s %s\n",
					   i, q->opr1, exprs[j].op1, exprs[j].op, exprs[j].op2);
				strcpy(q->opr1, exprs[j].op1);
				// Optionally update operation if needed
			}
			if (strcmp(q->opr2, exprs[j].var) == 0)
			{
				printf("Expression Propagation: Quad %d - Replaced %s with %s %s %s\n",
					   i, q->opr2, exprs[j].op1, exprs[j].op, exprs[j].op2);
				strcpy(q->opr2, exprs[j].op1);
			}
		}
	}

	// Cleanup
	for (i = 0; i < count; ++i)
	{ /* free logic */
	}
}

// 3. Élimination d’expressions redondantes with logging
void eliminate_redundant_expressions()
{
	struct ExprEntry
	{
		char op[100], opr1[100], opr2[100], temp[100];
	};
	struct ExprEntry *expressions = NULL;
	int size = 0;
	int i, j;

	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		if (strcmp(q->operation, "=") == 0 || strcmp(q->operation, "BR") == 0)
			continue;

		for (j = 0; j < size; ++j)
		{
			if (strcmp(expressions[j].op, q->operation) == 0 &&
				strcmp(expressions[j].opr1, q->opr1) == 0 &&
				strcmp(expressions[j].opr2, q->opr2) == 0)
			{
				printf("Redundant Expr Elimination: Quad %d - Replaced with %s\n",
					   i, expressions[j].temp);
				strcpy(q->operation, "=");
				strcpy(q->opr1, expressions[j].temp);
				strcpy(q->opr2, "<vide>");
				break;
			}
		}

		// Add to tracked expressions
		expressions = (struct ExprEntry *)realloc(expressions, (size + 1) * sizeof(struct ExprEntry));
		strcpy(expressions[size].op, q->operation);
		strcpy(expressions[size].opr1, q->opr1);
		strcpy(expressions[size].opr2, q->opr2);
		strcpy(expressions[size].temp, q->tempo);
		size++;
	}
	free(expressions);
}

// 4. Simplification algébrique with logging
void algebraic_simplification()
{
	int i;
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		char original_op[100], original_opr1[100], original_opr2[100];
		strcpy(original_op, q->operation);
		strcpy(original_opr1, q->opr1);
		strcpy(original_opr2, q->opr2);

		if (strcmp(q->operation, "+") == 0 && strcmp(q->opr2, "0") == 0)
		{
			printf("Algebraic Simplification: Quad %d - Simplified %s + 0 to %s\n",
				   i, q->opr1, q->opr1);
			strcpy(q->operation, "=");
			strcpy(q->opr2, "<vide>");
		}
		else if (strcmp(q->operation, "*") == 0 && strcmp(q->opr2, "1") == 0)
		{
			printf("Algebraic Simplification: Quad %d - Simplified %s * 1 to %s\n",
				   i, q->opr1, q->opr1);
			strcpy(q->operation, "=");
			strcpy(q->opr2, "<vide>");
		}

		// Add more simplifications here
	}
}

// 5. Élimination de code inutile with logging
void dead_code_elimination()
{
	int used[200] = {0};
	int i, j;

	// Mark used variables
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		if (strcmp(q->opr1, "<vide>") != 0)
			used[i] = 1;
		if (strcmp(q->opr2, "<vide>") != 0)
			used[i] = 1;
	}

	// Remove unused quads
	int new_qc = 0;
	qdr new_quad[200];
	for (i = 0; i < qc; ++i)
	{
		qdr *q = &quad[i];
		if (strcmp(q->tempo, "<vide>") != 0)
		{
			int is_used = 0;
			for (j = i + 1; j < qc; ++j)
			{
				if (strcmp(quad[j].opr1, q->tempo) == 0 || strcmp(quad[j].opr2, q->tempo) == 0)
				{
					is_used = 1;
					break;
				}
			}
			if (!is_used)
			{
				printf("Dead Code Elimination: Removing Quad %d - %s not used\n", i, q->tempo);
				continue;
			}
		}
		new_quad[new_qc++] = *q;
	}
	memcpy(quad, new_quad, new_qc * sizeof(qdr));
	qc = new_qc;
}
