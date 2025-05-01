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

// Helper function for logging changes
void log_change(int idx, const char *action, const char *details)
{
	printf("Quad %3d: %-30s | %s\n", idx, action, details);
}

// 1. Copy Propagation
bool copy_propagation()
{
	bool changed = false;
	struct CopyEntry
	{
		char dest[100], src[100];
		int valid;
	} copies[100];
	int copy_count = 0;
	int i, j;

	for (i = 0; i < qc; i++)
	{
		qdr *q = &quad[i];

		// Invalidate copies if destination is modified
		for (j = 0; j < copy_count; j++)
		{
			if (strcmp(copies[j].dest, q->tempo) == 0)
			{
				copies[j].valid = 0;
			}
		}

		// Track new copy operations
		if (strcmp(q->operation, "=") == 0 &&
			strcmp(q->opr2, "<vide>") == 0 &&
			strcmp(q->tempo, "") != 0)
		{
			strcpy(copies[copy_count].dest, q->tempo);
			strcpy(copies[copy_count].src, q->opr1);
			copies[copy_count].valid = 1;
			copy_count++;
		}

		// Apply valid copies to operands
		for (j = 0; j < copy_count; j++)
		{
			if (copies[j].valid)
			{
				char old_opr1[100], old_opr2[100];
				int modified = 0;

				strcpy(old_opr1, q->opr1);
				strcpy(old_opr2, q->opr2);

				if (strcmp(q->opr1, copies[j].dest) == 0)
				{
					strcpy(q->opr1, copies[j].src);
					modified = 1;
				}
				if (strcmp(q->opr2, copies[j].dest) == 0)
				{
					strcpy(q->opr2, copies[j].src);
					modified = 1;
				}

				if (modified)
				{
					char details[256];
					snprintf(details, sizeof(details),
							 "Replaced [%s,%s] with [%s,%s]",
							 old_opr1, old_opr2, q->opr1, q->opr2);
					log_change(i, "COPY_PROPAGATION", details);
					changed = true;
				}
			}
		}
	}
	return changed;
}

// 2. Expression Propagation
bool expression_propagation()
{
	bool changed = false;
	struct ExprEntry
	{
		char var[100], op[100], op1[100], op2[100];
	} exprs[100];
	int expr_count = 0;
	int i, j;

	for (i = 0; i < qc; i++)
	{
		qdr *q = &quad[i];

		// Track expressions (ignore copies and control flow)
		if (strcmp(q->operation, "=") != 0 &&
			strcmp(q->operation, "BR") != 0 &&
			strcmp(q->operation, "BGE") != 0)
		{
			strcpy(exprs[expr_count].var, q->tempo);
			strcpy(exprs[expr_count].op, q->operation);
			strcpy(exprs[expr_count].op1, q->opr1);
			strcpy(exprs[expr_count].op2, q->opr2);
			expr_count++;
		}

		// Propagate expressions
		for (j = 0; j < expr_count; j++)
		{
			char new_expr[200];
			sprintf(new_expr, "(%s %s %s)",
					exprs[j].op1, exprs[j].op, exprs[j].op2);

			if (strcmp(q->opr1, exprs[j].var) == 0)
			{
				char details_op1[256];
				snprintf(details_op1, sizeof(details_op1), "Replaced %s with %s", exprs[j].var, new_expr);
				strcpy(q->opr1, new_expr);
				log_change(i, "EXPR_PROPAGATION", details_op1);
				changed = true;
			}
			if (strcmp(q->opr2, exprs[j].var) == 0)
			{
				char details_op2[256];
				snprintf(details_op2, sizeof(details_op2), "Replaced %s with %s", exprs[j].var, new_expr);
				strcpy(q->opr2, new_expr);
				log_change(i, "EXPR_PROPAGATION", details_op2);
				changed = true;
			}
		}
	}
	return changed;
}

// 3. Redundant Expression Elimination
bool eliminate_redundant_expressions()
{
	bool changed = false;
	struct RedundantExpr
	{
		char op[100], op1[100], op2[100], temp[100];
	} expr_table[100];
	int expr_count = 0;
	int i, j;

	for (i = 0; i < qc; i++)
	{
		qdr *q = &quad[i];

		if (strcmp(q->operation, "=") == 0 ||
			strcmp(q->operation, "BR") == 0)
			continue;

		// Check for existing equivalent expression
		for (j = 0; j < expr_count; j++)
		{
			if (strcmp(expr_table[j].op, q->operation) == 0 &&
				strcmp(expr_table[j].op1, q->opr1) == 0 &&
				strcmp(expr_table[j].op2, q->opr2) == 0)
			{

				// Replace with previous result
				strcpy(q->operation, "=");
				strcpy(q->opr1, expr_table[j].temp);
				strcpy(q->opr2, "<vide>");

				char details[256];
				snprintf(details, sizeof(details), "Replaced with %s", expr_table[j].temp);
				log_change(i, "REDUNDANT_EXPR_ELIM", details);
				changed = true;
				break;
			}
		}

		// Add to expression table
		strcpy(expr_table[expr_count].op, q->operation);
		strcpy(expr_table[expr_count].op1, q->opr1);
		strcpy(expr_table[expr_count].op2, q->opr2);
		strcpy(expr_table[expr_count].temp, q->tempo);
		expr_count++;
	}
	return changed;
}

