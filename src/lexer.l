/******************************************************
FGA0003 - Compiladores 1
Projeto: Transpilador C → Lua
******************************************************/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

void yyerror(const char *s);
%}

%%

/* ---------- Comentários e Espaços ---------- */
"//".*                         { /* Ignorar comentários de linha */ }
"/*"([^*]|\*+[^*/])*\*+\/      { /* Ignorar comentários de bloco */ }
[ \t\n]+                       { /* Ignorar espaços em branco */ }

/* ---------- Palavras-chave (tipos e controle) ---------- */
"int"                          { return INT; }
"float"                        { return FLOAT_TYPE; }
"bool"                         { return BOOL; }
"char"                         { return CHAR; }
"true"                         { return TRUE; }
"false"                        { return FALSE; }
"if"                           { return IF; }
"else"                         { return ELSE; }
"while"                        { return WHILE; }
"for"                          { return FOR; }
"do"                           { return DO; }
"end"                          { return END; }
"return"                       { return RETURN; }
"printf"                       { return PRINT; }
"puts"                         { return PRINT; }

/* ---------- Literais ---------- */
[0-9]+                         { yylval.intValue = atoi(yytext); return NUM; }
[0-9]*"."[0-9]+([eE][-+]?[0-9]+)? { yylval.floatValue = atof(yytext); return FLOAT; }
[a-zA-Z_][a-zA-Z0-9_]*         { yylval.id = strdup(yytext); return IDENT; }

/* ---------- Operadores Compostos ---------- */
"=="                           { return EQ; }
"!="                           { return NEQ; }
"~="                           { return NEQ; }    /* compatibilidade Lua */
"<="                           { return LEQ; }
">="                           { return GEQ; }
"&&"                           { return AND; }
"||"                           { return OR; }

/* ---------- Operadores Simples ---------- */
"="                            { return ASSIGN; }
"<"                            { return LT; }
">"                            { return GT; }
"!"                            { return NOT; }
"+"                            { return PLUS; }
"-"                            { return MINUS; }
"*"                            { return TIMES; }
"/"                            { return DIVIDE; }
"%"                            { return MOD; }

/* ---------- Símbolos de pontuação ---------- */
";"                            { return SEMICOLON; }
","                            { return COMMA; }
"("                            { return LPAREN; }
")"                            { return RPAREN; }
"{"                            { return LBRACE; }
"}"                            { return RBRACE; }

/* ---------- Erros ---------- */
.                              { 
                                   fprintf(stderr, "Caractere inválido: '%s'\n", yytext); 
                               }

%%

int yywrap(void) {
    return 1;
}
