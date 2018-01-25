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
%token tPLUS tMINUS tTIMES tDIV tEQUALS tNOTEQUALS tAND tOR	// binary expressions
%token tNEGATE tNOT							// unary expression
%token tREAD tPRINT tASSIGN tIF tELSE tWHILE // statements


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
	  tVARDECL tIDENTIFIER tTINTEGER tASSIGN tINTEGER	{ printf("Var declaration (%s = int) = %d", $2, $5); }
	| tVARDECL tIDENTIFIER tTFLOAT tASSIGN tFLOAT		{ printf("Var declaration (%s = float) = %.9f", $2, $5); }
	| tVARDECL tIDENTIFIER tTBOOLEAN tASSIGN tBOOLEAN	{ printf("Var declaration (%s = boolean) = %i", $2, $5); }
	| tVARDECL tIDENTIFIER tTSTRING tASSIGN tSTRING		{ printf("Var declaration (%s = string) = %s", $2, $5); }
;

stmt_list:
	  stmt_list stmt
	| stmt
;

stmt:
	  tREAD tIDENTIFIER
	| tPRINT expr
	| tIDENTIFIER tASSIGN expr | tIDENTIFIER tASSIGN litteral
	| tIF expr stmt_list | tIF expr stmt_list tELSE stmt_list
	| tWHILE expr stmt_list
;

expr:
	  binary_expr
	| unary_expr
;

litteral:
	  tINTEGER
	| tFLOAT
	| tBOOLEAN
	| tSTRING
;

binary_expr:
	  litteral tPLUS litteral | expr tPLUS expr 
	| litteral tMINUS litteral | expr tMINUS expr 
	| litteral tTIMES litteral | expr tTIMES expr 
	| litteral tDIV litteral | expr tDIV expr 

	| litteral tEQUALS litteral | expr tEQUALS expr 
	| litteral tNOTEQUALS litteral | expr tNOTEQUALS expr 
	
	| tBOOLEAN tAND tBOOLEAN | expr tAND expr
	| tBOOLEAN tOR tBOOLEAN | expr tOR expr
;

unary_expr:
	  tNEGATE tINTEGER | tNEGATE tFLOAT | tNEGATE expr
	| tMINUS tBOOLEAN | tMINUS expr
;
%%

int main() {
	yyparse();
	return 0;
}
