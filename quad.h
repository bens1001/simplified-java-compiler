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

#define MAX_QUADS 200
qdr quad[MAX_QUADS];

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

void affiche_quad_simple()
{
	int i;

	printf("\n");
	for (i = 0; i < qc; i++)
	{
		if (strcmp(quad[i].operation, "+") == 0 || strcmp(quad[i].operation, "-") == 0 || strcmp(quad[i].operation, "*") == 0 || strcmp(quad[i].operation, "/") == 0)
		{
			printf("\n%d) %s = %s %s %s ", i, quad[i].tempo, quad[i].opr1, quad[i].operation, quad[i].opr2);
		}
		else if (strcmp(quad[i].operation, "=") == 0)
		{
			printf("\n%d) %s = %s ", i, quad[i].tempo, quad[i].opr1);
		}
	}
	printf("\n\n");
}

void eliminate_empty_branches()
{
	int i = 0, k;
	while (i < qc)
	{
		if (strcmp(quad[i].operation, "BR") == 0 &&
			strcmp(quad[i].opr1, " ") == 0 &&
			strcmp(quad[i].opr2, "<vide>") == 0 &&
			strcmp(quad[i].tempo, "<vide>") == 0)
		{
			printf("EMPTY BRANCH ELIMINATION: Removed quadruple %d ( BR , , <vide> , <vide> )\n", i);

			for (k = i; k < qc - 1; k++)
			{
				quad[k] = quad[k + 1];
			}
			qc--;
		}
		else
		{
			i++;
		}
	}
}

// Flag indiquant s'il y a eu modification
static int changed;

// 1. Propagation de copie
void propagation_copie()
{
	int i, j;
	for (i = 0; i < qc; i++)
	{
		if (strcmp(quad[i].operation, "=") == 0 && strlen(quad[i].opr2) == 0)
		{
			// pattern: tempo = opr1
			char src[100];
			strcpy(src, quad[i].opr1);
			char dst[100];
			strcpy(dst, quad[i].tempo);

			// Skip propagation if dst is "<vide>"
			if (strcmp(dst, "<vide>") == 0)
				continue;

			for (j = i + 1; j < qc; j++)
			{
				if (strcmp(quad[j].opr1, dst) == 0)
				{
					printf("COPY PROPAGATION: In quadruple %d, replaced '%s' with '%s' in operand 1\n", j, dst, src);
					mise_jr_quad(j, 2, src);
					changed = 1;
					// affiche_quad_simple();
				}
				if (strcmp(quad[j].opr2, dst) == 0)
				{
					printf("COPY PROPAGATION: In quadruple %d, replaced '%s' with '%s' in operand 2\n", j, dst, src);
					mise_jr_quad(j, 3, src);
					changed = 1;
					// affiche_quad_simple();
				}
			}
		}
	}
}

// 2. Élimination d'expressions redondantes
void elimination_expr_redondantes()
{
	int i, j;
	for (i = 0; i < qc; i++)
	{
		for (j = i + 1; j < qc; j++)
		{
			if (strcmp(quad[i].operation, quad[j].operation) == 0 &&
				strcmp(quad[i].opr1, quad[j].opr1) == 0 &&
				strcmp(quad[i].opr2, quad[j].opr2) == 0 &&
				strcmp(quad[i].operation, "=") != 0)
			{
				// Skip if the temporary is "<vide>"
				if (strcmp(quad[j].tempo, "<vide>") == 0)
					continue;

				// Même opération et mêmes opérandes
				char oldt[100];
				strcpy(oldt, quad[j].tempo);
				char newt[100];
				strcpy(newt, quad[i].tempo);
				printf("REDUNDANT EXPR ELIMINATION: In quadruple %d, replaced temporary '%s' with '%s'\n", j, oldt, newt);
				// transforme en copie
				mise_jr_quad(j, 1, "=");
				mise_jr_quad(j, 2, newt);
				mise_jr_quad(j, 3, "");
				changed = 1;
				// affiche_quad_simple();
			}
		}
	}
}

