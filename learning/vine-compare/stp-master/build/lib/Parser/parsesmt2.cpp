/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

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
#define YYBISON_VERSION "3.0.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1


/* Substitute the variable and function names.  */
#define yyparse         smt2parse
#define yylex           smt2lex
#define yyerror         smt2error
#define yydebug         smt2debug
#define yynerrs         smt2nerrs

#define yylval          smt2lval
#define yychar          smt2char

/* Copy the first part of user declarations.  */
#line 1 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:339  */

  /********************************************************************
   * AUTHORS:  Trevor Hansen
   *
   * BEGIN DATE: May, 2010
   *
   * This file is modified version of the STP's smtlib.y file. Please
   * see CVCL license below
   ********************************************************************/

  /********************************************************************
   * AUTHORS: Vijay Ganesh, Trevor Hansen
   *
   * BEGIN DATE: July, 2006
   *
   * This file is modified version of the CVCL's smtlib.y file. Please
   * see CVCL license below
   ********************************************************************/

  
  /********************************************************************
   *
   * \file smtlib.y
   * 
   * Author: Sergey Berezin, Clark Barrett
   * 
   * Created: Apr 30 2005
   *
   * <hr>
   * Copyright (C) 2004 by the Board of Trustees of Leland Stanford
   * Junior University and by New York University. 
   *
   * License to use, copy, modify, sell and/or distribute this software
   * and its documentation for any purpose is hereby granted without
   * royalty, subject to the terms and conditions defined in the \ref
   * LICENSE file provided with this distribution.  In particular:
   *
   * - The above copyright notice and this permission notice must appear
   * in all copies of the software and related documentation.
   *
   * - THE SOFTWARE IS PROVIDED "AS-IS", WITHOUT ANY WARRANTIES,
   * EXPRESSED OR IMPLIED.  USE IT AT YOUR OWN RISK.
   * 
   * <hr>
   ********************************************************************/
  // -*- c++ -*-

#include "stp/cpp_interface.h"
#include "stp/Parser/LetMgr.h"

  using namespace BEEV;
  using std::cout;
  using std::cerr;
  using std::endl;

  // Suppress the bogus warning suppression in bison (it generates
  // compile error)
#undef __GNUC_MINOR__
  
  extern char* smt2text;
  extern int smt2lineno;
  extern int smt2lex(void);

  int yyerror(const char *s) {
    cout << "syntax error: line " << smt2lineno << "\n" << s << endl;
    cout << "  token: " << smt2text << endl;
    FatalError("");
    return 1;
  }

   
#define YYLTYPE_IS_TRIVIAL 1
#define YYMAXDEPTH 104857600
#define YYERROR_VERBOSE 1
#define YY_EXIT_FAILURE -1

  

#line 153 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parsesmt2.hpp".  */
#ifndef YY_SMT2_HOME_PPI_DBT_PATTERN_DBT_VINE_COMPARE_STP_MASTER_BUILD_LIB_PARSER_PARSESMT2_HPP_INCLUDED
# define YY_SMT2_HOME_PPI_DBT_PATTERN_DBT_VINE_COMPARE_STP_MASTER_BUILD_LIB_PARSER_PARSESMT2_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int smt2debug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    END = 0,
    NUMERAL_TOK = 258,
    BVCONST_DECIMAL_TOK = 259,
    BVCONST_BINARY_TOK = 260,
    BVCONST_HEXIDECIMAL_TOK = 261,
    DECIMAL_TOK = 262,
    FORMID_TOK = 263,
    TERMID_TOK = 264,
    STRING_TOK = 265,
    BITVECTOR_FUNCTIONID_TOK = 266,
    BOOLEAN_FUNCTIONID_TOK = 267,
    SOURCE_TOK = 268,
    CATEGORY_TOK = 269,
    DIFFICULTY_TOK = 270,
    VERSION_TOK = 271,
    STATUS_TOK = 272,
    PRINT_TOK = 273,
    UNDERSCORE_TOK = 274,
    LPAREN_TOK = 275,
    RPAREN_TOK = 276,
    BVLEFTSHIFT_1_TOK = 277,
    BVRIGHTSHIFT_1_TOK = 278,
    BVARITHRIGHTSHIFT_TOK = 279,
    BVPLUS_TOK = 280,
    BVSUB_TOK = 281,
    BVNOT_TOK = 282,
    BVMULT_TOK = 283,
    BVDIV_TOK = 284,
    SBVDIV_TOK = 285,
    BVMOD_TOK = 286,
    SBVREM_TOK = 287,
    SBVMOD_TOK = 288,
    BVNEG_TOK = 289,
    BVAND_TOK = 290,
    BVOR_TOK = 291,
    BVXOR_TOK = 292,
    BVNAND_TOK = 293,
    BVNOR_TOK = 294,
    BVXNOR_TOK = 295,
    BVCONCAT_TOK = 296,
    BVLT_TOK = 297,
    BVGT_TOK = 298,
    BVLE_TOK = 299,
    BVGE_TOK = 300,
    BVSLT_TOK = 301,
    BVSGT_TOK = 302,
    BVSLE_TOK = 303,
    BVSGE_TOK = 304,
    BVSX_TOK = 305,
    BVEXTRACT_TOK = 306,
    BVZX_TOK = 307,
    BVROTATE_RIGHT_TOK = 308,
    BVROTATE_LEFT_TOK = 309,
    BVREPEAT_TOK = 310,
    BVCOMP_TOK = 311,
    BITVEC_TOK = 312,
    ARRAY_TOK = 313,
    BOOL_TOK = 314,
    TRUE_TOK = 315,
    FALSE_TOK = 316,
    NOT_TOK = 317,
    AND_TOK = 318,
    OR_TOK = 319,
    XOR_TOK = 320,
    ITE_TOK = 321,
    EQ_TOK = 322,
    IMPLIES_TOK = 323,
    DISTINCT_TOK = 324,
    LET_TOK = 325,
    EXIT_TOK = 326,
    CHECK_SAT_TOK = 327,
    LOGIC_TOK = 328,
    NOTES_TOK = 329,
    OPTION_TOK = 330,
    DECLARE_FUNCTION_TOK = 331,
    DEFINE_FUNCTION_TOK = 332,
    FORMULA_TOK = 333,
    PUSH_TOK = 334,
    POP_TOK = 335,
    SELECT_TOK = 336,
    STORE_TOK = 337
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 79 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:355  */
  
  unsigned uintval;                  /* for numerals in types. */
  //ASTNode,ASTVec
  BEEV::ASTNode *node;
  BEEV::ASTVec *vec;
  std::string *str;

#line 285 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE smt2lval;

int smt2parse (void);

