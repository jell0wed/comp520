%{
#include <stdio.h>
void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
%}
%token-table
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
%token tLPAREN tRPAREN


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
	  tINTEGER { printf("%s", $1); }
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

int main(int argc, char* argv[]) {
	if (argc != 2) {
		printf(stderr, "Wrong usage. Correct usage: ./mini {scan|tokens|parse} < input.min");
		exit(1);
	}

	char* command = argv[1];
	if (strcmp("scan", command) == 0) {
		yylex();
		printf("OK");
		return 0;
	} else if (strcmp("tokens", command) == 0) {
		int token_type;
		while((token_type = yylex()) != 0) {
			printf("%s\n", yytname[YYTRANSLATE(token_type)]);
		}
	} else if (strcmp("parse", command) == 0) {
		yyparse();
	}
	return 0;
}