// 3. Propagation d'expression
void propagation_expression()
{
	int i, j, k;
	for (i = 0; i < qc; i++)
	{
		// Check if the quadruple defines a temporary with a simple assignment or operation
		if (quad[i].tempo[0] != 'T')
			continue; // Skip if not a temporary
		char temp[100];
		strcpy(temp, quad[i].tempo);

		// Count uses of this temporary
		int use_count = 0;
		int use_index = -1;
		for (j = i + 1; j < qc; j++)
		{
			if (strcmp(quad[j].opr1, temp) == 0 || strcmp(quad[j].opr2, temp) == 0)
			{
				use_count++;
				use_index = j;
				if (use_count > 1)
					break; // More than one use, stop checking
			}
		}

		// If used exactly once, try to inline
		if (use_count == 1 && use_index != -1)
		{
			// Check if the temporary is used in a binary operation
			if ((strcmp(quad[use_index].operation, "+") == 0 ||
				 strcmp(quad[use_index].operation, "-") == 0 ||
				 strcmp(quad[use_index].operation, "*") == 0 ||
				 strcmp(quad[use_index].operation, "/") == 0) &&
				(strcmp(quad[use_index].opr1, temp) == 0 || strcmp(quad[use_index].opr2, temp) == 0))
			{

				// Ensure no modification to variables in the expression between i and use_index
				bool safe = true;
				char base_var[100] = "";
				if (strcmp(quad[i].operation, "=") == 0)
					strcpy(base_var, quad[i].opr1);
				else
					strcpy(base_var, quad[i].opr1); // Simplistic; assumes opr1 is the base variable

				for (k = i + 1; k < use_index; k++)
				{
					if (strcmp(quad[k].tempo, base_var) == 0)
					{
						safe = false;
						break;
					}
				}

				if (safe)
				{
					// Inline the expression
					if (strcmp(quad[i].operation, "=") == 0)
					{ // Simple assignment
						if (strcmp(quad[use_index].opr1, temp) == 0)
						{
							mise_jr_quad(use_index, 2, quad[i].opr1);
						}
						else
						{
							mise_jr_quad(use_index, 3, quad[i].opr1);
						}
						printf("EXPRESSION PROPAGATION: Inlined '%s = %s' into quadruple %d\n", temp, quad[i].opr1, use_index);
						// affiche_quad_simple();
					}
				}
			}
		}
	}
}

