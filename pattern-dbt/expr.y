%{
#include <stdio.h>
#include <stdlib.h>
%}

%token INTEGER VARIABLE
%token PLUS MINUS AND OR LSHIFT RSHIFT
%token LEFT RIGHT

%left PLUS MINUS
%left AND OR
%left LSHIFT RSHIFT
%left NEG
%right NOT

%start Input

%%

Input:
    Expression { return $1; }
;

Expression:
    INTEGER { $$ = $1; }
    | NOT Expression { $$ = ~$2; }
    | Expression PLUS Expression { $$ = $1 + $3; } 
    | Expression MINUS Expression { $$ = $1 - $3; }
    | Expression AND Expression { $$ = $1 & $3; }
    | Expression OR Expression { $$ = $1 | $3; }
    | Expression LSHIFT Expression { $$ = $1 << $3; }
    | Expression RSHIFT Expression { $$ = $1 >> $3; }
    | MINUS Expression %prec NEG { $$ = -$2; }
    | LEFT Expression RIGHT { $$ = $2; }
;

%%

int yyerror(char *s) {
    fprintf(stderr, "Error to parse this string: %s\n", s);
}

int parse_str_to_int(char *s) {
    yy_scan_string(s);
    return yyparse();
}