#endif /* !YY_SMT2_HOME_PPI_DBT_PATTERN_DBT_VINE_COMPARE_STP_MASTER_BUILD_LIB_PARSER_PARSESMT2_HPP_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 300 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:358  */

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
#else
typedef signed char yytype_int8;
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
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
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
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
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
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
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

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  15
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   801

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  83
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  17
/* YYNRULES -- Number of rules.  */
#define YYNRULES  109
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  324

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   337

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
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
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   199,   199,   207,   208,   213,   218,   223,   233,   237,
     240,   242,   244,   252,   258,   262,   266,   276,   287,   293,
     302,   322,   335,   344,   363,   381,   383,   385,   387,   389,
     391,   396,   405,   415,   423,   447,   456,   465,   474,   486,
     495,   506,   512,   518,   523,   530,   556,   580,   587,   594,
     601,   608,   615,   622,   629,   636,   640,   645,   651,   658,
     663,   668,   674,   680,   686,   692,   700,   701,   704,   718,
     736,   746,   757,   762,   766,   779,   793,   809,   817,   826,
     834,   842,   850,   858,   866,   874,   882,   898,   909,   917,
     926,   934,   943,   952,   961,   969,   977,   985,   993,  1002,
    1011,  1020,  1046,  1070,  1086,  1092,  1099,  1106,  1116,  1126
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "$undefined", "NUMERAL_TOK",
  "BVCONST_DECIMAL_TOK", "BVCONST_BINARY_TOK", "BVCONST_HEXIDECIMAL_TOK",
  "DECIMAL_TOK", "FORMID_TOK", "TERMID_TOK", "STRING_TOK",
  "BITVECTOR_FUNCTIONID_TOK", "BOOLEAN_FUNCTIONID_TOK", "SOURCE_TOK",
  "CATEGORY_TOK", "DIFFICULTY_TOK", "VERSION_TOK", "STATUS_TOK",
  "PRINT_TOK", "UNDERSCORE_TOK", "LPAREN_TOK", "RPAREN_TOK",
  "BVLEFTSHIFT_1_TOK", "BVRIGHTSHIFT_1_TOK", "BVARITHRIGHTSHIFT_TOK",
  "BVPLUS_TOK", "BVSUB_TOK", "BVNOT_TOK", "BVMULT_TOK", "BVDIV_TOK",
  "SBVDIV_TOK", "BVMOD_TOK", "SBVREM_TOK", "SBVMOD_TOK", "BVNEG_TOK",
  "BVAND_TOK", "BVOR_TOK", "BVXOR_TOK", "BVNAND_TOK", "BVNOR_TOK",
  "BVXNOR_TOK", "BVCONCAT_TOK", "BVLT_TOK", "BVGT_TOK", "BVLE_TOK",
  "BVGE_TOK", "BVSLT_TOK", "BVSGT_TOK", "BVSLE_TOK", "BVSGE_TOK",
  "BVSX_TOK", "BVEXTRACT_TOK", "BVZX_TOK", "BVROTATE_RIGHT_TOK",
  "BVROTATE_LEFT_TOK", "BVREPEAT_TOK", "BVCOMP_TOK", "BITVEC_TOK",
  "ARRAY_TOK", "BOOL_TOK", "TRUE_TOK", "FALSE_TOK", "NOT_TOK", "AND_TOK",
  "OR_TOK", "XOR_TOK", "ITE_TOK", "EQ_TOK", "IMPLIES_TOK", "DISTINCT_TOK",
  "LET_TOK", "EXIT_TOK", "CHECK_SAT_TOK", "LOGIC_TOK", "NOTES_TOK",
  "OPTION_TOK", "DECLARE_FUNCTION_TOK", "DEFINE_FUNCTION_TOK",
  "FORMULA_TOK", "PUSH_TOK", "POP_TOK", "SELECT_TOK", "STORE_TOK",
  "$accept", "cmd", "commands", "cmdi", "function_param",
  "function_params", "function_decl", "status", "attribute", "var_decl",
  "an_mixed", "an_formulas", "an_formula", "lets", "let", "an_terms",
  "an_term", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337
};
# endif

