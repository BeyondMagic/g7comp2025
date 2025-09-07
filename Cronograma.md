## Planejamento em Sprints

Cada sprint tem 10 dias corridos. Ao final, a entrega é um executável que avança o pipeline com exemplos funcionando. Para melhor organização, mapeamos cada sprint em um issue, onde os membros colocam seus nomes e marcam a atividade como feita.

### [Sprint 1 (D1–D10) — Kickoff, escopo e esqueleto](https://github.com/BeyondMagic/g7comp2025/issues/1)

- ❌Repositório criado, README e licença — responsável: @João
- ❌Ambiente (Flex, Bison, GCC) verificado em todas as máquinas — responsável: @Todos
- ❌ Makefile básico (alvos: build, clean, test) — responsável: 
- ❌ Arquivos iniciais: `lexer/lexer.l`, `parser/parser.y`, `src/main.c` — responsável: 
- ❌ Definir subconjunto de C (MVP) e exemplos de entrada/saída Lua — responsável: 
- ❌ Pipeline mínimo: aceitar uma expressão e imprimir tokenização — responsável: 
- ❌ Casos de teste iniciais em `tests/` — responsável: 
- ❌ P1 (se aplicável): preencher formulário e rascunho de slides — responsável: 

### [Sprint 2 (D11–D20) — Léxico completo e parser de expressões](https://github.com/BeyondMagic/g7comp2025/issues/2)
- ❌ Tabela de tokens (ident, número, palavras‑chave, operadores, símbolos) — responsável: 
- ❌ Regras Flex com precedência correta para tokens compostos — responsável: 
- ❌ Ignorar espaços/comentários (// e /* */) — responsável: 
- ❌ Parser: precedência/associatividade de +, -, *, /, %, &&, ||, ! — responsável: 
- ❌ Testes de expressões (inclui erros léxicos/sintáticos) — responsável: 
- ❌ CLI: ler de arquivo/STDIN e ecoar AST de expressões (debug) — responsável: 

### [Sprint 3 (D21–D30) — AST, símbolos e semântica básica](https://github.com/BeyondMagic/g7comp2025/issues/3)
- ❌ Definir estruturas de AST (nós para expr, stmt, decl, função) — responsável: 
- ❌ Tabela de símbolos com escopos (global/funcional/blocos) — responsável: 
- ❌ Checagem de tipos simples e conversões (int <-> float) — responsável: 
- ❌ Suporte a declarações/atribuições/blocks/if/while — responsável: 
- ❌ Erros com localização (linha/coluna) e mensagens claras — responsável: 
- ❌ Testes unitários de semântica (variável não declarada, tipo inválido) — responsável: 

### [Sprint 4 (D31–D40) — Geração de Lua para núcleo imperativo](https://github.com/BeyondMagic/g7comp2025/issues/4)
- ❌ Emissor Lua: variáveis (local), atribuições, expressões — responsável: 
- ❌ Controle de fluxo: if/else, while, for (C) -> Lua equivalente — responsável: 
- ❌ Funções: assinatura C simples -> function Lua; return — responsável: 
- ❌ I/O: printf/puts -> print; mapear operadores lógicos — responsável: 
- ❌ Testes end‑to‑end: C de exemplo -> Lua -> execução no Lua — responsável: 
- ❌ P2 (se aplicável): atualizar formulário e demo curta — responsável: 

### [Sprint 5 (D41–D50) — Recursos úteis e robustez](https://github.com/BeyondMagic/g7comp2025/issues/5)
- ❌ Arrays 1D como tabelas Lua; indexação e inicialização — responsável: 
- ❌ Curto‑circuito lógico e comparações == != < <= > >= — responsável: 
- ❌ Biblioteca runtime mínima (helpers em Lua se necessário) — responsável: 
- ❌ Modo de comentários/diagnóstico no gerado (linemap) — responsável: 
- ❌ Ampliação de testes e casos com erro (golden files) — responsável: 

### [Sprint 6 (D51–D60) — Polimento, empacote e entrega](https://github.com/BeyondMagic/g7comp2025/issues/6)
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