// 4. Algebraic Simplification
bool algebraic_simplification()
{
	bool changed = false;
	int i;

	for (i = 0; i < qc; i++)
	{
		qdr *q = &quad[i];
		char original[200], simplified[200];
		sprintf(original, "%s %s %s", q->opr1, q->operation, q->opr2);

		// x = y + 0 → x = y
		if (strcmp(q->operation, "+") == 0 && strcmp(q->opr2, "0") == 0)
		{
			strcpy(q->operation, "=");
			strcpy(q->opr2, "<vide>");
			strcpy(simplified, q->opr1);
			changed = true;
		}
		// x = y * 1 → x = y
		else if (strcmp(q->operation, "*") == 0 && strcmp(q->opr2, "1") == 0)
		{
			strcpy(q->operation, "=");
			strcpy(q->opr2, "<vide>");
			strcpy(simplified, q->opr1);
			changed = true;
		}
		// x = 0 + y → x = y
		else if (strcmp(q->operation, "+") == 0 && strcmp(q->opr1, "0") == 0)
		{
			strcpy(q->operation, "=");
			strcpy(q->opr1, q->opr2);
			strcpy(q->opr2, "<vide>");
			strcpy(simplified, q->opr1);
			changed = true;
		}

		if (changed)
		{

			char details[256];
			snprintf(details, sizeof(details), "%s → %s", original, simplified);
			log_change(i, "ALGEBRAIC_SIMPLIFICATION", details);
		}
	}
	return changed;
}

// 5. Dead Code Elimination
bool dead_code_elimination()
{
	bool changed = false;
	int used[200] = {0};
	int i, j;

	// Mark used temporaries (backward analysis)
	for (i = qc - 1; i >= 0; i--)
	{
		qdr *q = &quad[i];

		// Mark operands as used
		if (strcmp(q->opr1, "<vide>") != 0)
		{
			for (j = 0; j < qc; j++)
			{
				if (strcmp(quad[j].tempo, q->opr1) == 0)
				{
					used[j] = 1;
				}
			}
		}
		if (strcmp(q->opr2, "<vide>") != 0)
		{
			for (j = 0; j < qc; j++)
			{
				if (strcmp(quad[j].tempo, q->opr2) == 0)
				{
					used[j] = 1;
				}
			}
		}
	}

	// Remove unused quads
	int new_qc = 0;
	qdr new_quad[200];
	for (i = 0; i < qc; i++)
	{
		if (used[i] || strcmp(quad[i].operation, "BR") == 0 ||
			strcmp(quad[i].operation, "BGE") == 0)
		{
			new_quad[new_qc++] = quad[i];
		}
		else
		{
			char details[256];
			snprintf(details, sizeof(details), "Removed %s = ...", quad[i].tempo);
			log_change(i, "DEAD_CODE_ELIMINATION", details);
			changed = true;
		}
	}

	memcpy(quad, new_quad, new_qc * sizeof(qdr));
	qc = new_qc;
	return changed;
}

// Optimization driver
void optimize()
{
	int iteration = 1;
	bool changed;

	do
	{
		printf("\n\n\n=== Optimization Pass %d ===\n", iteration++);
		changed = false;

		printf("\n\n=== COPY PROPAGATION ===\n\n");
		changed |= copy_propagation();
		printf("\n\n=== EXPRESSION PROPAGATION ===\n\n");
		changed |= expression_propagation();
		printf("\n\n=== REDUNDANT EXPR ELIMINATION ===\n\n");
		changed |= eliminate_redundant_expressions();
		printf("\n\n=== ALGEBRAIC SIMPLIFICATION ===\n\n");
		changed |= algebraic_simplification();
		printf("\n\n=== DEAD CODE ELIMINATION ===\n\n");
		changed |= dead_code_elimination();

	} while (changed);

	printf("\nNo more optimizations possible\n");
}
