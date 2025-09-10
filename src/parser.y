/******************************************************
FGA0003 - Compiladores 1
Curso de Engenharia de Software
Universidade de Brasília (UnB)
******************************************************/

%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(const char *s);
%}

%union {
    int intValue;
    char *id;
}

%token <intValue> NUM
%token <id> IDENT
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

%left PLUS MINUS
%left TIMES DIVIDE
%type <intValue> expr

%%

expr:
      expr PLUS expr    { $$ = $1 + $3; }
    | expr MINUS expr   { $$ = $1 - $3; }
    | expr TIMES expr   { $$ = $1 * $3; }
    | expr DIVIDE expr  { $$ = $1 / $3; }
    | LPAREN expr RPAREN{ $$ = $2; }
    | NUM               { $$ = $1; }
    | IDENT              { printf("Uso de variável: %s\n", $1); $$ = 0; }
    ;

%%

int main(void) {
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}