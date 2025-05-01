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
	printf("\n~~~~~~~~~~~~~~~~~~~~ Les Quadruplets ~~~~~~~~~~~~~~~~~~~~\n");

	int i;

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
}

extern qdr quad[MAX_QUADS];

// Flag indiquant s'il y a eu modification
static int changed;

// Fonctions utilitaires de log
static void log_update(const char *msg, int idx, const char *oldv, const char *newv)
{
	printf(msg, idx, oldv, newv);
	printf("\n");
}

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
			for (j = i + 1; j < qc; j++)
			{
				if (strcmp(quad[j].opr1, dst) == 0)
				{
					log_update("COPY PROPAGATION: remplace arg1 dans quad %d de '%s' a '%s'", j, dst, src);
					mise_jr_quad(j, 2, src);
					changed = 1;
				}
				if (strcmp(quad[j].opr2, dst) == 0)
				{
					log_update("COPY PROPAGATION: remplace arg2 dans quad %d de '%s' a '%s'", j, dst, src);
					mise_jr_quad(j, 3, src);
					changed = 1;
				}
			}
		}
	}
}

// 2. Propagation d'expression
void propagation_expression()
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
				// Même opération et mêmes opérandes
				char oldt[100];
				strcpy(oldt, quad[j].tempo);
				char newt[100];
				strcpy(newt, quad[i].tempo);
				log_update("EXPRESSION PROPAGATION: remplace tempo dans quad %d de '%s' a '%s'", j, oldt, newt);
				// transforme en copie
				mise_jr_quad(j, 1, "=");
				mise_jr_quad(j, 2, newt);
				mise_jr_quad(j, 3, "");
				changed = 1;
			}
		}
	}
}

// 3. Élimination d'expressions redondantes
void elimination_expr_redondantes()
{
	int i, j, k;
	for (i = 0; i < qc; i++)
	{
		if (strcmp(quad[i].operation, "=") == 0)
			continue;
		for (j = i + 1; j < qc; j++)
		{
			if (strcmp(quad[i].operation, quad[j].operation) == 0 &&
				strcmp(quad[i].opr1, quad[j].opr1) == 0 &&
				strcmp(quad[i].opr2, quad[j].opr2) == 0)
			{
				log_update("REDUNDANT EXPR ELIMINATION: supprime quad %d redondant", j, "", "");
				// suppression du quad j
				for (k = j; k < qc - 1; k++)
				{
					quad[k] = quad[k + 1];
				}
				qc--;
				changed = 1;
				j--; // réexamine l'indice j après shift
			}
		}
	}
}

// 4. Simplification algébrique
void simplification_algebrique()
{
	int i;
	for (i = 0; i < qc; i++)
	{
		// x = y + 0 ou y - 0
		if ((strcmp(quad[i].operation, "+") == 0 || strcmp(quad[i].operation, "-") == 0) &&
			strcmp(quad[i].opr2, "0") == 0)
		{
			log_update("ALGEBRAIC SIMPLIFICATION: simplifie quad %d '%s %s 0' en copie", i, quad[i].tempo, quad[i].opr1);
			mise_jr_quad(i, 1, "=");
			mise_jr_quad(i, 2, quad[i].opr1);
			mise_jr_quad(i, 3, "");
			changed = 1;
		}
		// x = y * 1 ou y * 0
		if (strcmp(quad[i].operation, "*") == 0)
		{
			if (strcmp(quad[i].opr2, "1") == 0)
			{
				log_update("ALGEBRAIC SIMPLIFICATION: simplifie quad %d '%s * 1' en copie", i, quad[i].tempo, quad[i].opr1);
				mise_jr_quad(i, 1, "=");
				mise_jr_quad(i, 2, quad[i].opr1);
				mise_jr_quad(i, 3, "");
				changed = 1;
			}
			else if (strcmp(quad[i].opr2, "0") == 0)
			{
				log_update("ALGEBRAIC SIMPLIFICATION: simplifie quad %d '%s * 0' en 0", i, quad[i].tempo, "");
				mise_jr_quad(i, 1, "=");
				mise_jr_quad(i, 2, "0");
				mise_jr_quad(i, 3, "");
				changed = 1;
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
			log_update("DEAD CODE ELIMINATION: supprime quad %d inutil dest=%s", i, quad[i].tempo, "");
			for (k = i; k < qc - 1; k++)
				quad[k] = quad[k + 1];
			qc--;
			changed = 1;
			i--;
		}
	}
}

// Fonction principale d'optimisation
void optimize()
{
	int iteration = 0;
	do
	{
		changed = 0;
		printf("\n--- Iteration %d ---\n", ++iteration);
		propagation_expression();
		simplification_algebrique();
		elimination_expr_redondantes();
		propagation_copie();
		elimination_code_inutile();
	} while (changed);

	printf("\n\nOptimisation ended after %d iterations\n", iteration);
}
