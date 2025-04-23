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

// Definition of the data structures
typedef struct ElementNode
{
    int state;
    char name[96];
    char code[20];
    char type[50];
    char val[20];
    char taille[20];
    char dimensions[20];
    char num_params[20];
    char *param_types[20];
    char scope[256];
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

char current_scope[256] = "GLOBAL";

// Initialize symbol table arrays and FIFO pointers
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

// Insertion of lexical entities into the symbol table
void inserer(char entite[], char code[], char type[], char val[], char taille[], char dimensions[], char num_params[], char scope[], int y)
{
    switch (y)
    {
    case 0:
    { // Insertion into the table for identifiers and constants
        int hash_idx = hash(entite);
        ElementNode *newNode = (ElementNode *)malloc(sizeof(ElementNode));
        strcpy(newNode->name, entite);
        strcpy(newNode->code, strcmp(code, "-1") ? code : " ");
        strcpy(newNode->type, strcmp(type, "-1") ? type : " ");
        strcpy(newNode->val, strcmp(val, "-1") ? val : " ");
        strcpy(newNode->taille, strcmp(taille, "-1") ? taille : " ");
        strcpy(newNode->dimensions, strcmp(dimensions, "-1") ? dimensions : "0");
        strcpy(newNode->num_params, strcmp(num_params, "-1") ? num_params : "0");
        strcpy(newNode->scope, strcmp(scope, "-1") ? scope : "GLOBAL");

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
    { // Insertion into the table for keywords
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
    { // Insertion into the table for separators
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

void search(char entite[], char code[], char type[], char val[], char taille[], char dimensions[], char num_params[], char scope[], int y)
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
                strcmp(current->scope, scope) == 0 &&
                strcmp(current->code, code) == 0)
            {
                exists = true;
                break;
            }
            current = current->next;
        }

        if (!exists)
        {
            inserer(entite, code, type, val, taille, dimensions, num_params, scope, 0);
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
            inserer(entite, code, type, val, taille, dimensions, num_params, scope, 1);
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
            inserer(entite, code, type, val, taille, dimensions, num_params, scope, 2);
        }
        break;
    }
    }
}

void update(char entite[], char code[], char type[], char val[], char taille[], char dimensions[], char num_params[], char scope[])
{
    int hash_idx = hash(entite);
    ElementNode *current = table.tab[hash_idx];

    while (current != NULL)
    {
        if (strcmp(current->name, entite) == 0 &&
            (strcmp(scope, "-1") == 0 || strcmp(current->scope, scope) == 0) &&
            strcmp(current->code, code) == 0)
        {
            if (strcmp(type, "-1") != 0)
                strcpy(current->type, type);
            if (strcmp(val, "-1") != 0)
                strcpy(current->val, val);
            if (strcmp(taille, "-1") != 0)
                strcpy(current->taille, taille);
            if (strcmp(dimensions, "-1") != 0)
                strcpy(current->dimensions, dimensions);
            if (strcmp(num_params, "-1") != 0)
                strcpy(current->num_params, num_params);
        }
        current = current->next;
    }
}

void setParameterTypes(const char *name, const char *scope, const char *code, char *types[], int count)
{
    int hash_idx = hash(name);
    ElementNode *current = table.tab[hash_idx];

    int i;
    while (current)
    {
        if (strcmp(current->name, name) == 0 &&
            strcmp(current->scope, scope) == 0 &&
            strcmp(current->code, code) == 0)
        {

            for (i = 0; i < count; i++)
            {
                if (types[i])
                {
                    current->param_types[i] = strdup(types[i]);
                }
                else
                {
                    current->param_types[i] = NULL;
                }
            }
            break;
        }
        current = current->next;
    }
}

char **getParameterTypes(const char *name, const char *scope, const char *code)
{
    int hash_idx = hash(name);
    ElementNode *current = table.tab[hash_idx];

    while (current)
    {
        if (strcmp(current->name, name) == 0 &&
            strcmp(current->scope, scope) == 0 &&
            strcmp(current->code, code) == 0)
        {
            return current->param_types;
        }
        current = current->next;
    }
    return NULL; // Not found
}

static char *concat(const char *a, const char *b)
{
    size_t la = strlen(a), lb = strlen(b);
    size_t need = la + (la && lb ? 1 : 0) + lb + 1;
    char *s = malloc(need);
    s[0] = '\0';
    if (la)
        strcat(s, a);
    if (la && lb)
        strcat(s, ".");
    if (lb)
        strcat(s, b);
    return s;
}

char *get_element(const char *input, bool get_first)
{
    if (!input || strlen(input) == 0)
        return strdup("");

    char *copy = strdup(input);
    char *token = strtok(copy, ".");
    char *first = NULL;
    char *last = NULL;

    while (token)
    {
        if (strlen(token) > 0)
        {
            free(first);
            first = strdup(token);
            free(last);
            last = strdup(token);
        }
        token = strtok(NULL, ".");
    }

    free(copy);

    char *result = NULL;
    if (get_first && first)
    {
        result = strdup(first);
    }
    else if (!get_first && last)
    {
        result = strdup(last);
    }
    else
    {
        result = strdup("");
    }

    free(first);
    free(last);
    return result;
}

char *getType(char entite[], const char *scope, char code[])
{
    char *base_name = get_element(entite, false);

    int hash_idx = hash(base_name);
    ElementNode *current = table.tab[hash_idx];

    while (current)
    {
        if (strcmp(current->name, base_name) == 0 &&
            strcmp(current->code, code) == 0 &&
            (strcmp(scope, "-1") == 0 || strcmp(current->scope, scope) == 0))
        {
            free(base_name);
            return current->type;
        }
        current = current->next;
    }

    free(base_name);
    return "NULL";
}

char *getTypeRecursive(char entite[], const char *scope, char code[])
{
    char current_scope_copy[256];
    strcpy(current_scope_copy, scope);
    char *base_name = get_element(entite, false);

    while (1)
    {
        int hash_idx = hash(base_name);
        ElementNode *current = table.tab[hash_idx];

        while (current)
        {
            if (strcmp(current->name, entite) == 0 &&
                strcmp(current->code, code) == 0 &&
                strcmp(current->scope, current_scope_copy) == 0)
            {
                free(base_name);
                return current->type;
            }
            current = current->next;
        }

        char *last_dot = strrchr(current_scope_copy, '.');
        if (!last_dot)
            break;
        *last_dot = '\0';
    }
    free(base_name);
    return "NULL";
}

char *getValue(char entite[], const char *scope, char code[])
{
    char *base_name = get_element(entite, false);

    int hash_idx = hash(base_name);
    ElementNode *current = table.tab[hash_idx];

    while (current)
    {
        if (strcmp(current->name, base_name) == 0 &&
            strcmp(current->code, code) == 0 &&
            (strcmp(scope, "-1") == 0 || strcmp(current->scope, scope) == 0))
        {
            free(base_name);
            return current->val;
        }
        current = current->next;
    }

    free(base_name);
    return "NULL";
}

char *getLength(char entite[], const char *scope, char code[])
{
    char *base_name = get_element(entite, false);

    int hash_idx = hash(base_name);
    ElementNode *current = table.tab[hash_idx];

    while (current)
    {
        if (strcmp(current->name, base_name) == 0 &&
            strcmp(current->code, code) == 0 &&
            (strcmp(scope, "-1") == 0 || strcmp(current->scope, scope) == 0))
        {
            free(base_name);
            return current->taille;
        }
        current = current->next;
    }

    free(base_name);
    return "NULL";
}

char *getNumParams(char entite[], const char *scope, char code[])
{
    char *base_name = get_element(entite, false);

    int hash_idx = hash(base_name);
    ElementNode *current = table.tab[hash_idx];

    while (current)
    {
        if (strcmp(current->name, base_name) == 0 &&
            strcmp(current->code, code) == 0 &&
            (strcmp(scope, "-1") == 0 || strcmp(current->scope, scope) == 0))
        {
            free(base_name);
            return current->num_params;
        }
        current = current->next;
    }

    free(base_name);
    return "0";
}

bool check_idf_recursive_scope(const char *name, const char *scope, const char *category)
{
    char current_scope_copy[256];
    strcpy(current_scope_copy, scope);

    while (1)
    {
        // Recherche dans la portée actuelle ou parente
        int hash_idx = hash(name);
        ElementNode *current = table.tab[hash_idx];
        while (current)
        {
            if (strcmp(current->name, name) == 0 &&
                strcmp(current->code, category) == 0 &&
                strcmp(current->scope, current_scope_copy) == 0)
            {
                return true;
            }
            current = current->next;
        }

        // Passer à la portée parente
        char *last_dot = strrchr(current_scope_copy, '.');
        if (!last_dot)
            break;
        *last_dot = '\0';
    }
    return false;
}

bool idf_exists_same_scope(const char *name, const char *scope, const char *category)
{
    char *base_name = get_element(name, false);

    int hash_idx = hash(base_name);
    ElementNode *current = table.tab[hash_idx];

    bool exists = false;
    while (current)
    {
        if (strcmp(current->name, base_name) == 0 &&
            strcmp(current->scope, scope) == 0 &&
            strcmp(current->code, category) == 0)
        {
            exists = true;
            break;
        }
        current = current->next;
    }

    free(base_name);
    return exists;
}

bool isConstructorValid(const char *constructorName, const char *current_scope)
{
    char *dotPos = strchr(current_scope, '.');
    if (dotPos == NULL)
    {
        return false;
    }

    const char *className = dotPos + 1;
    if (strcmp(constructorName, className) != 0)
    {
        return false;
    }
    return true;
}

int startsWith(const char *str, const char *prefix)
{
    size_t lenPrefix = strlen(prefix);
    size_t lenStr = strlen(str);

    if (lenPrefix > lenStr)
        return false;

    return strncmp(str, prefix, lenPrefix) == 0;
}

int endsWith(const char *str, const char *suffix)
{
    size_t lenStr = strlen(str);
    size_t lenSuffix = strlen(suffix);

    if (lenSuffix > lenStr)
        return 0;

    // Compare the tail of str with suffix
    return strncmp(str + lenStr - lenSuffix, suffix, lenSuffix) == 0;
}

int getArraySizes(const char *t, int sizes[])
{
    int count = 0;
    const char *p = t;

    while (*p)
    {
        if (*p == '[')
        {
            ++p;

            if (*p == ']')
            {
                sizes[count++] = -1;
                ++p;
            }
            else
            {
                int val = 0;
                while (isdigit((unsigned char)*p))
                {
                    val = val * 10 + (*p - '0');
                    ++p;
                }
                sizes[count++] = val;
                if (*p == ']')
                    ++p;
            }
        }
        else
        {
            ++p;
        }
    }

    return count;
}

char *getBaseType(const char *t)
{
    char *b = strdup(t);
    char *br = strchr(b, '[');
    if (br)
        *br = '\0';
    return b;
}

bool isNumericType(const char *type)
{
    return startsWith(type, "int") || startsWith(type, "float") || startsWith(type, "double");
}

void afficher()
{
    printf("/************************* Table des symboles (IDF et constantes) *************************/\n");
    printf("___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________\n");
    printf("\t|\t\t   Nom_Entite    \t\t| \tCode_Entite\t|\tType_Entite\t|  Val_Entite  |  Taille  |  Dimensions | Num_Params | \t\t\t\t Scope \t\t\t\t|\n");
    printf("___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________\n");

    ElementNode *current = table.element_fifo_head;
    while (current != NULL)
    {
        printf("\t| %45s |  %20s | %20s | %12s | %10s | %10s | %10s | %56s |\n",
               current->name, current->code, current->type, current->val,
               current->taille, current->dimensions, current->num_params,
               strcmp(current->scope, "GLOBAL") == 0
                   ? current->scope
                   : (strncmp(current->scope, "GLOBAL.", 7) == 0 ? current->scope + 7 : current->scope));
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

char *getArrayDimension(char *str)
{

    static char result[20];
    int count = 0;
    const char *ptr = str;
    while (*ptr)
    {
        if (*ptr == '[')
            count++;
        ptr++;
    }
    sprintf(result, "%d", count);
    return result;
}

char *getArraySize(char *str)
{
    static char result[20];

    int dimensions[10];
    int dimCount = 0;
    int definedCount = 0;
    int hasEmptyDimension = 0;
    const char *ptr = str;

    // Parse the string and extract dimensions
    while (*ptr)
    {
        if (*ptr == '[')
        {
            ptr++;
            if (*ptr == ']')
            {
                dimensions[dimCount++] = -1;
                hasEmptyDimension = 1;
                ptr++;
            }
            else
            {
                int size = 0;
                while (*ptr >= '0' && *ptr <= '9')
                {
                    size = size * 10 + (*ptr - '0');
                    ptr++;
                }
                dimensions[dimCount++] = size;
                definedCount++;
            }
        }
        else
        {
            ptr++;
        }
    }

    if (dimCount == 0)
    {
        strcpy(result, "-");
        return result;
    }

    if (definedCount == 0)
    {
        strcpy(result, "dynamic");
        return result;
    }

    int totalSize = 1;
    int i;
    for (i = 0; i < dimCount; i++)
    {
        if (dimensions[i] != -1)
        {
            totalSize *= dimensions[i];
        }
    }

    if (hasEmptyDimension && definedCount >= 1)
    {
        snprintf(result, sizeof(result), "%d+", totalSize);
    }
    else
    {
        snprintf(result, sizeof(result), "%d", totalSize);
    }

    return result;
}

void enter_scope(const char *name)
{
    if (strlen(current_scope) + strlen(name) + 1 >= 256)
    {
        fprintf(stderr, "Scope path too long!\n");
        exit(1);
    }

    strcat(current_scope, ".");
    strcat(current_scope, name);
}

void exit_scope()
{
    char *last_dot = strrchr(current_scope, '.');
    if (last_dot != NULL)
    {
        *last_dot = '\0';
    }
    else
    {
        strcpy(current_scope, "GLOBAL");
    }
}

void set_scope(const char *scope)
{
    strncpy(current_scope, scope, 255);
    current_scope[255] = '\0';
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