int is_constant(char *str)
{
	int i;
	for (i = 0; str[i]; i++)
	{
		if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

// 4. Simplification algébrique
void simplification_algebrique()
{
	int i, j, k;
	for (i = 0; i < qc; i++)
	{

		if ((strcmp(quad[i].operation, "+") == 0 || strcmp(quad[i].operation, "-") == 0))
		{
			// Simplifying x + 0 or x - 0 to x
			if (strcmp(quad[i].opr2, "0") == 0)
			{
				printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, simplified '%s %s 0' to '%s'\n", i, quad[i].opr1, quad[i].operation, quad[i].opr1);
				mise_jr_quad(i, 1, "=");
				mise_jr_quad(i, 2, quad[i].opr1);
				mise_jr_quad(i, 3, "");
				changed = 1;
				// affiche_quad_simple();
			}
			// Simplifying 0 + x to x
			else if (strcmp(quad[i].opr1, "0") == 0 && strcmp(quad[i].operation, "+") == 0)
			{
				printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, simplified '0 %s %s' to '%s'\n", i, quad[i].opr2, quad[i].operation, quad[i].opr2);
				mise_jr_quad(i, 1, "=");
				mise_jr_quad(i, 2, quad[i].opr2);
				mise_jr_quad(i, 3, "");
				changed = 1;
				// affiche_quad_simple();
			}
		}
		if (strcmp(quad[i].operation, "*") == 0)
		{
			// Simplify x * 1 to x
			if (strcmp(quad[i].opr2, "1") == 0)
			{
				printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, simplified '%s * 1' to '%s'\n", i, quad[i].opr1, quad[i].opr1);
				mise_jr_quad(i, 1, "=");
				mise_jr_quad(i, 2, quad[i].opr1);
				mise_jr_quad(i, 3, "");
				changed = 1;
				// affiche_quad_simple();
			}
			// Simplify x * 0 to 0
			else if (strcmp(quad[i].opr2, "0") == 0)
			{
				printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, simplified '%s * 0' to '0'\n", i, quad[i].opr1);
				mise_jr_quad(i, 1, "=");
				mise_jr_quad(i, 2, "0");
				mise_jr_quad(i, 3, "");
				changed = 1;
				// affiche_quad_simple();
			}
			// Replacing multiplication with addition when the constant is the second operand (e.g., x * 2 -> x + x)
			else if (is_constant(quad[i].opr2))
			{
				int n = atoi(quad[i].opr2);
				if (n == 2)
				{
					char base[100];
					strcpy(base, quad[i].opr1);
					char result[100];
					strcpy(result, quad[i].tempo);

					// Replace T = x * 2 with T = x + x
					mise_jr_quad(i, 1, "+");
					mise_jr_quad(i, 2, base);
					mise_jr_quad(i, 3, base);

					printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, replaced '%s = %s * %d' with '%s = %s + %s'\n", i, result, base, n, result, base, base);
					changed = 1;
					// affiche_quad_simple();
				}
			}
			// Replacing multiplication with addition when the constant is the first operand (e.g., 2 * x -> x + x)
			else if (is_constant(quad[i].opr1))
			{
				int n = atoi(quad[i].opr1);
				if (n == 2)
				{
					char base[100];
					strcpy(base, quad[i].opr2);
					char result[100];
					strcpy(result, quad[i].tempo);

					// Replace T = x * 2 with T = x + x
					mise_jr_quad(i, 1, "+");
					mise_jr_quad(i, 2, base);
					mise_jr_quad(i, 3, base);

					printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, replaced '%s = %s * %d' with '%s = %s + %s'\n", i, result, base, n, result, base, base);
					changed = 1;
					// affiche_quad_simple();
				}
			}
		}

		// Simplifying chains like T = a + c1; U = T - c2
		if ((strcmp(quad[i].operation, "+") == 0 || strcmp(quad[i].operation, "-") == 0) &&
			is_constant(quad[i].opr2))
		{
			char temp[100];
			strcpy(temp, quad[i].tempo);
			int offset = atoi(quad[i].opr2);
			if (strcmp(quad[i].operation, "-") == 0)
				offset = -offset;

			for (j = i + 1; j < qc; j++)
			{
				if ((strcmp(quad[j].operation, "+") == 0 || strcmp(quad[j].operation, "-") == 0) &&
					strcmp(quad[j].opr1, temp) == 0 && is_constant(quad[j].opr2))
				{
					int offset2 = atoi(quad[j].opr2);
					if (strcmp(quad[j].operation, "-") == 0)
						offset2 = -offset2;
					int new_offset = offset + offset2;

					if (new_offset == 0)
					{
						printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, simplified '%s = %s %s %s' to '%s = %s' due to offset cancellation\n", j, quad[j].tempo, quad[j].opr1, quad[j].operation, quad[j].opr2, quad[j].tempo, quad[i].opr1);
						mise_jr_quad(j, 1, "=");
						mise_jr_quad(j, 2, quad[i].opr1);
						mise_jr_quad(j, 3, "");
						// affiche_quad_simple();
					}
					else
					{
						char new_const[100];
						sprintf(new_const, "%d", abs(new_offset));
						printf("ALGEBRAIC SIMPLIFICATION: In quadruple %d, simplified '%s = %s %s %s' to '%s = %s %s %s'\n", j, quad[j].tempo, quad[j].opr1, quad[j].operation, quad[j].opr2, quad[j].tempo, quad[i].opr1, new_offset >= 0 ? "+" : "-", new_const);
						mise_jr_quad(j, 1, new_offset >= 0 ? "+" : "-");
						mise_jr_quad(j, 2, quad[i].opr1);
						mise_jr_quad(j, 3, new_const);
						// affiche_quad_simple();
					}
					changed = 1;
					break;
				}
			}
		}
	}
}

// 5. Élimination de code inutile
void elimination_code_inutile()
{
	int i, j, k;
	for (i = 0; i < qc; i++)
	{
		bool used = false;
		for (j = 0; j < qc; j++)
		{
			if (j == i)
				continue;
			if (strcmp(quad[j].opr1, quad[i].tempo) == 0 || strcmp(quad[j].opr2, quad[i].tempo) == 0)
			{
				used = true;
				break;
			}
		}
		if (!used && quad[i].tempo[0] == 'T')
		{
			printf("DEAD CODE ELIMINATION: Removed quadruple %d defining unused temporary '%s'\n", i, quad[i].tempo);
			for (k = i; k < qc - 1; k++)
				quad[k] = quad[k + 1];
			qc--;
			changed = 1;
			i--;
			// affiche_quad_simple();
		}
	}
}

// Fonction principale d'optimisation
void optimize()
{
	int iteration = 0;
	eliminate_empty_branches();
	do
	{
		changed = 0;
		printf("\n--- Iteration %d ---\n", ++iteration);
		elimination_expr_redondantes();
		propagation_expression();
		simplification_algebrique();
		propagation_copie();
		elimination_code_inutile();
		affiche_quad_simple();
	} while (changed);

	printf("\n\nOptimisation ended after %d iterations\n", iteration);
}
