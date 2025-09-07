# Projeto: Transpilador de C para Lua (Flex + Bison + C)

Objetivo: construir um compilador que lê um subconjunto de C e transpila para Lua, usando Flex (léxico) e Bison (sintático) em C.

Resumo do MVP de linguagem suportada:
- Tipos: int, float, bool (true/false), char (como número), string opcional.
- Estruturas: declaração de variáveis, atribuição, expressões aritméticas/lógicas, if/else, while, for, função (definição/chamada) e return.
- I/O: mapeamento simples printf/puts -> print; scanf opcional.
- Saída Lua: usar local para variáveis, funções Lua equivalentes, operadores com mesma semântica; arrays opcionais como tabelas.

```
.
├── lexer/        # regras léxicas (lexer.l)
├── parser/       # gramática e ações (parser.y)
├── src/          # main.c, AST, tabela de símbolos, gerador Lua
├── tests/        # entradas C e saídas Lua esperadas
└── Makefile
```

Ambiente rápido (Linux):
```nu
sudo apt update
sudo apt install -y flex bison build-essential git
```

Build local (exemplo mínimo):
```nu
flex lexer/lexer.l
bison -d parser/parser.y
gcc -o c2lua lex.yy.c parser.tab.c src/*.c -lfl
./c2lua < tests/exemplo.c > out.lua
```
