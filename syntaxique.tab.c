
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "syntaxique.y"

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "ts.h"
#include "quad.h"

int nb_line=1;
int nb_character=0;
char *file_name;
char taille[20];
char empla[20];
int emp=1;
char typeIDF[20];
char savet[20];
int param=0;
char para[20];

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



/* Line 189 of yacc.c  */
#line 112 "syntaxique.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     plus = 258,
     minus = 259,
     mul = 260,
     divi = 261,
     aff = 262,
     pvg = 263,
     po = 264,
     pf = 265,
     pt = 266,
     vg = 267,
     kwPROGRAM = 268,
     kwEND = 269,
     kwROUTINE = 270,
     kwENDR = 271,
     kwCALL = 272,
     kwCHARACTER = 273,
     kwINTEGER = 274,
     kwREAL = 275,
     kwLOGICAL = 276,
     kwREAD = 277,
     kwWRITE = 278,
     kwIF = 279,
     kwTHEN = 280,
     kwELSE = 281,
     kwENDIF = 282,
     kwDOWHILE = 283,
     kwENDDO = 284,
     kwEQUIVALENCE = 285,
     kwOR = 286,
     kwAND = 287,
     kwGT = 288,
     kwGE = 289,
     kwEQ = 290,
     kwLE = 291,
     kwLT = 292,
     kwNE = 293,
     kwDIMENSION = 294,
     integer = 295,
     real = 296,
     character = 297,
     idf = 298,
     boolean = 299
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 39 "syntaxique.y"

    char* str;