#define YYPACT_NINF -192

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-192)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      -8,    33,    15,     7,  -192,    18,    58,    28,    79,    79,
      70,    71,    17,    86,    87,  -192,  -192,  -192,  -192,  -192,
      82,  -192,  -192,  -192,  -192,    90,   -56,    81,    94,   100,
     102,   104,   105,  -192,  -192,     1,  -192,  -192,   106,   107,
     108,  -192,  -192,  -192,  -192,  -192,   109,   111,  -192,  -192,
     112,  -192,    -4,  -192,   591,   719,   719,   719,   719,   719,
     719,   719,   719,    17,    17,    17,    17,    17,   591,    17,
     591,   114,   115,  -192,  -192,  -192,  -192,  -192,   -19,   128,
     -18,  -192,    10,  -192,  -192,  -192,  -192,   121,   461,   719,
     719,   719,   719,   719,   719,   719,   719,   719,   719,   719,
     719,   719,   719,   719,   719,   719,   719,   719,   719,   719,
      17,   719,   719,   134,  -192,  -192,   362,   719,   719,   719,
     719,   719,   719,   719,   719,   120,    -2,  -192,    12,    17,
      17,    17,   719,    17,    14,   655,  -192,   124,  -192,    -5,
    -192,   127,   129,    17,    40,  -192,   146,   591,    32,    17,
     130,   131,   719,   719,   719,   719,   719,  -192,   719,   719,
     719,   719,   719,   719,  -192,   719,   719,   719,   719,   719,
     719,   719,   719,   719,   719,   719,  -192,  -192,  -192,   156,
     157,   158,   159,   161,   162,   163,   164,   166,  -192,  -192,
    -192,  -192,   167,    17,   168,   170,   171,  -192,  -192,  -192,
     141,   172,   124,   139,   178,   182,   145,  -192,   184,    17,
    -192,   527,   174,   183,   201,   202,   204,   205,   591,   124,
    -192,  -192,  -192,  -192,  -192,  -192,  -192,  -192,  -192,  -192,
    -192,  -192,  -192,  -192,  -192,  -192,  -192,  -192,  -192,  -192,
     719,  -192,   719,   124,  -192,  -192,  -192,  -192,  -192,  -192,
    -192,  -192,  -192,   188,  -192,  -192,  -192,   591,    17,  -192,
     207,   192,   155,   210,   160,  -192,  -192,   193,   215,   198,
     208,   209,   211,   213,  -192,  -192,   216,  -192,   217,   218,
     219,   220,   179,   225,   221,   228,   719,   222,   719,   719,
     719,   719,   591,   719,  -192,  -192,  -192,  -192,   241,   226,
     719,   227,  -192,   719,  -192,  -192,  -192,  -192,   229,   230,
     231,  -192,   719,  -192,  -192,   255,  -192,  -192,   260,   233,
     246,   270,   271,  -192
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     4,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     1,     2,     3,     5,     6,
       0,    25,    26,    27,    28,     0,     0,     0,     0,     0,
       0,     0,     0,    43,    65,     0,    41,    42,     0,     0,
       0,     7,    24,    29,    30,    31,     0,     0,    11,     9,
       0,    14,     0,    15,    65,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    16,    12,    13,    10,     8,     0,     0,
       0,    18,     0,   106,   105,    72,   108,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    35,    36,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    39,     0,     0,
       0,     0,     0,     0,     0,     0,    70,     0,    55,     0,
      33,     0,     0,     0,     0,    19,     0,   108,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    81,     0,     0,
       0,     0,     0,     0,    82,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    64,    37,    38,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    56,    59,
      40,    60,     0,     0,     0,     0,     0,    46,    45,    71,
       0,     0,    67,     0,     0,     0,     0,    22,     0,     0,
     104,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      73,    98,    99,   100,    89,    88,    90,    91,    93,    92,
      94,    95,    83,    84,    85,    96,    97,    86,    80,    87,
       0,    74,     0,     0,    51,    53,    52,    54,    47,    49,
      48,    50,    61,     0,    62,    44,    57,     0,     0,    66,
       0,     0,     0,     0,     0,    21,   107,     0,     0,     0,
       0,     0,     0,     0,    79,    75,     0,    58,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    68,    69,    63,    32,     0,     0,
       0,     0,    78,     0,    77,   102,   101,   103,     0,     0,
       0,    23,     0,    76,   109,     0,    17,    20,     0,     0,
       0,     0,     0,    34
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -192,  -192,  -192,   290,   212,  -192,  -192,  -192,   286,  -192,
     149,   -62,   -12,  -191,  -192,  -192,   165
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     3,     4,    81,    82,    32,    43,    27,    30,
     113,   126,   127,   201,   202,   135,   115
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint16 yytable[] =
{
      38,   139,   142,   128,    44,    45,    33,    16,   134,    33,
      34,   259,     1,    54,   203,    15,    79,    80,    35,   189,
      33,    35,    33,    72,    34,    33,    34,     1,   273,    34,
      79,   144,    35,   191,    35,   197,   146,    35,    20,    18,
     140,   143,   114,    55,    56,    57,    58,    59,    60,    61,
      62,   125,   276,   204,   129,   130,   131,   133,    36,    37,
     208,    36,    37,    63,    64,    65,    66,    67,    68,    69,
      70,    71,    36,    37,    36,    37,    72,    36,    37,    19,
      29,    31,   212,   213,   214,   215,   216,   217,    46,    39,
      40,    47,    21,    22,    23,    24,    25,    26,   173,   209,
      42,   177,    48,    41,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,   190,    49,   190,   192,   193,   194,
      50,   196,   190,    51,    52,   146,    53,    73,    74,    75,
      76,   207,    77,    78,   137,   114,   138,   218,   141,    83,
      84,   188,    33,    85,   200,    86,    34,   205,   206,   210,
     219,   257,   220,    87,    88,   176,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   243,   267,   244,   245,
     246,   253,   247,   248,   249,   250,   268,   251,   252,   254,
     109,   255,   256,   258,    36,    37,   260,   265,   261,   177,
     110,   262,   263,   264,   269,   270,   193,   271,   272,   277,
     281,   282,   283,   284,   286,   111,   112,   285,   287,   288,
     117,   118,   119,   120,   121,   122,   123,   124,   299,   289,
     290,   301,   291,   132,   292,   136,   298,   293,   294,   295,
     296,   297,   300,   303,   309,   278,   280,   310,   312,   321,
     314,   315,   316,   151,   152,   153,   154,   155,   156,   157,
     158,   159,   160,   161,   162,   163,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   318,   174,   175,   178,   319,
     280,   151,   180,   181,   182,   183,   184,   185,   186,   187,
     320,   322,   323,    17,   145,    28,   211,   195,     0,     0,
     199,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   221,   222,   223,
     224,   225,     0,   226,   227,   228,   229,   230,   231,     0,
     232,   233,   234,   235,   236,   237,   238,   239,   240,   241,
     242,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    83,    84,     0,
       0,    85,     0,   147,     0,     0,   178,     0,     0,     0,
       0,   148,   116,   240,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,     0,   274,     0,   275,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   109,     0,
       0,     0,   279,     0,     0,     0,     0,     0,   110,     0,
       0,     0,   179,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   111,   112,     0,     0,     0,     0,     0,
       0,   302,     0,   304,   305,   306,   307,   308,   308,     0,
       0,     0,     0,     0,     0,   311,    83,    84,   313,    33,
      85,     0,   147,    54,     0,     0,     0,   317,     0,     0,
     148,    88,     0,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,    55,    56,    57,    58,    59,    60,    61,
      62,     0,     0,     0,     0,     0,     0,   109,     0,     0,
       0,    36,    37,    63,    64,    65,    66,   149,    68,    69,
      70,   150,    83,    84,     0,    33,    85,     0,    86,    34,
       0,     0,   111,   112,     0,     0,    87,    88,   266,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   109,     0,     0,     0,    36,    37,     0,
       0,     0,     0,   110,     0,     0,    83,    84,     0,    33,
      85,     0,    86,    34,     0,     0,     0,     0,   111,   112,
      87,    88,     0,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   109,     0,     0,
       0,    36,    37,     0,     0,     0,     0,   110,     0,     0,
      83,    84,     0,     0,    85,     0,    86,     0,     0,     0,
       0,     0,   111,   112,    87,   116,   198,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   109,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   110,     0,     0,    83,    84,     0,     0,    85,     0,
      86,     0,     0,     0,     0,     0,   111,   112,    87,   116,
       0,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   103,   104,   105,   106,   107,
     108,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   109,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   110,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     111,   112
};

