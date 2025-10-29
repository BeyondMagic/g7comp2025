# Projeto: Transpilador de C para Lua (Flex + Bison + C)

Objetivo: construir um compilador que lê um subconjunto de C e transpila para Lua, usando Flex (léxico) e Bison (sintático) em C.

Resumo do MVP de linguagem suportada:
- Tipos: int, float, bool (true/false), char (como número), string opcional.
- Estruturas: declaração de variáveis, atribuição, expressões aritméticas/lógicas, if/else, while, função (definição/chamada) e return.
- I/O: mapeamento simples printf/puts -> print; scanf opcional.
- Saída Lua: usar local para variáveis, funções Lua equivalentes, operadores com mesma semântica; arrays opcionais como tabelas.

O que não será suportado:
- Ponteiros, structs, alocação dinâmica, manipulação de memória.
- Recursos avançados: pré-processador, macros, diretivas de compilação.

```
.
├── lexer/       # regras léxicas (lexer.l)
├── parser/      # gramática e ações (parser.y)
├── src/         # main.c, AST, tabela de símbolos, gerador Lua
├── tests/
│   ├── pass/    # casos que devem passar
│   └── fail/    # casos que precisam falhar
└── Makefile
```

## Ambiente de Desenvolvimento

Ubuntu Linux:
```bash
sudo apt update
sudo apt install -y flex bison build-essential git
```

Arch Linux:
```bash
sudo pacman -Syu flex bison base-devel git
```

Build local (exemplo mínimo):
```bash
make 
./c2lua tests/pass/expressions.c
```

# Documentação de cada sprint

- [1ª sprint](./docs/sprints/1.md);
- [2ª sprint](./docs/sprints/2.md);
- [3ª sprint](./docs/sprints/3.md);
- [4ª sprint](./docs/sprints/4.md);

# Testes

A pasta `tests/` está organizada em:
- `tests/semantic/pass`: casos que devem gerar Lua válido e executar com sucesso;
- `tests/semantic/fail`: casos que precisam falhar na análise semântica (arquivos `.err` com a mensagem esperada);

Execute as suítes pelo Makefile:

```bash
make test            # verifica os smoke tests (tradução direta C -> Lua)
```

Os golden files utilizam o mesmo nome-base do arquivo `.c`, com extensão `.lua` (para PASS) ou `.golden`/`.err` (para FAIL).
