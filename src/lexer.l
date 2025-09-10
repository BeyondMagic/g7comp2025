/******************************************************
FGA0003 - Compiladores 1
Curso de Engenharia de Software
Universidade de Brasília (UnB)
******************************************************/

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" 
%}

%%

"//".*     { /* Ignorar comentários de linha */ }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return IDENT; }
"/*"([^*]|\*+[^*/])*\*+\/    { /* Ignorar comentários de bloco */ }
[0-9]+  {
    yylval.intValue = atoi(yytext);
    return NUM;
}
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return TIMES; }
"/"     { return DIVIDE; }
"("     { return LPAREN; }
")"     { return RPAREN; }

[ \t\n]+  { /* não faz nada */ }

.        { printf("Caractere não reconhecido: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;
}