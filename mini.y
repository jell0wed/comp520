%{
#include <stdio.h>
void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
%}


%union {
	int intval;
	float floatval;
	int boolval;
	char* stringval;
	char* identifierval;
	char* datatype;
}

%token <intval> tINTEGER 					// raw integer value
%token <boolval> tBOOLEAN					// raw boolean value
%token <floatval> tFLOAT					// raw flow value
%token <stringval> tSTRING					// raw string value (unquoted)
%token <identifierval> tIDENTIFIER			// identifiers for variables
%token tTINTEGER tTFLOAT tTBOOLEAN tTSTRING // type declarations 
%token tVARDECL								// variable declaration

%%
mini:
	  var_dec_list stmt_list
	| stmt_list
;

var_dec_list:
	  var_dec_list var_dec
	| var_dec
;

var_dec:
	  tVARDECL tIDENTIFIER tTINTEGER tINTEGER	{ printf("Var declaration (%s = int) = %d", $2, $4); }
	| tVARDECL tIDENTIFIER tTFLOAT tFLOAT		{ printf("Var declaration (%s = float) = %.9f", $2, $4); }
	| tVARDECL tIDENTIFIER tTBOOLEAN tBOOLEAN	{ printf("Var declaration (%s = boolean) = %i", $2, $4); }
	| tVARDECL tIDENTIFIER tTSTRING tSTRING		{ printf("Var declaration (%s = string) = %s", $2, $4); }
;

stmt_list:
	  stmt_list stmt
	| stmt
;

stmt:
	  tSTRING 		{ printf("Push String %s", $1); }
	| tBOOLEAN		{ printf("Push Boolean %i", $1); }
	| tFLOAT		{ printf("Push Float %.9f", $1); }
;

expr:
	
;
%%

int main() {
	yyparse();
	return 0;
}