static const yytype_int16 yycheck[] =
{
      12,    20,    20,    65,    60,    61,     8,     0,    70,     8,
      12,   202,    20,    12,    19,     0,    20,    21,    20,    21,
       8,    20,     8,    35,    12,     8,    12,    20,   219,    12,
      20,    21,    20,    21,    20,    21,     4,    20,    10,    21,
      59,    59,    54,    42,    43,    44,    45,    46,    47,    48,
      49,    63,   243,    58,    66,    67,    68,    69,    60,    61,
      20,    60,    61,    62,    63,    64,    65,    66,    67,    68,
      69,    70,    60,    61,    60,    61,    88,    60,    61,    21,
      10,    10,    50,    51,    52,    53,    54,    55,     7,     3,
       3,    10,    13,    14,    15,    16,    17,    18,   110,    59,
      10,   113,    21,    21,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,   126,    21,   128,   129,   130,   131,
      20,   133,   134,    21,    20,     4,    21,    21,    21,    21,
      21,   143,    21,    21,    20,   147,    21,   149,    10,     5,
       6,    21,     8,     9,    20,    11,    12,    20,    19,     3,
      20,    10,    21,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    20,     3,    21,    21,
      21,   193,    21,    21,    21,    21,     3,    21,    21,    21,
      56,    21,    21,    21,    60,    61,    57,   209,    20,   211,
      66,    19,    57,    19,     3,     3,   218,     3,     3,    21,
       3,    19,    57,     3,    21,    81,    82,    57,     3,    21,
      55,    56,    57,    58,    59,    60,    61,    62,     3,    21,
      21,     3,    21,    68,    21,    70,    57,    21,    21,    21,
      21,    21,    21,    21,     3,   257,   258,    21,    21,     3,
      21,    21,    21,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,    20,   111,   112,   113,    19,
     292,   116,   117,   118,   119,   120,   121,   122,   123,   124,
      57,    21,    21,     3,    82,     9,   147,   132,    -1,    -1,
     135,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   152,   153,   154,
     155,   156,    -1,   158,   159,   160,   161,   162,   163,    -1,
     165,   166,   167,   168,   169,   170,   171,   172,   173,   174,
     175,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     5,     6,    -1,
      -1,     9,    -1,    11,    -1,    -1,   211,    -1,    -1,    -1,
      -1,    19,    20,   218,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    -1,   240,    -1,   242,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    56,    -1,
      -1,    -1,   257,    -1,    -1,    -1,    -1,    -1,    66,    -1,
      -1,    -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    81,    82,    -1,    -1,    -1,    -1,    -1,
      -1,   286,    -1,   288,   289,   290,   291,   292,   293,    -1,
      -1,    -1,    -1,    -1,    -1,   300,     5,     6,   303,     8,
       9,    -1,    11,    12,    -1,    -1,    -1,   312,    -1,    -1,
      19,    20,    -1,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    -1,    -1,    -1,    -1,    -1,    -1,    56,    -1,    -1,
      -1,    60,    61,    62,    63,    64,    65,    66,    67,    68,
      69,    70,     5,     6,    -1,     8,     9,    -1,    11,    12,
      -1,    -1,    81,    82,    -1,    -1,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    56,    -1,    -1,    -1,    60,    61,    -1,
      -1,    -1,    -1,    66,    -1,    -1,     5,     6,    -1,     8,
       9,    -1,    11,    12,    -1,    -1,    -1,    -1,    81,    82,
      19,    20,    -1,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    56,    -1,    -1,
      -1,    60,    61,    -1,    -1,    -1,    -1,    66,    -1,    -1,
       5,     6,    -1,    -1,     9,    -1,    11,    -1,    -1,    -1,
      -1,    -1,    81,    82,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    56,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    66,    -1,    -1,     5,     6,    -1,    -1,     9,    -1,
      11,    -1,    -1,    -1,    -1,    -1,    81,    82,    19,    20,
      -1,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    56,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    66,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      81,    82
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    20,    84,    85,    86,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,     0,     0,    86,    21,    21,
      10,    13,    14,    15,    16,    17,    18,    91,    91,    10,
      92,    10,    89,     8,    12,    20,    60,    61,    95,     3,
       3,    21,    10,    90,    60,    61,     7,    10,    21,    21,
      20,    21,    20,    21,    12,    42,    43,    44,    45,    46,
      47,    48,    49,    62,    63,    64,    65,    66,    67,    68,
      69,    70,    95,    21,    21,    21,    21,    21,    21,    20,
      21,    87,    88,     5,     6,     9,    11,    19,    20,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    56,
      66,    81,    82,    93,    95,    99,    20,    99,    99,    99,
      99,    99,    99,    99,    99,    95,    94,    95,    94,    95,
      95,    95,    99,    95,    94,    98,    99,    20,    21,    20,
      59,    10,    20,    59,    21,    87,     4,    11,    19,    66,
      70,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    95,    99,    99,    21,    95,    99,    70,
      99,    99,    99,    99,    99,    99,    99,    99,    21,    21,
      95,    21,    95,    95,    95,    99,    95,    21,    21,    99,
      20,    96,    97,    19,    58,    20,    19,    95,    20,    59,
       3,    93,    50,    51,    52,    53,    54,    55,    95,    20,
      21,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    20,    21,    21,    21,    21,    21,    21,
      21,    21,    21,    95,    21,    21,    21,    10,    21,    96,
      57,    20,    19,    57,    19,    95,    21,     3,     3,     3,
       3,     3,     3,    96,    99,    99,    96,    21,    95,    99,
      95,     3,    19,    57,     3,    57,    21,     3,    21,    21,
      21,    21,    21,    21,    21,    21,    21,    21,    57,     3,
      21,     3,    99,    21,    99,    99,    99,    99,    99,     3,
      21,    99,    21,    99,    21,    21,    21,    99,    20,    19,
      57,     3,    21,    21
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    83,    84,    85,    85,    86,    86,    86,    86,    86,
      86,    86,    86,    86,    86,    86,    86,    87,    88,    88,
      89,    89,    89,    89,    90,    91,    91,    91,    91,    91,
      91,    91,    92,    92,    92,    93,    93,    93,    93,    94,
      94,    95,    95,    95,    95,    95,    95,    95,    95,    95,
      95,    95,    95,    95,    95,    95,    95,    95,    95,    95,
      95,    95,    95,    95,    95,    95,    96,    96,    97,    97,
      98,    98,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99,
      99,    99,    99,    99,    99,    99,    99,    99,    99,    99
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     2,     1,     3,     3,     4,     5,     4,
       5,     4,     4,     4,     4,     4,     4,     8,     1,     2,
      10,     6,     5,     9,     1,     1,     1,     1,     1,     2,
       2,     2,     8,     4,    16,     1,     1,     2,     2,     1,
       2,     1,     1,     1,     5,     4,     4,     5,     5,     5,
       5,     5,     5,     5,     5,     3,     4,     5,     6,     4,
       4,     5,     5,     7,     4,     1,     2,     1,     4,     4,
       1,     2,     1,     3,     3,     4,     7,     6,     6,     4,
       3,     2,     2,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     6,     6,     6,     3,     1,     1,     4,     1,     7
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

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
#ifndef YYINITDEPTH
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
static YYSIZE_T
yystrlen (const char *yystr)
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
static char *
yystpcpy (char *yydest, const char *yysrc)
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

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
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
  int yytoken = 0;
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

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
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
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
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
      if (yytable_value_is_error (yyn))
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
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

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
     '$$ = $1'.

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
#line 200 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
       parserInterface->cleanUp();
       YYACCEPT;
}
#line 1693 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 4:
#line 209 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1699 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 5:
#line 214 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
       parserInterface->cleanUp();
       YYACCEPT;
	}
#line 1708 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 6:
#line 219 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
		parserInterface->checkSat(parserInterface->getAssertVector());
	}
#line 1716 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 7:
#line 224 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	  if (!(0 == strcmp((yyvsp[-1].str)->c_str(),"QF_BV") ||
	        0 == strcmp((yyvsp[-1].str)->c_str(),"QF_ABV") ||
	        0 == strcmp((yyvsp[-1].str)->c_str(),"QF_AUFBV"))) {
	    yyerror("Wrong input logic:");
	  }
	  parserInterface->success();
	  delete (yyvsp[-1].str);
	}
