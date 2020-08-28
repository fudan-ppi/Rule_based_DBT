%{
#include <stdio.h>
#include <stdlib.h>
#include "expr.tab.h"
%}

white [ \t]+
digit [0-9]
integer {digit}+
variable [a-zA-Z0-9_]

%%

{white}     {}
{integer}   {yylval = atoll(yytext); return INTEGER;}
{variable}  {return VARIABLE;}

"~"         {return NOT;}
"+"         {return PLUS;}
"-"         {return MINUS;}
"&"         {return AND;}
"|"         {return OR;}
"<<"        {return LSHIFT;}
">>"        {return RSHIFT;}
"("         {return LEFT;}
")"         {return RIGHT;}
