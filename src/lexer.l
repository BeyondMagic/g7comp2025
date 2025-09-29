%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

void yyerror(const char *s);
%}

%%

"//".*                         { /* Ignorar comentários de linha */ }
"/*"([^*]|\*+[^*/])*\*+\/      { /* Ignorar comentários de bloco */ }
[ \t\n]+                       { /* Ignora espaços em branco */ }
"true"                         { return TRUE; }
"false"                        { return FALSE; }
"if"                           { return IF; }
"else"                         { return ELSE; }
"while"                        { return WHILE; }
"do"                           { return DO; }
"end"                          { return END; }
"return"                       { return RETURN; }
"print"                        { return PRINT; }
[0-9]+                         { yylval.intValue = atoi(yytext); return NUM; }
[0-9]*"."[0-9]+([eE][-+]?[0-9]+)? { yylval.floatValue = atof(yytext); return FLOAT; }
[a-zA-Z_][a-zA-Z0-9_]*         { yylval.id = strdup(yytext); return IDENT; }
";"                            { return SEMI; }
"+"                            { return PLUS; }
"-"                            { return MINUS; }
"*"                            { return TIMES; }
"/"                            { return DIVIDE; }
"%"                            { return MOD; }
"=="                           { return EQ; }
"~="                           { return NEQ; }
"<"                            { return LT; }
"<="                           { return LEQ; }
">"                            { return GT; }
">="                           { return GEQ; }
"("                            { return LPAREN; }
")"                            { return RPAREN; }
.                              { yyerror("Caractere inválido: "); printf("'%s'\n", yytext); }

%%

int yywrap(void) {
    return 1;
}