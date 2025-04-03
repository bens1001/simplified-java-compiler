#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define HASH_SIZE 100

// Hash function using djb2 algorithm
unsigned long hash(const char *str)
{
    unsigned long hash_val = 5381;
    int c;
    while ((c = *str++))
    {
        hash_val = ((hash_val << 5) + hash_val) + c; // hash * 33 + c
    }
    return hash_val % HASH_SIZE;
}

// Definition des structures de données
typedef struct ElementNode
{
    int state;
    char name[96];
    char code[20];
    char type[20];
    char val[20];
    char taille[20];
    char ligne[20];
    char colonne[20];
    char emplacement[20];
    char update[20];
    struct ElementNode *next;
    struct ElementNode *fifo_next;
} ElementNode;

typedef struct KeywordNode
{
    int state;
    char name[20];
    char type[20];
    struct KeywordNode *next;
    struct KeywordNode *fifo_next;
} KeywordNode;

typedef struct SeparatorNode
{
    int state;
    char name[20];
    char type[20];
    struct SeparatorNode *next;
    struct SeparatorNode *fifo_next;
} SeparatorNode;

typedef struct SymbolTables
{
    ElementNode **tab;
    KeywordNode **tabm;
    SeparatorNode **tabs;

    // FIFO tracking pointers
    ElementNode *element_fifo_head;
    ElementNode *element_fifo_tail;
    KeywordNode *keyword_fifo_head;
    KeywordNode *keyword_fifo_tail;
    SeparatorNode *separator_fifo_head;
    SeparatorNode *separator_fifo_tail;
} SymbolTables;

SymbolTables table;
extern char save[20];

// Initialisation de l'état des cases des tables des symboles
void initialisation()
{
    table.tab = (ElementNode **)calloc(HASH_SIZE, sizeof(ElementNode *));
    table.tabm = (KeywordNode **)calloc(HASH_SIZE, sizeof(KeywordNode *));
    table.tabs = (SeparatorNode **)calloc(HASH_SIZE, sizeof(SeparatorNode *));

    // Initialize FIFO pointers
    table.element_fifo_head = table.element_fifo_tail = NULL;
    table.keyword_fifo_head = table.keyword_fifo_tail = NULL;
    table.separator_fifo_head = table.separator_fifo_tail = NULL;
}

// Insertion des entités lexicales dans les tables des symboles
void inserer(char entite[], char code[], char type[], char val[], char taille[], char ligne[], char colonne[], char emplacement[], int y)
{
    switch (y)
    {
    case 0:
    { // insertion dans la table des IDF et CONST
        int hash_idx = hash(entite);
        ElementNode *newNode = (ElementNode *)malloc(sizeof(ElementNode));
        strcpy(newNode->name, entite);
        strcpy(newNode->code, strcmp(code, "-1") ? code : " ");
        strcpy(newNode->type, strcmp(type, "-1") ? type : " ");
        strcpy(newNode->val, strcmp(val, "-1") ? val : " ");
        strcpy(newNode->taille, strcmp(taille, "-1") ? taille : " ");
        strcpy(newNode->ligne, strcmp(ligne, "-1") ? ligne : " ");
        strcpy(newNode->colonne, strcmp(colonne, "-1") ? colonne : " ");
        strcpy(newNode->emplacement, strcmp(emplacement, "-1") ? emplacement : " ");
        strcpy(newNode->update, "LEXICAL");

        newNode->next = table.tab[hash_idx];
        table.tab[hash_idx] = newNode;

        // Add to FIFO list
        if (table.element_fifo_head == NULL)
        {
            table.element_fifo_head = table.element_fifo_tail = newNode;
        }
        else
        {
            table.element_fifo_tail->fifo_next = newNode;
            table.element_fifo_tail = newNode;
        }
        break;
    }

    case 1:
    { // insertion dans la table des mots clés
        int hash_idx = hash(entite);
        KeywordNode *newNode = (KeywordNode *)malloc(sizeof(KeywordNode));
        strcpy(newNode->name, entite);
        strcpy(newNode->type, code);

        newNode->next = table.tabm[hash_idx];
        table.tabm[hash_idx] = newNode;

        // Add to FIFO list
        if (table.keyword_fifo_head == NULL)
        {
            table.keyword_fifo_head = table.keyword_fifo_tail = newNode;
        }
        else
        {
            table.keyword_fifo_tail->fifo_next = newNode;
            table.keyword_fifo_tail = newNode;
        }
        break;
    }

    case 2:
    { // insertion dans la table des séparateurs
        int hash_idx = hash(entite);
        SeparatorNode *newNode = (SeparatorNode *)malloc(sizeof(SeparatorNode));
        strcpy(newNode->name, entite);
        strcpy(newNode->type, code);

        newNode->next = table.tabs[hash_idx];
        table.tabs[hash_idx] = newNode;

        // Add to FIFO list
        if (table.separator_fifo_head == NULL)
        {
            table.separator_fifo_head = table.separator_fifo_tail = newNode;
        }
        else
        {
            table.separator_fifo_tail->fifo_next = newNode;
            table.separator_fifo_tail = newNode;
        }
        break;
    }
    }
}

