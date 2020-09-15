/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

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
#line 79 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib/Parser/smt2.y" /* yacc.c:1909  */
  
  unsigned uintval;                  /* for numerals in types. */
  //ASTNode,ASTVec
  BEEV::ASTNode *node;
  BEEV::ASTVec *vec;
  std::string *str;

#line 146 "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/parsesmt2.hpp" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE smt2lval;

int smt2parse (void);

#endif /* !YY_SMT2_HOME_PPI_DBT_PATTERN_DBT_VINE_COMPARE_STP_MASTER_BUILD_LIB_PARSER_PARSESMT2_HPP_INCLUDED  */
