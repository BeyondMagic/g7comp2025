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

Como marcar progresso: use os checkboxes abaixo e atribua responsáveis inline (ex.: — responsável: @ana).

## Planejamento em Sprints de 10 dias

Cada sprint tem 10 dias corridos. Ao final, entregar um executável que avança o pipeline e exemplos funcionando.

### Sprint 1 (D1–D10) — Kickoff, escopo e esqueleto
- ❌ Repositório criado, README e licença — responsável: 
- ❌ Ambiente (Flex, Bison, GCC) verificado em todas as máquinas — responsável: 
- ❌ Makefile básico (alvos: build, clean, test) — responsável: 
- ❌ Arquivos iniciais: `lexer/lexer.l`, `parser/parser.y`, `src/main.c` — responsável: 
- ❌ Definir subconjunto de C (MVP) e exemplos de entrada/saída Lua — responsável: 
- ❌ Pipeline mínimo: aceitar uma expressão e imprimir tokenização — responsável: 
- ❌ Casos de teste iniciais em `tests/` — responsável: 
- ❌ P1 (se aplicável): preencher formulário e rascunho de slides — responsável: 

### Sprint 2 (D11–D20) — Léxico completo e parser de expressões
- ❌ Tabela de tokens (ident, número, palavras‑chave, operadores, símbolos) — responsável: 
- ❌ Regras Flex com precedência correta para tokens compostos — responsável: 
- ❌ Ignorar espaços/comentários (// e /* */) — responsável: 
- ❌ Parser: precedência/associatividade de +, -, *, /, %, &&, ||, ! — responsável: 
- ❌ Testes de expressões (inclui erros léxicos/sintáticos) — responsável: 
- ❌ CLI: ler de arquivo/STDIN e ecoar AST de expressões (debug) — responsável: 

### Sprint 3 (D21–D30) — AST, símbolos e semântica básica
- ❌ Definir estruturas de AST (nós para expr, stmt, decl, função) — responsável: 
- ❌ Tabela de símbolos com escopos (global/funcional/blocos) — responsável: 
- ❌ Checagem de tipos simples e conversões (int <-> float) — responsável: 
- ❌ Suporte a declarações/atribuições/blocks/if/while — responsável: 
- ❌ Erros com localização (linha/coluna) e mensagens claras — responsável: 
- ❌ Testes unitários de semântica (variável não declarada, tipo inválido) — responsável: 

### Sprint 4 (D31–D40) — Geração de Lua para núcleo imperativo
- ❌ Emissor Lua: variáveis (local), atribuições, expressões — responsável: 
- ❌ Controle de fluxo: if/else, while, for (C) -> Lua equivalente — responsável: 
- ❌ Funções: assinatura C simples -> function Lua; return — responsável: 
- ❌ I/O: printf/puts -> print; mapear operadores lógicos — responsável: 
- ❌ Testes end‑to‑end: C de exemplo -> Lua -> execução no Lua — responsável: 
- ❌ P2 (se aplicável): atualizar formulário e demo curta — responsável: 

### Sprint 5 (D41–D50) — Recursos úteis e robustez
- ❌ Arrays 1D como tabelas Lua; indexação e inicialização — responsável: 
- ❌ Curto‑circuito lógico e comparações == != < <= > >= — responsável: 
- ❌ Biblioteca runtime mínima (helpers em Lua se necessário) — responsável: 
- ❌ Modo de comentários/diagnóstico no gerado (linemap) — responsável: 
- ❌ Ampliação de testes e casos com erro (golden files) — responsável: 

### Sprint 6 (D51–D60) — Polimento, empacote e entrega
- ❌ Otimizações simples (constant folding, dead‑code leve) — responsável: 
- ❌ UX do CLI (flags: -o, --dump-ast, --dump-lua) — responsável: 
- ❌ Documentação final (uso, limites, exemplos) — responsável: 
- ❌ CI local (script de teste) e release binária — responsável: 
- ❌ Preparar apresentação/entrevista e roteiro de demo — responsável: 

## Critérios de pronto por fase
- Léxico: todos tokens do MVP reconhecidos; sem vazamentos de memória.
- Sintático: AST correta para expressões e comandos principais.
- Semântico: checagens básicas de tipos/escopos; mensagens com linha/coluna.
- Geração Lua: programas do MVP executam em Lua com mesmo resultado.
- Qualidade: testes cobrindo happy path + erros; build reprodutível.

## Referências rápidas
- Flex: padrões, yytext, yylex, yylval.
- Bison: gramática, precedência, $$/$1, yyparse, yyerror.
- Lua 5.x: escopo local, funções, tabelas, operadores, print.

Observação: atualize os checkboxes conforme avança (✅ feito, 🚧 em progresso, ❌ não feito) e preencha os responsáveis inline.