void miseajour(char entite[], char code[], char type[], char val[], char taille[], char ligne[], char colonne[], char emplacement[], char update[])
{
    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        if (strcmp(current->name, entite) == 0 &&
            (strcmp(emplacement, "-1") == 0 || strcmp(current->emplacement, emplacement) == 0))
        {

            if (strcmp(code, "-1") != 0)
                strcpy(current->code, code);
            if (strcmp(type, "-1") != 0)
                strcpy(current->type, type);
            if (strcmp(val, "-1") != 0)
                strcpy(current->val, val);
            if (strcmp(taille, "-1") != 0)
                strcpy(current->taille, taille);
            if (strcmp(ligne, "-1") != 0)
                strcpy(current->ligne, ligne);
            if (strcmp(colonne, "-1") != 0)
                strcpy(current->colonne, colonne);
            strcpy(current->update, update);
        }
        current = current->next;
    }
}

void search(char entite[], char code[], char type[], char val[], char taille[], char ligne[], char colonne[], char emplacement[], int y)
{
    switch (y)
    {
    case 0:
    {
        int hash_idx = hash(entite);
        ElementNode *current = table.tab[hash_idx];
        bool exists = false;

        while (current != NULL)
        {
            if (strcmp(current->name, entite) == 0 &&
                strcmp(current->emplacement, emplacement) == 0)
            {
                exists = true;
                break;
            }
            current = current->next;
        }

        if (!exists)
        {
            inserer(entite, code, type, val, taille, ligne, colonne, emplacement, 0);
        }
        break;
    }

    case 1:
    {
        int hash_idx = hash(entite);
        KeywordNode *current = table.tabm[hash_idx];
        bool exists = false;

        while (current != NULL)
        {
            if (strcmp(current->name, entite) == 0)
            {
                exists = true;
                break;
            }
            current = current->next;
        }

        if (!exists)
        {
            inserer(entite, code, type, val, taille, ligne, colonne, emplacement, 1);
        }
        break;
    }

    case 2:
    {
        int hash_idx = hash(entite);
        SeparatorNode *current = table.tabs[hash_idx];
        bool exists = false;

        while (current != NULL)
        {
            if (strcmp(current->name, entite) == 0)
            {
                exists = true;
                break;
            }
            current = current->next;
        }

        if (!exists)
        {
            inserer(entite, code, type, val, taille, ligne, colonne, emplacement, 2);
        }
        break;
    }

    case 3:
    {
        int hash_idx = hash(entite);
        ElementNode *current = table.tab[hash_idx];
        while (current != NULL)
        {
            if (strcmp(current->name, entite) == 0 &&
                strcmp(current->code, code) == 0 &&
                strcmp(current->emplacement, emplacement) == 0)
            {

                if (strcmp(type, current->type) == 0)
                {
                    miseajour(entite, "Message de sortie", "-1", val, taille, ligne, colonne, emplacement, "SYNTAXIQUE");
                }
                else
                {
                    miseajour(entite, "Appel fonction", type, val, taille, ligne, colonne, emplacement, "SYNTAXIQUE");
                }
            }
            current = current->next;
        }
        break;
    }
    }
}

bool idf_existe(char entite[], int emp, char code[])
{
    char emplacement[20];
    if (emp == 0)
        strcpy(emplacement, "GLOBAL");
    else if (emp > 0)
        sprintf(emplacement, "LOCAL %d", emp);

    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        bool name_match = (strcmp(current->name, entite) == 0);
        bool code_match = (strcmp(current->code, code) == 0);
        bool emp_match = (emp == -1) || (strcmp(current->emplacement, emplacement) == 0);

        if (name_match && code_match && emp_match)
            return true;
        current = current->next;
    }
    return false;
}