/* Line 214 of yacc.c  */
#line 198 "syntaxique.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 210 "syntaxique.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  9
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   377

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  45
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  54
/* YYNRULES -- Number of rules.  */
#define YYNRULES  144
/* YYNRULES -- Number of states.  */
#define YYNSTATES  328

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   299

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    11,    18,    20,    22,    24,
      26,    29,    30,    34,    35,    39,    42,    45,    48,    51,
      54,    57,    60,    62,    66,    70,    74,    78,    82,    86,
      90,    93,    96,    99,   102,   105,   108,   111,   114,   116,
     120,   127,   130,   133,   136,   137,   139,   141,   143,   148,
     155,   161,   169,   178,   188,   199,   211,   214,   215,   217,
     219,   221,   222,   226,   232,   237,   244,   245,   253,   262,
     263,   273,   284,   285,   288,   289,   292,   295,   298,   301,
     303,   305,   308,   312,   319,   328,   332,   336,   340,   344,
     346,   351,   358,   360,   362,   364,   366,   370,   372,   374,
     377,   381,   384,   388,   393,   398,   403,   408,   416,   424,
     428,   430,   432,   434,   436,   438,   440,   442,   444,   447,
     450,   454,   458,   460,   465,   472,   477,   482,   487,   490,
     492,   496,   501,   504,   510,   516,   517,   520,   521,   525,
     526,   534,   537,   538,   542
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      46,     0,    -1,    47,    57,    -1,    48,    52,    47,    -1,
      -1,    49,    15,    43,     9,    50,    10,    -1,    19,    -1,
      20,    -1,    21,    -1,    18,    -1,    43,    51,    -1,    -1,
      12,    43,    51,    -1,    -1,    58,    53,    16,    -1,    92,
      54,    -1,    88,    54,    -1,    89,    54,    -1,    73,    54,
      -1,    96,    54,    -1,    80,    55,    -1,    86,    55,    -1,
      56,    -1,     8,    92,    54,    -1,     8,    88,    54,    -1,
       8,    89,    54,    -1,     8,    73,    54,    -1,     8,    80,
      55,    -1,     8,    86,    55,    -1,     8,    96,    54,    -1,
       8,    56,    -1,    92,    54,    -1,    88,    54,    -1,    89,
      54,    -1,    73,    54,    -1,    80,    55,    -1,    86,    55,
      -1,    96,    54,    -1,    56,    -1,    43,     7,    74,    -1,
      13,    43,    58,    71,    14,    11,    -1,    60,    58,    -1,
      61,    58,    -1,    62,    58,    -1,    -1,    19,    -1,    20,
      -1,    21,    -1,    59,    43,    64,     8,    -1,    59,    43,
       7,    74,    64,     8,    -1,    18,    43,    63,    66,     8,
      -1,    18,    43,    63,     7,    74,    66,     8,    -1,    59,
      43,    39,     9,    40,    10,    64,     8,    -1,    18,    43,
      63,    39,     9,    40,    10,    68,     8,    -1,    59,    43,
      39,     9,    40,    12,    40,    10,    64,     8,    -1,    18,
      43,    63,    39,     9,    40,    12,    40,    10,    70,     8,
      -1,     5,    40,    -1,    -1,    65,    -1,    67,    -1,    69,
      -1,    -1,    12,    43,    64,    -1,    12,    43,     7,    74,
      64,    -1,    12,    43,    63,    66,    -1,    12,    43,    63,
       7,    74,    66,    -1,    -1,    12,    43,    39,     9,    40,
      10,    64,    -1,    12,    43,    63,    39,     9,    40,    10,
      68,    -1,    -1,    12,    43,    39,     9,    40,    12,    40,
      10,    64,    -1,    12,    43,    63,    39,     9,    40,    12,
      40,    10,    70,    -1,    -1,    72,    71,    -1,    -1,    92,
       8,    -1,    88,     8,    -1,    89,     8,    -1,    73,     8,
      -1,    80,    -1,    86,    -1,    96,     8,    -1,    43,     7,
      74,    -1,    43,     9,    75,    10,     7,    74,    -1,    43,
       9,    75,    12,    75,    10,     7,    74,    -1,    74,     3,
      74,    -1,    74,     4,    74,    -1,    74,     5,    74,    -1,
      74,     6,    74,    -1,    43,    -1,    43,     9,    75,    10,
      -1,    43,     9,    75,    12,    75,    10,    -1,    41,    -1,
      40,    -1,    44,    -1,    42,    -1,     9,    74,    10,    -1,
      43,    -1,    40,    -1,    24,    81,    -1,    76,    25,    71,
      -1,    24,    74,    -1,    78,    25,    71,    -1,    77,    26,
      71,    27,    -1,    76,    25,    71,    27,    -1,    78,    25,
      71,    27,    -1,    79,    26,    71,    27,    -1,     9,    74,
      11,    83,    11,    74,    10,    -1,     9,    81,    11,    82,
      11,    81,    10,    -1,     9,    81,    10,    -1,    32,    -1,
      31,    -1,    33,    -1,    34,    -1,    35,    -1,    36,    -1,
      37,    -1,    38,    -1,    28,    81,    -1,    28,    74,    -1,
      84,    71,    29,    -1,    85,    71,    29,    -1,    43,    -1,
      43,     9,    75,    10,    -1,    43,     9,    75,    12,    75,
      10,    -1,    22,     9,    87,    10,    -1,    23,     9,    90,
      10,    -1,    23,     9,    87,    10,    -1,    42,    91,    -1,
      42,    -1,    87,    12,    90,    -1,    12,    87,    12,    90,
      -1,    12,    87,    -1,    30,     9,    94,    10,    93,    -1,
      12,     9,    94,    10,    93,    -1,    -1,    87,    95,    -1,
      -1,    12,    87,    95,    -1,    -1,    43,     7,    17,    43,
       9,    97,    10,    -1,    87,    98,    -1,    -1,    12,    87,
      98,    -1,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    62,    62,    65,    66,    69,    81,    82,    83,    84,
      87,    93,    96,   102,   105,   108,   109,   110,   111,   112,
     113,   114,   115,   118,   119,   120,   121,   122,   123,   124,
     125,   128,   129,   130,   131,   132,   133,   134,   135,   138,
     157,   160,   161,   162,   163,   166,   167,   168,   171,   184,
     205,   218,   243,   262,   284,   305,   328,   333,   338,   339,
     340,   341,   344,   357,   386,   399,   422,   425,   446,   466,
     469,   492,   513,   516,   517,   520,   521,   522,   523,   524,
     525,   526,   529,   552,   577,   604,   626,   648,   670,   689,
     702,   721,   740,   746,   752,   758,   764,   770,   788,   798,
     806,   815,   829,   838,   843,   848,   853,   860,   875,   882,
     888,   889,   892,   893,   894,   895,   896,   897,   900,   908,
     916,   923,   932,   940,   948,   958,   961,   965,   971,   977,
     981,   989,   995,  1003,  1006,  1007,  1010,  1011,  1014,  1015,
    1018,  1048,  1052,  1055,  1059
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "plus", "minus", "mul", "divi", "aff",
  "pvg", "po", "pf", "pt", "vg", "kwPROGRAM", "kwEND", "kwROUTINE",
  "kwENDR", "kwCALL", "kwCHARACTER", "kwINTEGER", "kwREAL", "kwLOGICAL",
  "kwREAD", "kwWRITE", "kwIF", "kwTHEN", "kwELSE", "kwENDIF", "kwDOWHILE",
  "kwENDDO", "kwEQUIVALENCE", "kwOR", "kwAND", "kwGT", "kwGE", "kwEQ",
  "kwLE", "kwLT", "kwNE", "kwDIMENSION", "integer", "real", "character",
  "idf", "boolean", "$accept", "COMPIL", "PROC", "SIGNATURE", "TYPEPROC",
  "PARAM", "PARA", "ROUTINE", "INSTPROC", "INSTSPROC", "INSTSPROCBLOC",
  "RETOUR", "MAIN", "DEC", "TYPE", "DECSOLO", "DECTAB", "DECMAT",
  "MULCHAR", "LISTVAR", "LISTVARSOLO", "LISTVARSOLOCHAR", "LISTVARTAB",
  "LISTVARTABCHAR", "LISTVARMAT", "LISTVARMATCHAR", "INST", "INSTS",
  "AFFECTATION", "EXPRESSION", "INDEX", "R2_1_CONTROLE", "R1_2_CONTROLE",
  "R3_1_CONTROLE", "R4_2_CONTROLE", "CONTROLE", "CONDITION", "OPLOG",
  "OPCOMP", "R1_1_BOUCLE", "R2_1_BOUCLE", "BOUCLE", "MEMBREIDF", "ENTREE",
  "SORTIE", "MESSAGE", "MESSAGEIDF", "EQU", "LISTEQU", "PARA_EQU",
  "PARAM_EQU", "CALLPROC", "PARAMETRE", "PARAMETRES", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    45,    46,    47,    47,    48,    49,    49,    49,    49,
      50,    50,    51,    51,    52,    53,    53,    53,    53,    53,
      53,    53,    53,    54,    54,    54,    54,    54,    54,    54,
      54,    55,    55,    55,    55,    55,    55,    55,    55,    56,
      57,    58,    58,    58,    58,    59,    59,    59,    60,    60,
      60,    60,    61,    61,    62,    62,    63,    63,    64,    64,
      64,    64,    65,    65,    66,    66,    66,    67,    68,    68,
      69,    70,    70,    71,    71,    72,    72,    72,    72,    72,
      72,    72,    73,    73,    73,    74,    74,    74,    74,    74,
      74,    74,    74,    74,    74,    74,    74,    75,    75,    76,
      77,    78,    79,    80,    80,    80,    80,    81,    81,    81,
      82,    82,    83,    83,    83,    83,    83,    83,    84,    85,
      86,    86,    87,    87,    87,    88,    89,    89,    90,    90,
      90,    91,    91,    92,    93,    93,    94,    94,    95,    95,
      96,    97,    97,    98,    98
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     0,     6,     1,     1,     1,     1,
       2,     0,     3,     0,     3,     2,     2,     2,     2,     2,
       2,     2,     1,     3,     3,     3,     3,     3,     3,     3,
       2,     2,     2,     2,     2,     2,     2,     2,     1,     3,
       6,     2,     2,     2,     0,     1,     1,     1,     4,     6,
       5,     7,     8,     9,    10,    11,     2,     0,     1,     1,
       1,     0,     3,     5,     4,     6,     0,     7,     8,     0,
       9,    10,     0,     2,     0,     2,     2,     2,     2,     1,
       1,     2,     3,     6,     8,     3,     3,     3,     3,     1,
       4,     6,     1,     1,     1,     1,     3,     1,     1,     2,
       3,     2,     3,     4,     4,     4,     4,     7,     7,     3,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     2,
       3,     3,     1,     4,     6,     4,     4,     4,     2,     1,
       3,     4,     2,     5,     5,     0,     2,     0,     3,     0,
       7,     2,     0,     3,     0
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       4,     9,     6,     7,     8,     0,     0,    44,     0,     1,
       0,     2,     0,    45,    46,    47,     4,     0,     0,    44,
      44,    44,     0,    44,    57,     3,     0,     0,     0,     0,
       0,     0,     0,    22,     0,     0,     0,     0,     0,     0,
      74,    74,     0,     0,     0,     0,     0,    61,    41,    42,
      43,     0,    74,     0,    66,     0,     0,     0,    93,    92,
      95,    89,    94,   101,    99,   119,   118,   137,     0,     0,
      14,     0,    18,    74,    74,    74,    74,    20,    38,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    74,     0,
      79,    80,     0,     0,     0,     0,     0,    21,    16,    17,
      15,    19,     0,     0,     0,     0,    58,    59,    60,    11,
       0,    56,     0,     0,     0,     0,   122,     0,   129,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   139,     0,
       0,     0,    39,    98,    97,     0,    30,     0,     0,     0,
       0,     0,     0,     0,   100,     0,   102,     0,    34,    35,
      36,    32,    33,    31,    37,     0,   120,    73,    78,    76,
      77,    75,    81,   121,    61,    61,     0,    48,    13,     0,
       0,    66,    57,     0,    50,     0,   125,     0,   128,   127,
       0,   126,    96,     0,   109,     0,     0,    85,    86,    87,
      88,     0,   136,   135,     0,     0,     0,     0,    26,    27,
      28,    24,    25,    23,    29,   104,   103,   105,   106,    82,
       0,     0,     0,    62,     0,     0,    10,     5,    40,     0,
      66,     0,     0,   132,     0,   130,   112,   113,   114,   115,
     116,   117,     0,   111,   110,     0,    90,     0,   139,     0,
     133,   142,     0,     0,    49,    61,     0,    61,     0,    13,
      51,     0,    64,    69,     0,   123,     0,     0,     0,     0,
       0,   138,   137,   144,     0,    83,     0,    63,     0,     0,
       0,    12,    66,     0,     0,     0,     0,   131,     0,     0,
       0,    91,     0,     0,   141,   140,     0,    61,     0,    52,
      61,    65,    57,    53,    72,   124,   107,     0,   108,   135,
     144,    84,    67,     0,     0,     0,     0,     0,   134,   143,
      61,    54,     0,    57,    55,    70,     0,     0,     0,     0,
      69,     0,    68,     0,     0,     0,    72,    71
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     5,     6,     7,     8,   169,   216,    16,    32,    72,
      77,    78,    11,    17,    18,    19,    20,    21,    54,   105,
     106,   115,   107,   274,   108,   307,    87,    88,    89,    63,
     135,    35,    36,    37,    38,    90,   122,   235,   232,    40,
      41,    91,   128,    92,    93,   120,   178,    94,   240,   129,
     192,    95,   264,   284
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -173
static const yytype_int16 yypact[] =
{
     152,  -173,  -173,  -173,  -173,    13,    20,   257,    57,  -173,
      31,  -173,    34,  -173,  -173,  -173,   152,   230,    43,   257,
     257,   257,    45,   257,    87,  -173,    98,   108,   135,   135,
     122,    52,    94,  -173,   119,   111,   114,   116,   120,   230,
     244,   244,   230,   119,   119,   119,   119,    11,  -173,  -173,
    -173,   141,   244,   155,    12,   115,   -26,   135,  -173,  -173,
    -173,   145,  -173,   118,  -173,   118,  -173,   115,   203,   -18,
    -173,   230,  -173,   244,   244,   244,   244,  -173,  -173,   119,
     230,   230,   119,   119,   119,   119,    62,   131,   244,   173,
    -173,  -173,   188,   190,   191,   192,   189,  -173,  -173,  -173,
    -173,  -173,   150,   176,   214,   220,  -173,  -173,  -173,   187,
     225,  -173,   150,   197,   239,   241,   242,   245,   247,    68,
     246,   285,    25,   -18,   150,   150,   150,   150,   249,   252,
     150,   226,    38,  -173,  -173,    72,  -173,   119,   230,   230,
     119,   119,   119,   119,   236,   243,   253,   254,  -173,  -173,
    -173,  -173,  -173,  -173,  -173,   203,  -173,  -173,  -173,  -173,
    -173,  -173,  -173,  -173,    26,    14,   231,  -173,   274,   282,
     283,   205,    87,   266,  -173,   -18,  -173,   115,  -173,  -173,
     -26,  -173,  -173,   200,  -173,    32,    90,   158,   158,  -173,
    -173,   115,  -173,   281,   298,   304,   300,   -18,  -173,  -173,
    -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,  -173,   118,
     307,   150,   305,  -173,   101,   275,  -173,  -173,  -173,   309,
       8,   104,   125,   308,   310,  -173,  -173,  -173,  -173,  -173,
    -173,  -173,   312,  -173,  -173,   313,  -173,   -18,   249,   316,
    -173,   115,   150,   311,  -173,    26,   279,   314,   287,   274,
    -173,   150,  -173,   317,   288,  -173,   -18,   -26,   150,   321,
     322,  -173,   115,   319,   323,   118,   327,  -173,   143,   328,
     325,  -173,   205,   295,   329,   330,   331,  -173,   306,   135,
     332,  -173,   333,   115,  -173,  -173,   150,   314,   299,  -173,
     314,  -173,    87,  -173,   334,  -173,  -173,   294,  -173,   281,
     319,   118,  -173,   335,   336,   315,   318,   339,  -173,  -173,
     314,  -173,   340,    87,  -173,  -173,   320,   324,   338,   341,
     317,   326,  -173,   343,   337,   342,   334,  -173
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -173,  -173,   346,  -173,  -173,  -173,   102,  -173,  -173,   142,
     -33,    -3,  -173,    35,  -173,  -173,  -173,  -173,  -162,  -158,
    -173,  -160,  -173,    33,  -173,    30,   128,  -173,    -5,   -29,
    -118,  -173,  -173,  -173,  -173,    10,   -27,  -173,  -173,  -173,
    -173,    23,   -52,    28,    76,  -172,  -173,   103,    58,    96,
     121,   126,  -173,    64
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -83
static const yytype_int16 yytable[] =
{
      65,    64,    66,   117,   119,   186,   210,   213,   225,    97,
     220,   219,    34,     9,    33,   251,   118,   116,   102,   112,
     113,   211,   133,   103,   113,   134,   103,    39,   121,   124,
     125,   126,   127,    10,    79,   184,   185,    79,   103,   132,
      42,   124,   125,   126,   127,    43,   -82,   149,   150,    80,
     104,   114,    80,   212,    48,    49,    50,   222,    52,    68,
     252,    69,    81,   233,   234,    81,   137,    82,   136,   155,
      82,    69,    22,   164,    23,    79,    79,    24,   179,   243,
     180,   138,   196,   171,   197,   277,    47,   267,    51,   269,
      80,    80,    53,    44,   139,   187,   188,   189,   190,   140,
     236,   194,   237,    81,    81,   199,   200,    55,    82,    82,
      70,   247,   291,   248,   253,    83,   254,    56,    83,   260,
      45,   124,   125,   126,   127,   223,   209,    71,   224,   302,
     305,    67,   304,    79,    79,   255,    73,   256,   276,   238,
      74,    75,    84,    46,    57,    84,    76,   141,    80,    80,
     109,   317,   315,   287,   123,   288,    83,    83,   116,   130,
     156,    81,    81,   126,   127,    85,    82,    82,    85,    96,
       1,     2,     3,     4,   142,    58,    59,    60,    61,    62,
     110,   158,   245,    84,    84,    98,    99,   100,   101,   263,
      58,    59,    60,    61,    62,   111,   159,   143,   160,   161,
     162,   144,   145,   146,   147,   224,    85,    85,   124,   125,
     126,   127,   130,   265,    83,    83,   157,   113,   163,   165,
     131,   148,   272,   166,   151,   152,   153,   154,   167,   278,
     168,   300,   280,   226,   227,   228,   229,   230,   231,   170,
     172,    84,    84,    58,    59,    60,    61,    62,   173,   174,
     297,   175,    26,    27,    28,   176,   181,   301,    29,   177,
      30,   191,   193,   205,    85,    85,    26,    27,    28,   195,
     206,   214,    29,    31,    30,    12,    13,    14,    15,   198,
     207,   208,   201,   202,   203,   204,   215,    86,   124,   125,
     126,   127,   217,   239,   218,   182,   183,   124,   125,   126,
     127,   124,   125,   126,   127,   183,   221,   242,   182,   124,
     125,   126,   127,   241,   246,   244,   296,   250,   249,   268,
     257,   266,   180,   258,   259,   262,   103,   270,   275,   273,
     279,   283,   281,   285,   286,   290,   289,   293,   292,   303,
     294,   295,   298,   299,   311,   310,   306,   314,   320,   316,
     321,   271,   326,   322,   312,   324,   327,   308,   282,   261,
     318,   313,    25,   319,   309,     0,   323,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   325
};

static const yytype_int16 yycheck[] =
{
      29,    28,    29,    55,    56,   123,   164,   165,   180,    42,
     172,   171,    17,     0,    17,     7,    42,    43,     7,     7,
      12,     7,    40,    12,    12,    43,    12,    17,    57,     3,
       4,     5,     6,    13,    39,    10,    11,    42,    12,    68,
      17,     3,     4,     5,     6,    17,     8,    80,    81,    39,
      39,    39,    42,    39,    19,    20,    21,   175,    23,     7,
     220,     9,    39,    31,    32,    42,    71,    39,    71,     7,
      42,     9,    15,   102,    43,    80,    81,    43,    10,   197,
      12,    71,    10,   112,    12,   257,    43,   245,    43,   247,
      80,    81,     5,    17,    71,   124,   125,   126,   127,    71,
      10,   130,    12,    80,    81,   138,   139,     9,    80,    81,
      16,    10,   272,    12,    10,    39,    12,     9,    42,   237,
      17,     3,     4,     5,     6,   177,   155,     8,   180,   287,
     292,     9,   290,   138,   139,    10,    25,    12,   256,   191,
      26,    25,    39,    17,     9,    42,    26,    71,   138,   139,
       9,   313,   310,    10,     9,    12,    80,    81,    43,     9,
      29,   138,   139,     5,     6,    39,   138,   139,    42,    41,
      18,    19,    20,    21,    71,    40,    41,    42,    43,    44,
      52,     8,   211,    80,    81,    43,    44,    45,    46,   241,
      40,    41,    42,    43,    44,    40,     8,    71,     8,     8,
       8,    73,    74,    75,    76,   257,    80,    81,     3,     4,
       5,     6,     9,   242,   138,   139,    88,    12,    29,    43,
      17,    79,   251,     9,    82,    83,    84,    85,     8,   258,
      43,   283,   259,    33,    34,    35,    36,    37,    38,    14,
      43,   138,   139,    40,    41,    42,    43,    44,     9,     8,
     279,     9,    22,    23,    24,    10,    10,   286,    28,    12,
      30,    12,    10,    27,   138,   139,    22,    23,    24,    43,
      27,    40,    28,    43,    30,    18,    19,    20,    21,   137,
      27,    27,   140,   141,   142,   143,    12,    43,     3,     4,
       5,     6,    10,    12,    11,    10,    11,     3,     4,     5,
       6,     3,     4,     5,     6,    11,    40,     7,    10,     3,
       4,     5,     6,     9,     9,     8,    10,     8,    43,    40,
      12,    10,    12,    11,    11,     9,    12,    40,    40,    12,
       9,    12,    10,    10,     7,    10,     8,     8,    43,    40,
      10,    10,    10,    10,     8,    10,    12,     8,    10,     9,
       9,   249,    10,   320,    39,    12,   326,   299,   262,   238,
      40,    43,    16,    39,   300,    -1,    40,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    40
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    18,    19,    20,    21,    46,    47,    48,    49,     0,
      13,    57,    18,    19,    20,    21,    52,    58,    59,    60,
      61,    62,    15,    43,    43,    47,    22,    23,    24,    28,
      30,    43,    53,    56,    73,    76,    77,    78,    79,    80,
      84,    85,    86,    88,    89,    92,    96,    43,    58,    58,
      58,    43,    58,     5,    63,     9,     9,     9,    40,    41,
      42,    43,    44,    74,    81,    74,    81,     9,     7,     9,
      16,     8,    54,    25,    26,    25,    26,    55,    56,    73,
      80,    86,    88,    89,    92,    96,    43,    71,    72,    73,
      80,    86,    88,    89,    92,    96,    71,    55,    54,    54,
      54,    54,     7,    12,    39,    64,    65,    67,    69,     9,
      71,    40,     7,    12,    39,    66,    43,    87,    42,    87,
      90,    74,    81,     9,     3,     4,     5,     6,    87,    94,
       9,    17,    74,    40,    43,    75,    56,    73,    80,    86,
      88,    89,    92,    96,    71,    71,    71,    71,    54,    55,
      55,    54,    54,    54,    54,     7,    29,    71,     8,     8,
       8,     8,     8,    29,    74,    43,     9,     8,    43,    50,
      14,    74,    43,     9,     8,     9,    10,    12,    91,    10,
      12,    10,    10,    11,    10,    11,    75,    74,    74,    74,
      74,    12,    95,    10,    74,    43,    10,    12,    54,    55,
      55,    54,    54,    54,    54,    27,    27,    27,    27,    74,
      64,     7,    39,    64,    40,    12,    51,    10,    11,    66,
      63,    40,    75,    87,    87,    90,    33,    34,    35,    36,
      37,    38,    83,    31,    32,    82,    10,    12,    87,    12,
      93,     9,     7,    75,     8,    74,     9,    10,    12,    43,
       8,     7,    66,    10,    12,    10,    12,    12,    11,    11,
      75,    95,     9,    87,    97,    74,    10,    64,    40,    64,
      40,    51,    74,    12,    68,    40,    75,    90,    74,     9,
      81,    10,    94,    12,    98,    10,     7,    10,    12,     8,
      10,    66,    43,     8,    10,    10,    10,    74,    10,    10,
      87,    74,    64,    40,    64,    63,    12,    70,    93,    98,
      10,     8,    39,    43,     8,    64,     9,    63,    40,    39,
      10,     9,    68,    40,    12,    40,    10,    70
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 62 "syntaxique.y"
    {printf("\n\nCode correct!\n\n"); YYACCEPT;;}
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 66 "syntaxique.y"
    {emp=0;;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 70 "syntaxique.y"
    { 
            if (idf_existe((yyvsp[(3) - (6)].str),-1,"Fonction")) {
              printf("\nFile '%s', line %d, character %d: semantic error : Double function declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(3) - (6)].str));
              YYABORT;
            }
            sprintf(para,"%d",param); 
            miseajour((yyvsp[(3) - (6)].str),"Fonction",(yyvsp[(1) - (6)].str),"-1",para,"/","/","-1","SYNTAXIQUE");
            param=0;
          ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 81 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 82 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 83 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 84 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 88 "syntaxique.y"
    { 
            sprintf(empla,"LOCAL %d",emp);
            miseajour((yyvsp[(1) - (2)].str),"Parametre","/","/","/","/","/",empla,"SYNTAXIQUE");
            param++;
          ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 97 "syntaxique.y"
    { 
            sprintf(empla,"LOCAL %d",emp);
            miseajour((yyvsp[(2) - (3)].str),"Parametre","/","/","/","/","/",empla,"SYNTAXIQUE");
            param++;
          ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 105 "syntaxique.y"
    {emp++;;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 112 "syntaxique.y"
    {param=0;;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 124 "syntaxique.y"
    {param=0;;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 134 "syntaxique.y"
    {param=0;;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 139 "syntaxique.y"
    { 
              diviserChaine((yyvsp[(3) - (3)].str),partie1_1,partie1_2);
              if (!idf_existe((yyvsp[(1) - (3)].str),emp,"Fonction")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Wrong function return '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (3)].str));
                YYABORT;
              }
              strcpy(typeIDF,getType((yyvsp[(1) - (3)].str),emp,"Fonction"));
              if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
              }
              remplir_quad("=",partie1_2,"<vide>",(yyvsp[(1) - (3)].str));
              miseajour((yyvsp[(1) - (3)].str),"Fonction","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
            ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 157 "syntaxique.y"
    { miseajour((yyvsp[(2) - (6)].str),"Programme Principal","/","/","/","/","/","GLOBAL","SYNTAXIQUE");;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 166 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));strcpy(savet,(yyvsp[(1) - (1)].str));;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 167 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));strcpy(savet,(yyvsp[(1) - (1)].str));;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 168 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));strcpy(savet,(yyvsp[(1) - (1)].str));;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 172 "syntaxique.y"
    { 
                if (idf_existe((yyvsp[(2) - (4)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (4)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (4)].str),emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (4)].str));
                  YYABORT;
                }
                if (emp==0)
                  miseajour((yyvsp[(2) - (4)].str),"Variable",(yyvsp[(1) - (4)].str),"-1","/","/","/","GLOBAL","SYNTAXIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour((yyvsp[(2) - (4)].str),"Variable",(yyvsp[(1) - (4)].str),"-1","/","/","/",empla,"SYNTAXIQUE");
                }
              ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 185 "syntaxique.y"
    { 
                diviserChaine((yyvsp[(4) - (6)].str),partie1_1,partie1_2);
                if (idf_existe((yyvsp[(2) - (6)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (6)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (6)].str),emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (6)].str));
                  YYABORT;
                }
                if (emp==0)
                  miseajour((yyvsp[(2) - (6)].str),"Variable",(yyvsp[(1) - (6)].str),partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour((yyvsp[(2) - (6)].str),"Variable",(yyvsp[(1) - (6)].str),partie1_2,"/","/","/",empla,"SEMANTIQUE");
                }
                if (strcmp((yyvsp[(1) - (6)].str),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                  if(strcmp((yyvsp[(1) - (6)].str),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                remplir_quad("=",partie1_2,"<vide>",(yyvsp[(2) - (6)].str));
              ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 206 "syntaxique.y"
    { 
                if (idf_existe((yyvsp[(2) - (5)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (5)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (5)].str),emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (5)].str));
                  YYABORT;
                }
                if (emp==0)
                  miseajour((yyvsp[(2) - (5)].str),"Variable",(yyvsp[(1) - (5)].str),"-1",(yyvsp[(3) - (5)].str),"/","/","GLOBAL","SYNTAXIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour((yyvsp[(2) - (5)].str),"Variable",(yyvsp[(1) - (5)].str),"-1",(yyvsp[(3) - (5)].str),"/","/",empla,"SYNTAXIQUE");
                }
              ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 219 "syntaxique.y"
    {
                diviserChaine((yyvsp[(5) - (7)].str),partie1_1,partie1_2);
                if (idf_existe((yyvsp[(2) - (7)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (7)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (7)].str),emp,"Matrice")) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (7)].str));
                  YYABORT;
                }
                if (emp==0)
                  miseajour((yyvsp[(2) - (7)].str),"Variable",(yyvsp[(1) - (7)].str),partie1_2,(yyvsp[(3) - (7)].str),"/","/","GLOBAL","SEMANTIQUE");
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  miseajour((yyvsp[(2) - (7)].str),"Variable",(yyvsp[(1) - (7)].str),partie1_2,(yyvsp[(3) - (7)].str),"/","/",empla,"SEMANTIQUE");
                }
                if (strcmp((yyvsp[(1) - (7)].str),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                if (!verif_char((yyvsp[(2) - (7)].str),emp,"Variable",partie1_2)) {
                  printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                remplir_quad("=",partie1_2,"<vide>",(yyvsp[(2) - (7)].str));
              ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 244 "syntaxique.y"
    { 
              if (idf_existe((yyvsp[(2) - (8)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (8)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (8)].str),emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (8)].str));
                YYABORT;
              }
              if (emp==0)
                miseajour((yyvsp[(2) - (8)].str),"Vecteur",(yyvsp[(1) - (8)].str),"/",(yyvsp[(5) - (8)].str),(yyvsp[(5) - (8)].str),"/","GLOBAL","SYNTAXIQUE");
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour((yyvsp[(2) - (8)].str),"Vecteur",(yyvsp[(1) - (8)].str),"/",(yyvsp[(5) - (8)].str),(yyvsp[(5) - (8)].str),"/",empla,"SYNTAXIQUE");
              }
              if(atof((yyvsp[(5) - (8)].str))<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",(yyvsp[(5) - (8)].str),"<vide>");
              remplir_quad("ADEC",(yyvsp[(2) - (8)].str),"<vide>","<vide>");
            ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 263 "syntaxique.y"
    { 
              sprintf(taille,"%d",atoi((yyvsp[(6) - (9)].str))*atoi((yyvsp[(3) - (9)].str)));
              if (idf_existe((yyvsp[(2) - (9)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (9)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (9)].str),emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (9)].str));
                YYABORT;
              }
              if (emp==0)
                miseajour((yyvsp[(2) - (9)].str),"Vecteur",(yyvsp[(1) - (9)].str),"/",taille,(yyvsp[(6) - (9)].str),"/","GLOBAL","SYNTAXIQUE");  
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour((yyvsp[(2) - (9)].str),"Vecteur",(yyvsp[(1) - (9)].str),"/",taille,(yyvsp[(6) - (9)].str),"/",empla,"SYNTAXIQUE");  
              }
              if(atof((yyvsp[(6) - (9)].str))<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",(yyvsp[(5) - (9)].str),"<vide>");
              remplir_quad("ADEC",(yyvsp[(2) - (9)].str),"<vide>","<vide>");
            ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 285 "syntaxique.y"
    { 
              sprintf(taille,"%d",atoi((yyvsp[(5) - (10)].str))*atoi((yyvsp[(7) - (10)].str)));
              if (idf_existe((yyvsp[(2) - (10)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (10)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (10)].str),emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (10)].str));
                YYABORT;
              }
              if (emp==0)
                miseajour((yyvsp[(2) - (10)].str),"Matrice",(yyvsp[(1) - (10)].str),"/",taille,(yyvsp[(5) - (10)].str),(yyvsp[(7) - (10)].str),"GLOBAL","SYNTAXIQUE");
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour((yyvsp[(2) - (10)].str),"Matrice",(yyvsp[(1) - (10)].str),"/",taille,(yyvsp[(5) - (10)].str),(yyvsp[(7) - (10)].str),empla,"SYNTAXIQUE"); 
              }
              if(atof((yyvsp[(5) - (10)].str))<1 || atof((yyvsp[(7) - (10)].str))<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",(yyvsp[(5) - (10)].str),"<vide>");
              remplir_quad("BOUNDS","2",(yyvsp[(7) - (10)].str),"<vide>");
              remplir_quad("ADEC",(yyvsp[(2) - (10)].str),"<vide>","<vide>");
            ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 306 "syntaxique.y"
    { 
              sprintf(taille,"%d",atoi((yyvsp[(6) - (11)].str))*atoi((yyvsp[(8) - (11)].str))*atoi((yyvsp[(3) - (11)].str)));
              if (idf_existe((yyvsp[(2) - (11)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (11)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (11)].str),emp,"Matrice")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (11)].str));
                YYABORT;
              }
              if (emp==0)
                miseajour((yyvsp[(2) - (11)].str),"Matrice",(yyvsp[(1) - (11)].str),"/",taille,(yyvsp[(6) - (11)].str),(yyvsp[(8) - (11)].str),"GLOBAL","SYNTAXIQUE");
              else {
                sprintf(empla,"LOCAL %d",emp); 
                miseajour((yyvsp[(2) - (11)].str),"Matrice",(yyvsp[(1) - (11)].str),"/",taille,(yyvsp[(6) - (11)].str),(yyvsp[(8) - (11)].str),empla,"SYNTAXIQUE"); 
              }
              if(atof((yyvsp[(6) - (11)].str))<1 || atof((yyvsp[(8) - (11)].str))<1){
                printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                YYABORT;
              }
              remplir_quad("BOUNDS","1",(yyvsp[(5) - (11)].str),"<vide>");
              remplir_quad("BOUNDS","2",(yyvsp[(7) - (11)].str),"<vide>");
              remplir_quad("ADEC",(yyvsp[(2) - (11)].str),"<vide>","<vide>");
            ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 329 "syntaxique.y"
    {
              (yyval.str)=strdup((yyvsp[(2) - (2)].str));
            ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 333 "syntaxique.y"
    {
              (yyval.str)=strdup("1");
            ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 345 "syntaxique.y"
    {  
                    if (idf_existe((yyvsp[(2) - (3)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (3)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (3)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (3)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (3)].str),"Variable",savet,"-1","/","/","/","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (3)].str),"Variable",savet,"-1","/","/","/",empla,"SYNTAXIQUE");
                    }
                  ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 358 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(4) - (5)].str),partie1_1,partie1_2);
                    if (idf_existe((yyvsp[(2) - (5)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (5)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (5)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (5)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (5)].str),"Variable",savet,partie1_2,"/","/","/","GLOBAL","SEMANTIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (5)].str),"Variable",savet,partie1_2,"/","/","/",empla,"SEMANTIQUE");
                    }
                    if (strcmp(getType((yyvsp[(2) - (5)].str),emp,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(getType((yyvsp[(2) - (5)].str),emp,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(getType((yyvsp[(2) - (5)].str),emp,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char((yyvsp[(2) - (5)].str),emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",(yyvsp[(2) - (5)].str));
                  ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 387 "syntaxique.y"
    { 
                    if (idf_existe((yyvsp[(2) - (4)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (4)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (4)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (4)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (4)].str),"Variable","CHARACTER","-1",(yyvsp[(3) - (4)].str),"/","/","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (4)].str),"Variable","CHARACTER","-1",(yyvsp[(3) - (4)].str),"/","/",empla,"SYNTAXIQUE");
                    }
                  ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 400 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(5) - (6)].str),partie1_1,partie1_2);
                    if (emp==0)
                      miseajour((yyvsp[(2) - (6)].str),"Variable","CHARACTER",partie1_2,(yyvsp[(3) - (6)].str),"/","/","GLOBAL","SEMANTIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (6)].str),"Variable","CHARACTER",partie1_2,(yyvsp[(3) - (6)].str),"/","/",empla,"SEMANTIQUE");
                    }
                    if (strcmp(getType((yyvsp[(2) - (6)].str),emp,"Variable"),partie1_1)!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(getType((yyvsp[(2) - (6)].str),emp,"Variable"),"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(getType((yyvsp[(2) - (6)].str),emp,"Variable"),"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char((yyvsp[(2) - (6)].str),emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",(yyvsp[(2) - (6)].str));
                  ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 426 "syntaxique.y"
    { 
                    if (idf_existe((yyvsp[(2) - (7)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (7)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (7)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (7)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (7)].str),"Vecteur",savet,"/",(yyvsp[(5) - (7)].str),(yyvsp[(5) - (7)].str),"-1","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (7)].str),"Vecteur",savet,"/",(yyvsp[(5) - (7)].str),(yyvsp[(5) - (7)].str),"-1",empla,"SYNTAXIQUE");
                    }
                    if(atof((yyvsp[(5) - (7)].str))<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",(yyvsp[(5) - (7)].str),"<vide>");
                    remplir_quad("ADEC",(yyvsp[(2) - (7)].str),"<vide>","<vide>");
                  ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 447 "syntaxique.y"
    { 
                    sprintf(taille,"%d",atoi((yyvsp[(6) - (8)].str))*atoi((yyvsp[(3) - (8)].str)));
                    if (idf_existe((yyvsp[(2) - (8)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (8)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (8)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (8)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (8)].str),"Vecteur","CHARACTER","/",taille,(yyvsp[(6) - (8)].str),"-1","GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (8)].str),"Vecteur","CHARACTER","/",taille,(yyvsp[(6) - (8)].str),"-1",empla,"SYNTAXIQUE");
                    } 
                    if(atof((yyvsp[(6) - (8)].str))<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of vector.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",(yyvsp[(5) - (8)].str),"<vide>");
                    remplir_quad("ADEC",(yyvsp[(2) - (8)].str),"<vide>","<vide>");
                  ;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 470 "syntaxique.y"
    { 
                    sprintf(taille,"%d",atoi((yyvsp[(5) - (9)].str))*atoi((yyvsp[(7) - (9)].str)));
                    if (idf_existe((yyvsp[(2) - (9)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (9)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (9)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (9)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (9)].str),"Matrice",savet,"/",taille,(yyvsp[(5) - (9)].str),(yyvsp[(7) - (9)].str),"GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (9)].str),"Matrice",savet,"/",taille,(yyvsp[(5) - (9)].str),(yyvsp[(7) - (9)].str),empla,"SYNTAXIQUE");
                    } 
                    if(atof((yyvsp[(5) - (9)].str))<1 || atof((yyvsp[(7) - (9)].str))<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",(yyvsp[(5) - (9)].str),"<vide>");
                    remplir_quad("BOUNDS","2",(yyvsp[(7) - (9)].str),"<vide>");
                    remplir_quad("ADEC",(yyvsp[(2) - (9)].str),"<vide>","<vide>");
                  ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 493 "syntaxique.y"
    { 
                    sprintf(taille,"%d",atoi((yyvsp[(6) - (10)].str))*atoi((yyvsp[(8) - (10)].str))*atoi((yyvsp[(3) - (10)].str)));
                    if (idf_existe((yyvsp[(2) - (10)].str),emp,"Variable") || idf_existe((yyvsp[(2) - (10)].str),emp,"Vecteur") || idf_existe((yyvsp[(2) - (10)].str),emp,"Matrice")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Double declaration '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(2) - (10)].str));
                      YYABORT;
                    }
                    if (emp==0)
                      miseajour((yyvsp[(2) - (10)].str),"Matrice","CHARACTER","/",taille,(yyvsp[(6) - (10)].str),(yyvsp[(8) - (10)].str),"GLOBAL","SYNTAXIQUE");
                    else {
                      sprintf(empla,"LOCAL %d",emp); 
                      miseajour((yyvsp[(2) - (10)].str),"Matrice","CHARACTER","/",taille,(yyvsp[(6) - (10)].str),(yyvsp[(8) - (10)].str),empla,"SYNTAXIQUE");
                    } 
                    if(atof((yyvsp[(6) - (10)].str))<1 || atof((yyvsp[(8) - (10)].str))<1){
                      printf("\nFile '%s', line %d, character %d: semantic error : Negative dimension of matrix.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    remplir_quad("BOUNDS","1",(yyvsp[(5) - (10)].str),"<vide>");
                    remplir_quad("BOUNDS","2",(yyvsp[(7) - (10)].str),"<vide>");
                    remplir_quad("ADEC",(yyvsp[(2) - (10)].str),"<vide>","<vide>");
                  ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 526 "syntaxique.y"
    {param=0;;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 530 "syntaxique.y"
    { 
                    if (!idf_existe((yyvsp[(1) - (3)].str),emp,"Variable") && !idf_existe((yyvsp[(1) - (3)].str),emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (3)].str));
                      YYABORT;
                    }
                    diviserChaine((yyvsp[(3) - (3)].str),partie1_1,partie1_2);
                    strcpy(typeIDF,getType((yyvsp[(1) - (3)].str),emp,"Variable"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                          printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char((yyvsp[(1) - (3)].str),emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    remplir_quad("=",partie1_2,"<vide>",(yyvsp[(1) - (3)].str));
                    miseajour((yyvsp[(1) - (3)].str),"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                  ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 553 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(6) - (6)].str),partie1_1,partie1_2);
                    if (!idf_existe((yyvsp[(1) - (6)].str),emp,"Vecteur") && !idf_existe((yyvsp[(1) - (6)].str),emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (6)].str));
                      YYABORT;
                    }
                    strcpy(typeIDF,getType((yyvsp[(1) - (6)].str),emp,"Vecteur"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char((yyvsp[(1) - (6)].str),emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcat(tab,(yyvsp[(1) - (6)].str));strcat(tab,(yyvsp[(2) - (6)].str));strcat(tab,(yyvsp[(3) - (6)].str));strcat(tab,(yyvsp[(4) - (6)].str));
                    remplir_quad("=",partie1_2,"<vide>",tab);
                    miseajour((yyvsp[(1) - (6)].str),"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    strcpy(tab," ");
                  ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 578 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(8) - (8)].str),partie1_1,partie1_2);
                    if (!idf_existe((yyvsp[(1) - (8)].str),emp,"Matrice") && !idf_existe((yyvsp[(1) - (8)].str),emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (8)].str));
                      YYABORT;
                    }
                    strcpy(typeIDF,getType((yyvsp[(1) - (8)].str),emp,"Matrice"));
                    if (strcmp(typeIDF,partie1_1)!=0 && strcmp(typeIDF,"/")!=0 && strcmp(partie1_1,"/")!=0) {
                      if(strcmp(typeIDF,"REAL")!=0 || strcmp(partie1_1,"INTEGER")!=0 ){
                        printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    if(strcmp(typeIDF,"CHARACTER")==0 && strcmp(partie1_1,"CHARACTER")==0 ){
                      if (!verif_char((yyvsp[(1) - (8)].str),emp,"Variable",partie1_2)) {
                        printf("\nFile '%s', line %d, character %d: semantic error : String too long'.\n",file_name,nb_line,nb_character);
                        YYABORT;
                      }
                    }
                    strcat(tab,(yyvsp[(1) - (8)].str));strcat(tab,(yyvsp[(2) - (8)].str));strcat(tab,(yyvsp[(3) - (8)].str));strcat(tab,(yyvsp[(4) - (8)].str));strcat(tab,(yyvsp[(5) - (8)].str));strcat(tab,(yyvsp[(6) - (8)].str));
                    remplir_quad("=",partie1_2,"<vide>",tab);
                    miseajour((yyvsp[(1) - (8)].str),"Variable","-1",partie1_2,"-1","-1","-1","-1","SEMANTIQUE");
                    strcpy(tab," ");
                  ;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 605 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(1) - (3)].str),partie1_1,partie1_2);
                    diviserChaine((yyvsp[(3) - (3)].str),partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                      strcpy(cat,"REAL-");
                      strcat(cat,temp);
                      (yyval.str)=strdup(cat);
                    }
                    else{
                      strcpy(cat,"INTEGER-");
                      strcat(cat,temp);
                      (yyval.str)=strdup(cat);
                    }
                    remplir_quad("+",partie1_2,partie2_2,temp);
                    tmp++;
                  ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 627 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(1) - (3)].str),partie1_1,partie1_2);
                    diviserChaine((yyvsp[(3) - (3)].str),partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                      strcpy(cat,"REAL-");
                      strcat(cat,temp);
                      (yyval.str)=strdup(cat);
                    }
                    else{
                      strcpy(cat,"INTEGER-");
                      strcat(cat,temp);
                      (yyval.str)=strdup(cat);
                    }
                    remplir_quad("-",partie1_2,partie2_2,temp);
                    tmp++;
                  ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 649 "syntaxique.y"
    { 
                    diviserChaine((yyvsp[(1) - (3)].str),partie1_1,partie1_2);
                    diviserChaine((yyvsp[(3) - (3)].str),partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"REAL") == 0 || strcmp(partie2_1,"REAL") == 0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0){
                      strcpy(cat,"REAL-");
                      strcat(cat,temp);
                      (yyval.str)=strdup(cat);
                    }
                    else{
                      strcpy(cat,"INTEGER-");
                      strcat(cat,temp);
                      (yyval.str)=strdup(cat);
                    }
                    remplir_quad("*",partie1_2,partie2_2,temp);
                    tmp++;
                  ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 671 "syntaxique.y"
    {  
                    diviserChaine((yyvsp[(1) - (3)].str),partie1_1,partie1_2);
                    diviserChaine((yyvsp[(3) - (3)].str),partie2_1,partie2_2);
                    sprintf(temp,"T%d",tmp);
                    if (strcmp(partie2_2,"0") == 0) { 
                      printf("\nFile '%s', line %d, character %d: semantic error : Division by zero.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    if (strcmp(partie1_1,"CHARACTER") == 0 || strcmp(partie1_1,"LOGICAL") == 0 || strcmp(partie2_1,"CHARACTER") == 0 || strcmp(partie2_1,"LOGICAL") == 0) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                      YYABORT;
                    }
                    strcpy(cat,"REAL-");
                    strcat(cat,temp);
                    (yyval.str)=strdup(cat);
                    remplir_quad("/",partie1_2,partie2_2,temp);
                    tmp++;
                  ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 690 "syntaxique.y"
    { 
                    if (!idf_existe((yyvsp[(1) - (1)].str),emp,"Variable") && !idf_existe((yyvsp[(1) - (1)].str),emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (1)].str));
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(ch,(yyvsp[(1) - (1)].str));
                    if (idf_existe((yyvsp[(1) - (1)].str),emp,"Variable")) strcpy(cat,getType((yyvsp[(1) - (1)].str),emp,"Variable"));
                    if (idf_existe((yyvsp[(1) - (1)].str),emp,"Parametre")) strcpy(cat,getType((yyvsp[(1) - (1)].str),emp,"Parametre"));
                    strcat(cat,ch);
                    (yyval.str)=strdup(cat);
                  ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 703 "syntaxique.y"
    {
                    if (!idf_existe((yyvsp[(1) - (4)].str),emp,"Vecteur") && !idf_existe((yyvsp[(1) - (4)].str),emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (4)].str));
                      YYABORT;
                    }
                    if (!verif_index((yyvsp[(1) - (4)].str),emp,"Vecteur",(yyvsp[(3) - (4)].str),"Ligne")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s)'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (4)].str),(yyvsp[(3) - (4)].str));
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(tab,(yyvsp[(1) - (4)].str));strcat(tab,(yyvsp[(2) - (4)].str));strcat(tab,(yyvsp[(3) - (4)].str));strcat(tab,(yyvsp[(4) - (4)].str));
                    strcat(ch,tab);
                    strcpy(tab," ");
                    if (idf_existe((yyvsp[(1) - (4)].str),emp,"Vecteur")) strcpy(cat,getType((yyvsp[(1) - (4)].str),emp,"Vecteur"));
                    if (idf_existe((yyvsp[(1) - (4)].str),emp,"Parametre")) strcpy(cat,getType((yyvsp[(1) - (4)].str),emp,"Parametre"));
                    strcat(cat,ch);
                    (yyval.str)=strdup(cat);
                  ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 722 "syntaxique.y"
    {
                    if (!idf_existe((yyvsp[(1) - (6)].str),emp,"Matrice") && !idf_existe((yyvsp[(1) - (6)].str),emp,"Parametre")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (6)].str));
                      YYABORT;
                    }
                    if (!verif_index((yyvsp[(1) - (6)].str),emp,"Matrice",(yyvsp[(3) - (6)].str),"Ligne") || !verif_index((yyvsp[(1) - (6)].str),emp,"Matrice",(yyvsp[(5) - (6)].str),"Colonne")) {
                      printf("\nFile '%s', line %d, character %d: semantic error : Index out of range '%s(%s,%s)'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (6)].str),(yyvsp[(3) - (6)].str),(yyvsp[(5) - (6)].str));
                      YYABORT;
                    }
                    strcpy(ch,"-");
                    strcat(tab,(yyvsp[(1) - (6)].str));strcat(tab,(yyvsp[(2) - (6)].str));strcat(tab,(yyvsp[(3) - (6)].str));strcat(tab,(yyvsp[(4) - (6)].str));strcat(tab,(yyvsp[(5) - (6)].str));strcat(tab,(yyvsp[(6) - (6)].str));
                    strcat(ch,tab);
                    strcpy(tab," ");
                    if (idf_existe((yyvsp[(1) - (6)].str),emp,"Matrice")) strcpy(cat,getType((yyvsp[(1) - (6)].str),emp,"Matrice"));
                    if (idf_existe((yyvsp[(1) - (6)].str),emp,"Parametre")) strcpy(cat,getType((yyvsp[(1) - (6)].str),emp,"Parametre"));
                    strcat(cat,ch);
                    (yyval.str)=strdup(cat);
                  ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 741 "syntaxique.y"
    {
                strcpy(cat,"REAL-");
                strcat(cat,(yyvsp[(1) - (1)].str));
                (yyval.str)=strdup(cat);
              ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 747 "syntaxique.y"
    {
                strcpy(cat,"INTEGER-");
                strcat(cat,(yyvsp[(1) - (1)].str));
                (yyval.str)=strdup(cat);
              ;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 753 "syntaxique.y"
    {
                strcpy(cat,"LOGICAL-");
                strcat(cat,(yyvsp[(1) - (1)].str));
                (yyval.str)=strdup(cat);
              ;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 759 "syntaxique.y"
    {
                strcpy(cat,"CHARACTER-");
                strcat(cat,(yyvsp[(1) - (1)].str));
                (yyval.str)=strdup(cat);
              ;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 765 "syntaxique.y"
    {
                (yyval.str)=strdup((yyvsp[(2) - (3)].str));
              ;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 771 "syntaxique.y"
    { 
          if (!idf_existe((yyvsp[(1) - (1)].str),emp,"Variable") && !idf_existe((yyvsp[(1) - (1)].str),emp,"Parametre")) {
            printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (1)].str));
            YYABORT;
          }
          strcpy(typeIDF,getType((yyvsp[(1) - (1)].str),emp,"Variable"));
          if(strcmp(typeIDF,"INTEGER")!=0){
            printf("\nFile '%s', line %d, character %d: semantic error : Unexpected index type '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (1)].str));
            YYABORT;
          }
          else{
            if(atof((yyvsp[(1) - (1)].str))<1){
              printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
              YYABORT;
            }
          }
        ;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 789 "syntaxique.y"
    {
          if(atof((yyvsp[(1) - (1)].str))<1){
              printf("\nFile '%s', line %d, character %d: semantic error : Negative index value.\n",file_name,nb_line,nb_character);
              YYABORT;
          }
          (yyval.str)=strdup((yyvsp[(1) - (1)].str));
        ;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 799 "syntaxique.y"
    {
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",(yyvsp[(2) - (2)].str),"<vide>");
              ;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 807 "syntaxique.y"
    {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              ;}
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 816 "syntaxique.y"
    {
                diviserChaine((yyvsp[(2) - (2)].str),partie1_1,partie1_2);
                if (strcmp(partie1_1,"LOGICAL")!=0 && strcmp(partie1_1,"/")!=0){
                  printf("\nFile '%s', line %d, character %d: semantic error : Unexpected expression type.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
                deb_else=qc;
                fin_if=qc;
                remplir_quad("BNZ"," ",partie1_2,"<vide>");
                
              ;}
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 830 "syntaxique.y"
    {
                fin_if=qc;
                remplir_quad("BR"," ","<vide>","<vide>");
                sprintf(i,"%d",qc); 
                mise_jr_quad(deb_else,2,i);
              ;}
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 839 "syntaxique.y"
    {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              ;}
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 844 "syntaxique.y"
    {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              ;}
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 849 "syntaxique.y"
    {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              ;}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 854 "syntaxique.y"
    {
                sprintf(i,"%d",qc);
                mise_jr_quad(fin_if,2,i);
              ;}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 861 "syntaxique.y"
    { 
                diviserChaine((yyvsp[(2) - (7)].str),partie1_1,partie1_2);
                diviserChaine((yyvsp[(6) - (7)].str),partie2_1,partie2_2);
                sprintf(temp,"T%d",tmp);
                if (strcmp(partie2_1,partie1_1)!=0 && strcmp(partie1_1,"/")!=0 && strcmp(partie2_1,"/")!=0) {
                  if(!((strcmp(partie1_1,"REAL")==0 && strcmp(partie2_1,"INTEGER")==0) || (strcmp(partie2_1,"REAL")==0 && strcmp(partie1_1,"INTEGER")==0))){
                    printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                    YYABORT;
                  }
                }
                (yyval.str)=strdup(temp);
                remplir_quad((yyvsp[(4) - (7)].str),partie1_2,partie2_2,temp);
                tmp++;
              ;}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 876 "syntaxique.y"
    {
                sprintf(temp,"T%d",tmp);
                (yyval.str)=strdup(temp);
                remplir_quad((yyvsp[(4) - (7)].str),(yyvsp[(2) - (7)].str),(yyvsp[(6) - (7)].str),temp);
                tmp++;
              ;}
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 883 "syntaxique.y"
    {
                (yyval.str)=strdup((yyvsp[(2) - (3)].str));
              ;}
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 888 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 889 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 892 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 893 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 894 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 895 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 896 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 117:

/* Line 1455 of yacc.c  */
#line 897 "syntaxique.y"
    {(yyval.str)=strdup((yyvsp[(1) - (1)].str));;}
    break;

  case 118:

/* Line 1455 of yacc.c  */
#line 901 "syntaxique.y"
    {
                  fin_dowhile=qc;
                  deb_dowhile=qc;
                  remplir_quad("BNZ"," ",(yyvsp[(2) - (2)].str),"<vide>");
                ;}
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 909 "syntaxique.y"
    {
                  diviserChaine((yyvsp[(2) - (2)].str),partie1_1,partie1_2);
                  fin_dowhile=qc;
                  remplir_quad("BNZ"," ",partie1_1,"<vide>");
                ;}
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 917 "syntaxique.y"
    {
                  sprintf(i,"%d",deb_dowhile);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_dowhile,2,i);
                ;}
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 924 "syntaxique.y"
    {
                  sprintf(i,"%d",deb_dowhile);
                  remplir_quad("BR",i,"<vide>","<vide>");
                  sprintf(i,"%d",qc);
                  mise_jr_quad(fin_dowhile,2,i);
                ;}
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 933 "syntaxique.y"
    { 
                  if (!idf_existe((yyvsp[(1) - (1)].str),emp,"Variable") && !idf_existe((yyvsp[(1) - (1)].str),emp,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (1)].str));
                    YYABORT;
                  }
                  (yyval.str)=strdup((yyvsp[(1) - (1)].str));
                ;}
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 941 "syntaxique.y"
    { 
                  if (!idf_existe((yyvsp[(1) - (4)].str),emp,"Vecteur") && !idf_existe((yyvsp[(1) - (4)].str),emp,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (4)].str));
                    YYABORT;
                  }
                  (yyval.str)=strdup((yyvsp[(1) - (4)].str));
                ;}
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 949 "syntaxique.y"
    { 
                  if (!idf_existe((yyvsp[(1) - (6)].str),emp,"Matrice") && !idf_existe((yyvsp[(1) - (6)].str),emp,"Parametre")) {
                    printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (6)].str));
                    YYABORT;
                  }
                  (yyval.str)=strdup((yyvsp[(1) - (6)].str));
                ;}
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 962 "syntaxique.y"
    {
            rechercher((yyvsp[(3) - (4)].str),"Idf","CHARACTER","/","-1","/","/","/",3);
          ;}
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 966 "syntaxique.y"
    {
            rechercher((yyvsp[(3) - (4)].str),"Idf","CHARACTER","/","-1","/","/","/",3);
          ;}
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 972 "syntaxique.y"
    {
            strcat(tab,(yyvsp[(1) - (2)].str));strcat(tab,(yyvsp[(2) - (2)].str));
            (yyval.str)=strdup(tab);
            strcpy(tab," ");
          ;}
    break;

  case 129:

/* Line 1455 of yacc.c  */
#line 978 "syntaxique.y"
    {
            (yyval.str)=strdup((yyvsp[(1) - (1)].str));
          ;}
    break;

  case 130:

/* Line 1455 of yacc.c  */
#line 982 "syntaxique.y"
    {
            strcat(tab,(yyvsp[(1) - (3)].str));strcat(tab,(yyvsp[(2) - (3)].str));strcat(tab,(yyvsp[(3) - (3)].str));
            (yyval.str)=strdup(tab);
            strcpy(tab," ");
          ;}
    break;

  case 131:

/* Line 1455 of yacc.c  */
#line 990 "syntaxique.y"
    {
                strcat(tab,(yyvsp[(1) - (4)].str));strcat(tab,(yyvsp[(2) - (4)].str));strcat(tab,(yyvsp[(3) - (4)].str));strcat(tab,(yyvsp[(4) - (4)].str));
                (yyval.str)=strdup(tab);
                strcpy(tab," ");
              ;}
    break;

  case 132:

/* Line 1455 of yacc.c  */
#line 996 "syntaxique.y"
    {
                strcat(tab,(yyvsp[(1) - (2)].str));strcat(tab,(yyvsp[(2) - (2)].str));
                (yyval.str)=strdup(tab);
                strcpy(tab," ");
              ;}
    break;

  case 140:

/* Line 1455 of yacc.c  */
#line 1019 "syntaxique.y"
    { 
              if (!idf_existe((yyvsp[(1) - (7)].str),emp,"Variable") && !idf_existe((yyvsp[(1) - (7)].str),emp,"Parametre")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Undeclared variable '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(1) - (7)].str));
                YYABORT;
              }
              if (!idf_existe((yyvsp[(4) - (7)].str),-1,"Fonction")) {
                printf("\nFile '%s', line %d, character %d: semantic error : Undeclared function '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(4) - (7)].str));
                YYABORT;
              }
              strcpy(typeIDF,getType((yyvsp[(1) - (7)].str),emp,"Variable"));
              if (strcmp(typeIDF,getType((yyvsp[(4) - (7)].str),-1,"Fonction"))!=0 && strcmp(typeIDF,"/")!=0) {
                if(strcmp(typeIDF,"REAL")!=0 || strcmp(getType((yyvsp[(4) - (7)].str),-1,"Fonction"),"INTEGER")!=0 ){
                  printf("\nFile '%s', line %d, character %d: semantic error : Type incompatibility.\n",file_name,nb_line,nb_character);
                  YYABORT;
                }
              }
              if(!verif_param((yyvsp[(4) - (7)].str),param)){
                printf("\nFile '%s', line %d, character %d: semantic error : Uncorrect number of arguments of '%s'.\n",file_name,nb_line,nb_character,(yyvsp[(4) - (7)].str));
                YYABORT;
              }
              if (emp==0)
                  rechercher((yyvsp[(4) - (7)].str),"Idf","/","/","/","/","/","GLOBAL",3);
                else {
                  sprintf(empla,"LOCAL %d",emp); 
                  rechercher((yyvsp[(4) - (7)].str),"Idf","/","/","/","/","/",empla,3);
              }
            ;}
    break;

  case 141:

/* Line 1455 of yacc.c  */
#line 1049 "syntaxique.y"
    {
              param++;
            ;}
    break;

  case 143:

/* Line 1455 of yacc.c  */
#line 1056 "syntaxique.y"
    {
              param++;
            ;}
    break;



/* Line 1455 of yacc.c  */
#line 3013 "syntaxique.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 1062 "syntaxique.y"


int yyerror(char *msg) { 
  printf("\nFile '%s', line %d, character %d: syntax error\n",file_name,nb_line,nb_character);
  return 1; 
}

int main(int argc,char *argv[]){
  file_name=argv[1];
  initialisation();
  yyparse();
  afficher();
  affiche_quad();
  return 0;
}

int yywrap(){
  return 0;
}