#line 1730 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 8:
#line 234 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	delete (yyvsp[-1].str);
	}
#line 1738 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 9:
#line 238 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	}
#line 1745 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 10:
#line 241 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1751 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 11:
#line 243 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1757 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 12:
#line 245 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
		for (unsigned i=0; i < (yyvsp[-1].uintval);i++)
		{
			parserInterface->push();
		}
		parserInterface->success();
	}
#line 1769 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 13:
#line 253 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
		for (unsigned i=0; i < (yyvsp[-1].uintval);i++)
			parserInterface->pop();
		parserInterface->success();
	}
#line 1779 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 14:
#line 259 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
    parserInterface->success();
    }
#line 1787 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 15:
#line 263 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
    parserInterface->success();
    }
#line 1795 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 16:
#line 267 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	parserInterface->AddAssert(*(yyvsp[-1].node));
	parserInterface->deleteNode((yyvsp[-1].node));
	parserInterface->success();
	}
#line 1805 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 17:
#line 277 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = new ASTNode(BEEV::parserInterface->LookupOrCreateSymbol((yyvsp[-6].str)->c_str())); 
  parserInterface->addSymbol(*(yyval.node));
  (yyval.node)->SetIndexWidth(0);
  (yyval.node)->SetValueWidth((yyvsp[-2].uintval));
  delete (yyvsp[-6].str);
}
#line 1817 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 18:
#line 288 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.vec) = new ASTVec;
  (yyval.vec)->push_back(*(yyvsp[0].node));
  delete (yyvsp[0].node);
}
#line 1827 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 19:
#line 294 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.vec) = (yyvsp[-1].vec);
  (yyval.vec)->push_back(*(yyvsp[0].node));
  delete (yyvsp[0].node);
}
#line 1837 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 20:
#line 303 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	if ((yyvsp[0].node)->GetValueWidth() != (yyvsp[-2].uintval))
		{
			char msg [100];
			sprintf(msg, "Different bit-widths specified: %d %d", (yyvsp[0].node)->GetValueWidth(), (yyvsp[-2].uintval));
			yyerror(msg);
		}
	
	BEEV::parserInterface->storeFunction(*(yyvsp[-9].str), *(yyvsp[-7].vec), *(yyvsp[0].node));

	// Next time the variable is used, we want it to be fresh.
    for (size_t i = 0; i < (yyvsp[-7].vec)->size(); i++)
     BEEV::parserInterface->removeSymbol((*(yyvsp[-7].vec))[i]);
	
	delete (yyvsp[-9].str);
	delete (yyvsp[-7].vec);
	delete (yyvsp[0].node);
}
#line 1860 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 21:
#line 323 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	BEEV::parserInterface->storeFunction(*(yyvsp[-5].str), *(yyvsp[-3].vec), *(yyvsp[0].node));

	// Next time the variable is used, we want it to be fresh.
    for (size_t i = 0; i < (yyvsp[-3].vec)->size(); i++)
     BEEV::parserInterface->removeSymbol((*(yyvsp[-3].vec))[i]);

	delete (yyvsp[-5].str);
	delete (yyvsp[-3].vec);
	delete (yyvsp[0].node);
}
#line 1876 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 22:
#line 336 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	ASTVec empty;
        BEEV::parserInterface->storeFunction(*(yyvsp[-4].str), empty, *(yyvsp[0].node));

        delete (yyvsp[-4].str);
        delete (yyvsp[0].node);
}
#line 1888 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 23:
#line 345 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
        if ((yyvsp[0].node)->GetValueWidth() != (yyvsp[-2].uintval))
                {
                        char msg [100];
                        sprintf(msg, "Different bit-widths specified: %d %d", (yyvsp[0].node)->GetValueWidth(), (yyvsp[-2].uintval));
                        yyerror(msg);
                }
	ASTVec empty;

        BEEV::parserInterface->storeFunction(*(yyvsp[-8].str),empty, *(yyvsp[0].node));

        delete (yyvsp[-8].str);
        delete (yyvsp[0].node);
}
#line 1907 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 24:
#line 363 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    { 
 
 std::transform((yyvsp[0].str)->begin(), (yyvsp[0].str)->end(), (yyvsp[0].str)->begin(), ::tolower);
  
  if (0 == strcmp((yyvsp[0].str)->c_str(), "sat"))
  	input_status = TO_BE_SATISFIABLE;
  else if (0 == strcmp((yyvsp[0].str)->c_str(), "unsat"))
    input_status = TO_BE_UNSATISFIABLE;
  else if (0 == strcmp((yyvsp[0].str)->c_str(), "unknown"))
  	input_status = TO_BE_UNKNOWN; 
  else 
  	yyerror((yyvsp[0].str)->c_str());
  delete (yyvsp[0].str);
  (yyval.node) = NULL; 
}
#line 1927 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 25:
#line 382 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1933 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 26:
#line 384 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1939 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 27:
#line 386 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1945 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 28:
#line 388 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1951 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 29:
#line 390 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 1957 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 30:
#line 392 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	parserInterface->setPrintSuccess(true);
	parserInterface->success();
}
#line 1966 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 31:
#line 397 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	parserInterface->setPrintSuccess(false);
}
#line 1974 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 32:
#line 406 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode s = BEEV::parserInterface->LookupOrCreateSymbol((yyvsp[-7].str)->c_str()); 
  parserInterface->addSymbol(s);
  //Sort_symbs has the indexwidth/valuewidth. Set those fields in
  //var
  s.SetIndexWidth(0);
  s.SetValueWidth((yyvsp[-1].uintval));
  delete (yyvsp[-7].str);
}
#line 1988 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 33:
#line 416 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode s = BEEV::parserInterface->LookupOrCreateSymbol((yyvsp[-3].str)->c_str());
  s.SetIndexWidth(0);
  s.SetValueWidth(0);
  parserInterface->addSymbol(s);
  delete (yyvsp[-3].str);
}
#line 2000 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 34:
#line 424 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode s = BEEV::parserInterface->LookupOrCreateSymbol((yyvsp[-15].str)->c_str());
  parserInterface->addSymbol(s);
  unsigned int index_len = (yyvsp[-7].uintval);
  unsigned int value_len = (yyvsp[-2].uintval);
  if(index_len > 0) {
    s.SetIndexWidth((yyvsp[-7].uintval));
  }
  else {
    FatalError("Fatal Error: parsing: BITVECTORS must be of positive length: \n");
  }

  if(value_len > 0) {
    s.SetValueWidth((yyvsp[-2].uintval));
  }
  else {
    FatalError("Fatal Error: parsing: BITVECTORS must be of positive length: \n");
  }
  delete (yyvsp[-15].str);
}
#line 2025 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 35:
#line 448 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.vec) = new ASTVec;
  if ((yyvsp[0].node) != NULL) {
    (yyval.vec)->push_back(*(yyvsp[0].node));
    parserInterface->deleteNode((yyvsp[0].node));
  }
}
#line 2037 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 36:
#line 457 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.vec) = new ASTVec;
  if ((yyvsp[0].node) != NULL) {
    (yyval.vec)->push_back(*(yyvsp[0].node));
    parserInterface->deleteNode((yyvsp[0].node));
  }
}
#line 2049 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 37:
#line 466 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  if ((yyvsp[-1].vec) != NULL && (yyvsp[0].node) != NULL) {
    (yyvsp[-1].vec)->push_back(*(yyvsp[0].node));
    (yyval.vec) = (yyvsp[-1].vec);
    parserInterface->deleteNode((yyvsp[0].node));
  }
}
#line 2061 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 38:
#line 475 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  if ((yyvsp[-1].vec) != NULL && (yyvsp[0].node) != NULL) {
    (yyvsp[-1].vec)->push_back(*(yyvsp[0].node));
    (yyval.vec) = (yyvsp[-1].vec);
    parserInterface->deleteNode((yyvsp[0].node));
  }
}
#line 2073 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 39:
#line 487 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.vec) = new ASTVec;
  if ((yyvsp[0].node) != NULL) {
    (yyval.vec)->push_back(*(yyvsp[0].node));
    parserInterface->deleteNode((yyvsp[0].node));
  }
}
#line 2085 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 40:
#line 496 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  if ((yyvsp[-1].vec) != NULL && (yyvsp[0].node) != NULL) {
    (yyvsp[-1].vec)->push_back(*(yyvsp[0].node));
    (yyval.vec) = (yyvsp[-1].vec);
    parserInterface->deleteNode((yyvsp[0].node));
  }
}
#line 2097 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 41:
#line 507 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(parserInterface->CreateNode(TRUE)); 
  assert(0 == (yyval.node)->GetIndexWidth()); 
  assert(0 == (yyval.node)->GetValueWidth());
}
#line 2107 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 42:
#line 513 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(parserInterface->CreateNode(FALSE)); 
  assert(0 == (yyval.node)->GetIndexWidth()); 
  assert(0 == (yyval.node)->GetValueWidth());
}
#line 2117 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 43:
#line 519 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(*(yyvsp[0].node)); 
  parserInterface->deleteNode((yyvsp[0].node));      
}
#line 2126 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 44:
#line 524 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(EQ,*(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode((yyvsp[-2].node));
  parserInterface->deleteNode((yyvsp[-1].node));      
}
#line 2137 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 45:
#line 531 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  using namespace BEEV;

  ASTVec terms = *(yyvsp[-1].vec);
  ASTVec forms;

  for(ASTVec::const_iterator it=terms.begin(),itend=terms.end();
      it!=itend; it++) {
    for(ASTVec::const_iterator it2=it+1; it2!=itend; it2++) {
      ASTNode n = (parserInterface->nf->CreateNode(NOT, parserInterface->CreateNode(EQ, *it, *it2)));

          
      forms.push_back(n); 
    }
  }

  if(forms.size() == 0) 
    FatalError("empty distinct");
 
  (yyval.node) = (forms.size() == 1) ?
    parserInterface->newNode(forms[0]) :
    parserInterface->newNode(parserInterface->CreateNode(AND, forms));

  delete (yyvsp[-1].vec);
}
#line 2167 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 46:
#line 557 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  using namespace BEEV;

  ASTVec terms = *(yyvsp[-1].vec);
  ASTVec forms;

  for(ASTVec::const_iterator it=terms.begin(),itend=terms.end();
      it!=itend; it++) {
    for(ASTVec::const_iterator it2=it+1; it2!=itend; it2++) {
      ASTNode n = (parserInterface->nf->CreateNode(NOT, parserInterface->CreateNode(IFF, *it, *it2)));
      forms.push_back(n); 
    }
  }

  if(forms.size() == 0) 
    FatalError("empty distinct");
 
  (yyval.node) = (forms.size() == 1) ?
    parserInterface->newNode(forms[0]) :
    parserInterface->newNode(parserInterface->CreateNode(AND, forms));

  delete (yyvsp[-1].vec);
}
#line 2195 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 47:
#line 581 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVSLT, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode((yyvsp[-2].node));
  parserInterface->deleteNode((yyvsp[-1].node));      
}
#line 2206 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 48:
#line 588 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVSLE, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2217 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 49:
#line 595 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVSGT, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2228 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 50:
#line 602 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVSGE, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2239 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 51:
#line 609 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVLT, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2250 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 52:
#line 616 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVLE, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2261 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 53:
#line 623 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVGT, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2272 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 54:
#line 630 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode * n = parserInterface->newNode(BVGE, *(yyvsp[-2].node), *(yyvsp[-1].node));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2283 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 55:
#line 637 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = (yyvsp[-1].node);
}
#line 2291 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 56:
#line 641 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(parserInterface->nf->CreateNode(NOT, *(yyvsp[-1].node)));
    parserInterface->deleteNode( (yyvsp[-1].node));
}
#line 2300 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 57:
#line 646 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(IMPLIES, *(yyvsp[-2].node), *(yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));      
}
#line 2310 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 58:
#line 652 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(parserInterface->nf->CreateNode(ITE, *(yyvsp[-3].node), *(yyvsp[-2].node), *(yyvsp[-1].node)));
  parserInterface->deleteNode( (yyvsp[-3].node));
  parserInterface->deleteNode( (yyvsp[-2].node));      
  parserInterface->deleteNode( (yyvsp[-1].node));
}
#line 2321 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 59:
#line 659 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(parserInterface->CreateNode(AND, *(yyvsp[-1].vec)));
  delete (yyvsp[-1].vec);
}
#line 2330 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 60:
#line 664 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(parserInterface->CreateNode(OR, *(yyvsp[-1].vec)));
  delete (yyvsp[-1].vec);
}
#line 2339 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 61:
#line 669 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(XOR, *(yyvsp[-2].node), *(yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));
}
#line 2349 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 62:
#line 675 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode(IFF, *(yyvsp[-2].node), *(yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));
}
#line 2359 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 63:
#line 681 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = (yyvsp[-1].node);
  //Cleanup the LetIDToExprMap
  parserInterface->letMgr->CleanupLetIDMap();
}
#line 2369 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 64:
#line 687 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {	
  (yyval.node) = parserInterface->newNode(parserInterface->applyFunction(*(yyvsp[-2].str),*(yyvsp[-1].vec)));
  delete (yyvsp[-2].str);
  delete (yyvsp[-1].vec);
}
#line 2379 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 65:
#line 693 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTVec empty;
  (yyval.node) = parserInterface->newNode(parserInterface->applyFunction(*(yyvsp[0].str),empty));
  delete (yyvsp[0].str);
}
#line 2389 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 67:
#line 702 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {}
#line 2395 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 68:
#line 705 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  //populate the hashtable from LET-var -->
  //LET-exprs and then process them:
  //
  //1. ensure that LET variables do not clash
  //1. with declared variables.
  //
  //2. Ensure that LET variables are not
  //2. defined more than once
  parserInterface->letMgr->LetExprMgr(*(yyvsp[-2].str),*(yyvsp[-1].node));
  delete (yyvsp[-2].str);
  parserInterface->deleteNode( (yyvsp[-1].node));
}
#line 2413 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 69:
#line 719 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  //populate the hashtable from LET-var -->
  //LET-exprs and then process them:
  //
  //1. ensure that LET variables do not clash
  //1. with declared variables.
  //
  //2. Ensure that LET variables are not
  //2. defined more than once
  parserInterface->letMgr->LetExprMgr(*(yyvsp[-2].str),*(yyvsp[-1].node));
  delete (yyvsp[-2].str);
  parserInterface->deleteNode( (yyvsp[-1].node));

}
#line 2432 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 70:
#line 737 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.vec) = new ASTVec;
  if ((yyvsp[0].node) != NULL) {
    (yyval.vec)->push_back(*(yyvsp[0].node));
    parserInterface->deleteNode( (yyvsp[0].node));
  
  }
}
#line 2445 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 71:
#line 747 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  if ((yyvsp[-1].vec) != NULL && (yyvsp[0].node) != NULL) {
    (yyvsp[-1].vec)->push_back(*(yyvsp[0].node));
    (yyval.vec) = (yyvsp[-1].vec);
    parserInterface->deleteNode( (yyvsp[0].node));
  }
}
#line 2457 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 72:
#line 758 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = parserInterface->newNode((*(yyvsp[0].node)));
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2466 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 73:
#line 763 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = (yyvsp[-1].node);
}
#line 2474 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 74:
#line 767 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  //ARRAY READ
  // valuewidth is same as array, indexwidth is 0.
  ASTNode array = *(yyvsp[-1].node);
  ASTNode index = *(yyvsp[0].node);
  unsigned int width = array.GetValueWidth();
  ASTNode * n = 
    parserInterface->newNode(parserInterface->nf->CreateTerm(READ, width, array, index));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2491 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 75:
