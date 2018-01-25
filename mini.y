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
%token tBEGIN tEND							// statement block
%token tSEMICOLON

%left tOR
%left tAND
%left tEQUALS tNOTEQUALS
%left tPLUS tMINUS
%left tTIMES tDIV
%left tNEGATE tNOT

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
	  tVARDECL tIDENTIFIER tTINTEGER tASSIGN tINTEGER tSEMICOLON
	| tVARDECL tIDENTIFIER tTFLOAT tASSIGN tFLOAT tSEMICOLON
	| tVARDECL tIDENTIFIER tTBOOLEAN tASSIGN tBOOLEAN tSEMICOLON
	| tVARDECL tIDENTIFIER tTSTRING tASSIGN tSTRING tSEMICOLON
;

stmt_list:
	  stmt_list stmt
	| stmt
;

stmt:
	  tREAD tIDENTIFIER tSEMICOLON
	| tPRINT expr tSEMICOLON
	| tIDENTIFIER tASSIGN expr tSEMICOLON | tIDENTIFIER tASSIGN litteral tSEMICOLON
	| tIF expr tBEGIN stmt_list tEND | tIF expr tBEGIN stmt_list tEND tELSE tBEGIN stmt_list tEND
	| tWHILE expr tBEGIN stmt_list tEND
;

expr:
	  binary_expr
	| unary_expr
	| tIDENTIFIER
	| litteral
	| tLPAREN expr tRPAREN
;

litteral:
	  tINTEGER
	| tFLOAT
	| tBOOLEAN
	| tSTRING
;

binary_expr:
	  expr tPLUS expr
	| expr tMINUS expr
	| expr tTIMES expr
	| expr tDIV expr

	| expr tEQUALS expr
	| expr tNOTEQUALS expr
	
	| tBOOLEAN tAND tBOOLEAN | expr tAND expr
	| tBOOLEAN tOR tBOOLEAN | expr tOR expr
;

unary_expr:
	  tNEGATE expr
	| tMINUS tINTEGER | tMINUS tFLOAT
;
%%

int main(int argc, char* argv[]) {
	if (argc != 2) {
		printf(stderr, "Wrong usage. Correct usage: ./mini {scan|tokens|parse} < input.min");
		return 1;
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
		if(yyparse() == 0) {
			printf("OK");
			return 0;
		}
	}
	return 0;
}