char *getType(char entite[], int emp, char code[])
{
    char emplacement[20];
    if (emp == 0)
        strcpy(emplacement, "GLOBAL");
    else if (emp > 0)
        sprintf(emplacement, "LOCAL %d", emp);

    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        bool name_match = (strcmp(current->name, entite) == 0);
        bool code_match = (strcmp(current->code, code) == 0);
        bool emp_match = (emp == -1) || (strcmp(current->emplacement, emplacement) == 0);

        if (name_match && code_match && emp_match)
            return current->type;
        current = current->next;
    }
    return "NULL";
}

bool verif_index(char entite[], int emp, char code[], char index[], char check[])
{
    char emplacement[20];
    if (emp == 0)
        strcpy(emplacement, "GLOBAL");
    else
        sprintf(emplacement, "LOCAL %d", emp);

    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        if (strcmp(current->name, entite) == 0 &&
            strcmp(current->code, code) == 0 &&
            strcmp(current->emplacement, emplacement) == 0)
        {

            if (strcmp(check, "Ligne") == 0)
                return atof(current->ligne) >= atof(index);
            if (strcmp(check, "Colonne") == 0)
                return atof(current->colonne) >= atof(index);
        }
        current = current->next;
    }
    return false;
}

bool verif_char(char entite[], int emp, char code[], char check[])
{
    char emplacement[20];
    if (emp == 0)
        strcpy(emplacement, "GLOBAL");
    else
        sprintf(emplacement, "LOCAL %d", emp);

    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        if (strcmp(current->name, entite) == 0 &&
            strcmp(current->code, code) == 0 &&
            strcmp(current->emplacement, emplacement) == 0)
        {

            return atof(current->taille) >= strlen(check) - 2;
        }
        current = current->next;
    }
    return false;
}

bool verif_param(char entite[], int nb_param)
{
    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        if (strcmp(current->name, entite) == 0 &&
            strcmp(current->code, "Fonction") == 0)
        {

            return atof(current->taille) == nb_param;
        }
        current = current->next;
    }
    return false;
}

void afficher()
{
    printf("/*************************Table des symboles IDF et constantes*************************/\n");
    printf("_____________________________________________________________________________________________________________________________________________________________________________\n");
    printf("\t|\t\t   Nom_Entite    \t\t| \tCode_Entite\t| Type_Entite |  Val_Entite  |  Taille  |  Lignes  | Colonnes |  Emplacement |  Last update |\n");
    printf("_____________________________________________________________________________________________________________________________________________________________________________\n");

    ElementNode *current = table.element_fifo_head;
    while (current != NULL)
    {
        printf("\t| %45s |  %20s | %11s | %12s | %8s | %8s | %8s | %12s | %12s |\n",
               current->name, current->code, current->type, current->val,
               current->taille, current->ligne, current->colonne,
               current->emplacement, current->update);
        current = current->fifo_next;
    }

    printf("\n/*************************Table des symboles mots cles*************************/\n");
    printf("_______________________________________________________________________\n");
    printf("\t|\t\t   Nom_Entite    \t\t|  CodeEntite | \n");
    printf("_______________________________________________________________________\n");

    KeywordNode *currentKeyword = table.keyword_fifo_head;
    while (currentKeyword != NULL)
    {
        printf("\t| %45s |%12s | \n", currentKeyword->name, currentKeyword->type);
        currentKeyword = currentKeyword->fifo_next;
    }

    printf("\n/*************************Table des symboles separateurs*************************/\n");
    printf("___________________________________\n");
    printf("\t| NomEntite |  CodeEntite | \n");
    printf("___________________________________\n");

    SeparatorNode *currentSeparator = table.separator_fifo_head;
    while (currentSeparator != NULL)
    {
        printf("\t|%10s |%12s | \n", currentSeparator->name, currentSeparator->type);
        currentSeparator = currentSeparator->fifo_next;
    }
}

void diviserChaine(const char *chaine, char *partie1, char *partie2)
{
    const char *separateur = strchr(chaine, '-');
    if (separateur)
    {
        size_t longueurPartie1 = separateur - chaine;
        strncpy(partie1, chaine, longueurPartie1);
        partie1[longueurPartie1] = '\0';
        strcpy(partie2, separateur + 1);
    }
    else
    {
        strcpy(partie1, chaine);
        partie2[0] = '\0';
    }
}

void liberer_table()
{
    int i;
    for (i = 0; i < HASH_SIZE; i++)
    {
        ElementNode *current = table.tab[i];
        while (current != NULL)
        {
            ElementNode *temp = current;
            current = current->next;
            free(temp);
        }
    }
    free(table.tab);
    free(table.tabm);
    free(table.tabs);
}