#line 780 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  //ARRAY WRITE
  unsigned int width = (yyvsp[0].node)->GetValueWidth();
  ASTNode array = *(yyvsp[-2].node);
  ASTNode index = *(yyvsp[-1].node);
  ASTNode writeval = *(yyvsp[0].node);
  ASTNode write_term = parserInterface->nf->CreateArrayTerm(WRITE,(yyvsp[-2].node)->GetIndexWidth(),width,array,index,writeval);
  ASTNode * n = parserInterface->newNode(write_term);
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2509 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 76:
#line 794 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  int width = (yyvsp[-3].uintval) - (yyvsp[-2].uintval) + 1;
  if (width < 0)
    yyerror("Negative width in extract");
      
  if((unsigned)(yyvsp[-3].uintval) >= (yyvsp[0].node)->GetValueWidth())
    yyerror("Parsing: Wrong width in BVEXTRACT\n");                      
      
  ASTNode hi  =  parserInterface->CreateBVConst(32, (yyvsp[-3].uintval));
  ASTNode low =  parserInterface->CreateBVConst(32, (yyvsp[-2].uintval));
  ASTNode output = parserInterface->nf->CreateTerm(BVEXTRACT, width, *(yyvsp[0].node),hi,low);
  ASTNode * n = parserInterface->newNode(output);
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2529 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 77:
#line 810 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned w = (yyvsp[0].node)->GetValueWidth() + (yyvsp[-2].uintval);
  ASTNode width = parserInterface->CreateBVConst(32,w);
  ASTNode *n =  parserInterface->newNode(parserInterface->nf->CreateTerm(BVZX,w,*(yyvsp[0].node),width));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2541 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 78:
