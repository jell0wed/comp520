%{
#include <stdio.h>
#include "mini.tab.h"
#define YYDEBUG 1
%}
ALLOWED_CHARS [ a-zA-Z0-9~@#$%^&\*\-\+/`<>=_|\'.,;:!^\{\}\[\]\(\)\\\a\b\f\n\r\t\v)]
ALLOWED_IDENTIFIER [a-zA-Z_][a-zA-Z_0-9]*
ALLOWED_DATATYPES (float|boolean|int|string)
%option noyywrap
%%
[ \t\n\r]+				    ;
\/\/([^\n]+)                ;
:                           ;
;                           ;
(\{|\})                     ;

\+                          { return tPLUS; }
\-                          { return tMINUS; }
\*                          { return tTIMES; }
\/                          { return tDIV; }
==                          { return tEQUALS; }
!=                          { return tNOTEQUALS; }
&&                          { return tAND; }
\|\|                        { return tOR; } 
!                           { return tNOT; }

\(                          { return tLPAREN; }
\)                          { return tRPAREN; }

read                        { return tREAD; }
print                       { return tPRINT; }
=                           { return tASSIGN; }
if                          { return tIF; }
else                        { return tELSE; }
while                       { return tWHILE; }

var                         { return tVARDECL; }
int                         { return tTINTEGER; }
float                       { return tTFLOAT; }
bool                        { return tTBOOLEAN; }
string                      { return tTSTRING; }

(TRUE|FALSE)				{ yylval.boolval = strcmp("TRUE", yytext) == 0 ? 1 : 0; return tBOOLEAN; }
(0|[1-9]+)					{ yylval.intval = atoi(yytext); return tINTEGER; }
(0|[1-9]+).([0-9]+)			{ yylval.floatval = atof(yytext); return tFLOAT; }

{ALLOWED_IDENTIFIER}        { yylval.identifierval = strdup(yytext); return tIDENTIFIER; }
\"{ALLOWED_CHARS}*\"	 	{   int n = strlen(yytext);
                                char* cpy = malloc((n - 2 + 1) * sizeof(char));
                                strncpy(cpy, yytext + sizeof(char), n - 2); 
                                yylval.stringval = cpy;
                                return tSTRING;
                            } 

.							{ fprintf(stderr, "Error: unexpected char '%s'", yytext); exit(1); }
%%
