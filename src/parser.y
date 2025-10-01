%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

%}

%union {
    int intValue;
    float floatValue;
    char *strValue;  // Manipula strings corretamente
    char *id;
}

%type <intValue> expr
%token <intValue> NUM
%token <floatValue> FLOAT
%token <id> IDENT
%token SEMI
%token TRUE FALSE
%token PLUS MINUS TIMES DIVIDE MOD
%token EQ NEQ LT LEQ GT GEQ
%token AND OR NOT
%token IF ELSE WHILE DO RETURN PRINT
%token LPAREN RPAREN
%token END

%left PLUS MINUS
%left TIMES DIVIDE MOD
%left POW
%left AND OR
%right NOT

%start input

%%

input:
      /* vazio */
    | expr SEMI                   { /* Trata a expressão seguida de ponto e vírgula */ }
    | PRINT expr SEMI             { /* Trata o comando print */ }
    | IF LPAREN expr RPAREN input ELSE input { /* Condicional if/else */ }
    | WHILE LPAREN expr RPAREN DO input END { /* Loop while com do...end */ }
    | RETURN expr SEMI            { /* Comando return */ }
    | error SEMI                  { yyerror("Erro sintático: Esperado expressão após ';'"); }
    ;

expr:
      expr PLUS expr             { $$ = $1 + $3; }
    | expr MINUS expr            { $$ = $1 - $3; }
    | expr TIMES expr            { $$ = $1 * $3; }
    | expr DIVIDE expr           { 
                                    if ($3 == 0) {
                                        yyerror("Erro semântico: Divisão por zero");
                                    }
                                    $$ = $1 / $3; 
                                  }
    | expr MOD expr              { $$ = $1 % $3; }
    | LPAREN expr RPAREN         { $$ = $2; }
    | NUM                        { $$ = $1; }
    | FLOAT                      { $$ = $1; }
    | TRUE                       { $$ = 1; }
    | FALSE                      { $$ = 0; }
    | IDENT                      { $$ = 0; }
    | NOT expr                   { $$ = !$2; }
    | expr EQ expr               { $$ = $1 == $3; }
    | expr NEQ expr              { $$ = $1 != $3; }
    | expr LT expr               { $$ = $1 < $3; }
    | expr LEQ expr              { $$ = $1 <= $3; }
    | expr GT expr               { $$ = $1 > $3; }
    | expr GEQ expr              { $$ = $1 >= $3; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}
