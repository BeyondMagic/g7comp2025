## Planejamento em Sprints

Cada sprint tem 10 dias corridos. Ao final, a entrega é um executável que avança o pipeline com exemplos funcionando. Para melhor organização, mapeamos cada sprint em um issue, onde os membros colocam seus nomes e marcam a atividade como feita.

### [Sprint 1 (D1–D10) — Kickoff, escopo e esqueleto](https://github.com/BeyondMagic/g7comp2025/issues/1)

- [x] Repositório criado, README e licença — responsável: @BeyondMagic 
- [x] Ambiente (Flex, Bison, GCC) verificado em todas as máquinas — responsável: @Todos
- [x] Makefile básico (alvos: build, clean, test) — responsável:  @andrewslopes
- [x] Arquivos iniciais: `lexer/lexer.l`, `parser/parser.y`, `src/main.c` — responsável: @marcomarquesdc 
- [x] Definir subconjunto de C (MVP) e exemplos de entrada/saída Lua — responsável: @Liviarodrigues1 
- [x] Pipeline mínimo: aceitar uma expressão e imprimir tokenização — responsável: @Sophiassilva 
- [x] Casos de teste iniciais em `tests/` — responsável: @BeyondMagic 

### [Sprint 2 (D11–D20) — Léxico completo e parser de expressões](https://github.com/BeyondMagic/g7comp2025/issues/2)

- [x] CI: adicionar `.gitignore` para ignorar arquivos: `c2lua`, `lex.yy.c`, `parser.tab.c`, `parser.tab.h` -- responsável: @BeyondMagic 
- [x] Tabela de tokens (ident, número, palavras‑chave, operadores, símbolos) — responsável: @marcomarquesdc 
- [x] Regras Flex com precedência correta para tokens compostos — responsável: @marcomarquesdc 
- [x] Ignorar espaços/comentários (// e /* */) — responsável: @Sophiassilva 
- [x] Parser: precedência/associatividade de +, -, *, / — responsável: @Sophiassilva 
- [x] Testes de expressões (inclui erros léxicos/sintáticos) — responsável: @Liviarodrigues1 
- [x] CLI: ler de arquivo/STDIN e ecoar AST de expressões (debug) — responsável: @andrelopesdesousa 
- [x] Documentação de manual de uso e execução. — responsável: @BeyondMagic 
- [x] P1: Preencher formulário: @BeyondMagic 

### [Sprint 3 (D21–D40) — AST, símbolos e semântica básica](https://github.com/BeyondMagic/g7comp2025/issues/3)

- [ ] Núcleo semântico unificado: definir AST (expr/stmt/decl/fun), tabela de símbolos com escopos, checagem/conversão int↔float e mensagens de erro com linha/coluna responsáveis: @Sophiassilva
- [ ] Suporte sintático essencial: declarações, atribuições, blocos, if/else, while/for, curto-circuito lógico e comparações (==, \!=, \<, \<=, \>, \>=) responsáveis: @marcomarquesdc
- [ ] Análise Semântica: missão Lua abrangente: variáveis locais, expressões, operadores lógicos, arrays 1D como tabelas, mapeamento de printf/puts, helpers de runtime quando necessário responsáveis: @Liviarodrigues1
- [ ] Funções completas: traduzir assinaturas e return de C para function Lua, preservar escopos e chamadas responsáveis: @BeyondMagic
- [ ] Garantia de qualidade: testes de semântica (erros de escopo/tipo), golden files de erro, pipeline end-to-end (C → Lua → execução), linemap/diagnóstico e atualização de docs/demo responsáveis: @andrelopesdesousa

### [Sprint 4 (D41–D50) — Polimento, empacote e entrega](https://github.com/BeyondMagic/g7comp2025/issues/4)

- [ ] Eliminação de subexpressão comum responsável: @beyondmagic
- [ ] Copy Propagation responsável: @Sophiassilva 
- [ ] Strength reduction (multiplicação por 2 vira soma) responsável: @Liviarodrigues1 
- [ ] Eliminar variável não usada responsável: @marcomarquesdc 
- [ ] Eliminar código não alcançável responsável: @andrelopesdesousa 
- [ ] Condição falsa em tempo de compilação responsável: @andrelopesdesousa 
- [ ] Condição verdadeira em tempo de compilação responsável: @andrelopesdesousa 
- [ ] Testes adicionais de integração e cobertura de todas as funcionalidades implementadas e funcionalidades que não serão implementadas responsável: @marcomarquesdc 
- [ ] Documentação final (uso, limites, exemplos) responsável: @Liviarodrigues1
- [ ] Estudar e preparar apresentação/entrevista e roteiro de demo: TODOS!

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