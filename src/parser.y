%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
%}

/* ---------- União de valores ---------- */
%union {
    int intValue;
    float floatValue;
    char *id;
}

/* ---------- Tokens ---------- */
%token <intValue> NUM
%token <floatValue> FLOAT
%token <id> IDENT

%token INT FLOAT_TYPE BOOL CHAR
%token TRUE FALSE
%token IF ELSE WHILE FOR RETURN PRINT
%token EQ NEQ LT LEQ GT GEQ
%token AND OR NOT
%token ASSIGN
%token PLUS MINUS TIMES DIVIDE MOD
%token LBRACE RBRACE LPAREN RPAREN
%token SEMICOLON COMMA

/* ---------- Precedência ---------- */
%left OR
%left AND
%left EQ NEQ
%left LT LEQ GT GEQ
%left PLUS MINUS
%left TIMES DIVIDE MOD
%right NOT
%right UMINUS

/* ---------- Tipos ---------- */
%type <intValue> expr
%type <intValue> stmt

%%

/* ---------- Programa e estrutura ---------- */
program:
      stmt_list
    ;

/* Lista de comandos */
stmt_list:
      stmt_list stmt
    | /* vazio */
    ;

/* ---------- Comandos principais ---------- */
stmt:
      decl_stmt
    | assign_stmt
    | if_stmt
    | while_stmt
    | for_stmt
    | print_stmt
    | block
    | RETURN expr SEMICOLON
    ;

/* Declarações */
decl_stmt:
      type IDENT ASSIGN expr SEMICOLON
        { printf("Declaração: %s = %d\n", $2, $4); }
    | type IDENT SEMICOLON
        { printf("Declaração: %s\n", $2); }
    ;

/* Atribuição */
assign_stmt:
      IDENT ASSIGN expr SEMICOLON
        { printf("Atribuição: %s = %d\n", $1, $3); }
    ;

/* If / Else */
if_stmt:
      IF LPAREN expr RPAREN stmt
        { printf("If condicional simples\n"); }
    | IF LPAREN expr RPAREN stmt ELSE stmt
        { printf("If/Else condicional\n"); }
    ;

/* While */
while_stmt:
      WHILE LPAREN expr RPAREN stmt
        { printf("Loop While\n"); }
    ;

/* For */
for_stmt:
      FOR LPAREN assign_stmt expr SEMICOLON assign_stmt RPAREN stmt
        { printf("Loop For\n"); }
    ;

/* Print */
print_stmt:
      PRINT LPAREN expr RPAREN SEMICOLON
        { printf("Print encontrado\n"); }
    ;

/* Blocos */
block:
      LBRACE stmt_list RBRACE
        { printf("Bloco de comandos\n"); }
    ;

/* Tipos */
type:
      INT
    | FLOAT_TYPE
    | BOOL
    | CHAR
    ;

/* ---------- Expressões ---------- */
expr:
      expr PLUS expr        { $$ = $1 + $3; }
    | expr MINUS expr       { $$ = $1 - $3; }
    | expr TIMES expr       { $$ = $1 * $3; }
    | expr DIVIDE expr      { $$ = $1 / $3; }
    | expr MOD expr         { $$ = $1 % $3; }
    | expr EQ expr          { $$ = ($1 == $3); }
    | expr NEQ expr         { $$ = ($1 != $3); }
    | expr LT expr          { $$ = ($1 < $3); }
    | expr LEQ expr         { $$ = ($1 <= $3); }
    | expr GT expr          { $$ = ($1 > $3); }
    | expr GEQ expr         { $$ = ($1 >= $3); }
    | expr AND expr         { $$ = ($1 && $3); }
    | expr OR expr          { $$ = ($1 || $3); }
    | NOT expr              { $$ = !$2; }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | LPAREN expr RPAREN    { $$ = $2; }
    | NUM                   { $$ = $1; }
    | FLOAT                 { $$ = (int)$1; }
    | TRUE                  { $$ = 1; }
    | FALSE                 { $$ = 0; }
    | IDENT                 { printf("Uso de variável: %s\n", $1); $$ = 0; }
    ;

%%

/* ---------- Funções auxiliares ---------- */
int main(void) {
    printf("Iniciando análise sintática...\n");
    yyparse();
    printf("Análise concluída.\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}