#line 818 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned w = (yyvsp[0].node)->GetValueWidth() + (yyvsp[-2].uintval);
  ASTNode width = parserInterface->CreateBVConst(32,w);
  ASTNode *n =  parserInterface->newNode(parserInterface->nf->CreateTerm(BVSX,w,*(yyvsp[0].node),width));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2553 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 79:
#line 827 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  const unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  (yyval.node) = parserInterface->newNode(parserInterface->nf->CreateArrayTerm(ITE,(yyvsp[0].node)->GetIndexWidth(), width,*(yyvsp[-2].node), *(yyvsp[-1].node), *(yyvsp[0].node)));      
  parserInterface->deleteNode( (yyvsp[-2].node));
  parserInterface->deleteNode( (yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2565 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 80:
#line 835 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  const unsigned int width = (yyvsp[-1].node)->GetValueWidth() + (yyvsp[0].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(parserInterface->nf->CreateTerm(BVCONCAT, width, *(yyvsp[-1].node), *(yyvsp[0].node)));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[-1].node));
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2577 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 81:
#line 843 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  //this is the BVNEG (term) in the CVCL language
  unsigned int width = (yyvsp[0].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(parserInterface->nf->CreateTerm(BVNEG, width, *(yyvsp[0].node)));
  (yyval.node) = n;
  parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2589 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 82:
#line 851 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  //this is the BVUMINUS term in CVCL langauge
  unsigned width = (yyvsp[0].node)->GetValueWidth();
  ASTNode * n =  parserInterface->newNode(parserInterface->nf->CreateTerm(BVUMINUS,width,*(yyvsp[0].node)));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2601 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 83:
#line 859 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVAND, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2613 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 84:
#line 867 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVOR, width, *(yyvsp[-1].node), *(yyvsp[0].node)); 
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2625 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 85:
#line 875 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVXOR, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2637 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 86:
#line 883 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
//   (bvxnor s t) abbreviates (bvor (bvand s t) (bvand (bvnot s) (bvnot t)))
      unsigned int width = (yyvsp[-1].node)->GetValueWidth();
      ASTNode * n = parserInterface->newNode(
      parserInterface->nf->CreateTerm( BVOR, width,
     parserInterface->nf->CreateTerm(BVAND, width, *(yyvsp[-1].node), *(yyvsp[0].node)),
     parserInterface->nf->CreateTerm(BVAND, width,
	     parserInterface->nf->CreateTerm(BVNEG, width, *(yyvsp[-1].node)),
     	 parserInterface->nf->CreateTerm(BVNEG, width, *(yyvsp[0].node))
     )));

      (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2657 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 87:
#line 899 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  	ASTNode * n = parserInterface->newNode(parserInterface->nf->CreateTerm(ITE, 1, 
  	parserInterface->nf->CreateNode(EQ, *(yyvsp[-1].node), *(yyvsp[0].node)),
  	parserInterface->CreateOneConst(1),
  	parserInterface->CreateZeroConst(1)));
  	
      (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2672 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 88:
#line 910 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  const unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVSUB, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2684 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 89:
#line 918 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  const unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVPLUS, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));

}
#line 2697 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 90:
#line 927 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  const unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(parserInterface->nf->CreateTerm(BVMULT, width, *(yyvsp[-1].node), *(yyvsp[0].node)));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2709 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 91:
#line 935 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVDIV, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;

    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2722 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 92:
#line 944 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVMOD, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;

    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2735 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 93:
#line 953 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(SBVDIV, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;

    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2748 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 94:
#line 962 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(SBVREM, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2760 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 95:
#line 970 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(SBVMOD, width, *(yyvsp[-1].node), *(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2772 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 96:
#line 978 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(parserInterface->nf->CreateTerm(BVNEG, width, parserInterface->nf->CreateTerm(BVAND, width, *(yyvsp[-1].node), *(yyvsp[0].node))));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2784 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 97:
#line 986 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  unsigned int width = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(parserInterface->nf->CreateTerm(BVNEG, width, parserInterface->nf->CreateTerm(BVOR, width, *(yyvsp[-1].node), *(yyvsp[0].node)))); 
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2796 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 98:
#line 994 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  // shifting left by who know how much?
  unsigned int w = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVLEFTSHIFT,w,*(yyvsp[-1].node),*(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2809 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 99:
#line 1003 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  // shifting right by who know how much?
  unsigned int w = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVRIGHTSHIFT,w,*(yyvsp[-1].node),*(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2822 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 100:
#line 1012 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  // shifting arithmetic right by who know how much?
  unsigned int w = (yyvsp[-1].node)->GetValueWidth();
  ASTNode * n = parserInterface->newNode(BVSRSHIFT,w,*(yyvsp[-1].node),*(yyvsp[0].node));
  (yyval.node) = n;
    parserInterface->deleteNode( (yyvsp[-1].node));
    parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2835 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 101:
#line 1021 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode *n;
  unsigned width = (yyvsp[0].node)->GetValueWidth();
  unsigned rotate = (yyvsp[-2].uintval) % width;
  if (0 == rotate)
    {
      n = (yyvsp[0].node);
    }
  else 
    {
      ASTNode high = parserInterface->CreateBVConst(32,width-1);
      ASTNode zero = parserInterface->CreateBVConst(32,0);
      ASTNode cut = parserInterface->CreateBVConst(32,width-rotate);
      ASTNode cutMinusOne = parserInterface->CreateBVConst(32,width-rotate-1);

      ASTNode top =  parserInterface->nf->CreateTerm(BVEXTRACT,rotate,*(yyvsp[0].node),high, cut);
      ASTNode bottom =  parserInterface->nf->CreateTerm(BVEXTRACT,width-rotate,*(yyvsp[0].node),cutMinusOne,zero);
      n =  parserInterface->newNode(parserInterface->nf->CreateTerm(BVCONCAT,width,bottom,top));
          parserInterface->deleteNode( (yyvsp[0].node));


    }
      
  (yyval.node) = n;
}
#line 2865 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 102:
#line 1047 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTNode *n;
  unsigned width = (yyvsp[0].node)->GetValueWidth();
  unsigned rotate = (yyvsp[-2].uintval) % width;
  if (0 == rotate)
    {
      n = (yyvsp[0].node);
    }
  else 
    {
      ASTNode high = parserInterface->CreateBVConst(32,width-1);
      ASTNode zero = parserInterface->CreateBVConst(32,0);
      ASTNode cut = parserInterface->CreateBVConst(32,rotate); 
      ASTNode cutMinusOne = parserInterface->CreateBVConst(32,rotate-1);

      ASTNode bottom =  parserInterface->nf->CreateTerm(BVEXTRACT,rotate,*(yyvsp[0].node),cutMinusOne, zero);
      ASTNode top =  parserInterface->nf->CreateTerm(BVEXTRACT,width-rotate,*(yyvsp[0].node),high,cut);
      n =  parserInterface->newNode(parserInterface->nf->CreateTerm(BVCONCAT,width,bottom,top));
      parserInterface->deleteNode( (yyvsp[0].node));
    }
      
  (yyval.node) = n;
}
#line 2893 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 103:
#line 1071 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	  unsigned count = (yyvsp[-2].uintval);
	  if (count < 1)
	  	FatalError("One or more repeats please");

	  unsigned w = (yyvsp[0].node)->GetValueWidth();  
      ASTNode n =  *(yyvsp[0].node);
      
      for (unsigned i =1; i < count; i++)
      {
      	  n = parserInterface->nf->CreateTerm(BVCONCAT,w*(i+1),n,*(yyvsp[0].node));
      }
      (yyval.node) = parserInterface->newNode(n);
      parserInterface->deleteNode( (yyvsp[0].node));
}
#line 2913 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 104:
#line 1087 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	(yyval.node) = parserInterface->newNode(parserInterface->CreateBVConst(*(yyvsp[-1].str), 10, (yyvsp[0].uintval)));
    (yyval.node)->SetValueWidth((yyvsp[0].uintval));
    delete (yyvsp[-1].str);
}
#line 2923 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 105:
#line 1093 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	unsigned width = (yyvsp[0].str)->length()*4;
	(yyval.node) = parserInterface->newNode(parserInterface->CreateBVConst(*(yyvsp[0].str), 16, width));
    (yyval.node)->SetValueWidth(width);
    delete (yyvsp[0].str);
}
#line 2934 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 106:
#line 1100 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
	unsigned width = (yyvsp[0].str)->length();
	(yyval.node) = parserInterface->newNode(parserInterface->CreateBVConst(*(yyvsp[0].str), 2, width));
    (yyval.node)->SetValueWidth(width);
    delete (yyvsp[0].str);
}
#line 2945 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 107:
#line 1107 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {	
  (yyval.node) = parserInterface->newNode(parserInterface->applyFunction(*(yyvsp[-2].str),*(yyvsp[-1].vec)));
  
  if ((yyval.node)->GetType() != BITVECTOR_TYPE)
  	yyerror("Must be bitvector type");
  
  delete (yyvsp[-2].str);
  delete (yyvsp[-1].vec);
}
#line 2959 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 108:
#line 1117 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  ASTVec empty;
  (yyval.node) = parserInterface->newNode(parserInterface->applyFunction(*(yyvsp[0].str),empty));

  if ((yyval.node)->GetType() != BITVECTOR_TYPE)
        yyerror("Must be bitvector type");

  delete (yyvsp[0].str);
}
#line 2973 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;

  case 109:
#line 1127 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1646  */
    {
  (yyval.node) = (yyvsp[-1].node);
  //Cleanup the LetIDToExprMap
  parserInterface->letMgr->CleanupLetIDMap();
}
#line 2983 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
    break;


#line 2987 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.cpp" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
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

  /* Do not reclaim the symbols of the rule whose action triggered
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
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
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

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


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

#if !defined yyoverflow || YYERROR_VERBOSE
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
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
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
  return yyresult;
}
#line 1135 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1906  */

