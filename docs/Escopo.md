# Escopo do Projeto em Lua

## Objetivo

Desenvolver um interpretador simplificado para um subconjunto da linguagem **Lua**, utilizando **Flex** para análise léxica e **Bison** para análise sintática.  
O interpretador é capaz de executar operações básicas como atribuições de variáveis, expressões aritméticas, controle de fluxo com estruturas condicionais e loops.

---

## Funcionalidades Implementadas

### Tipos de Dados

- **Inteiros**: `42`, `-10`, `+5`
- **Ponto flutuante**: `3.14`, `-2.5`, `1e-10`
- **Strings**: `"Hello"`, `'World'`
- **Booleanos**: `true`, `false`

### Operadores

- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `^`
- **Comparação**: `==`, `~=`, `<`, `>`, `<=`, `>=`

### Estruturas de Controle

- **Condicionais**: `if/else` com blocos aninhados
- **Loops**: `while` com suporte a `break` e `goto` (substituindo `continue`)
- **Blocos**: Estrutura baseada em `do ... end`

### Funções Built-in

- `print()`: Saída formatada com múltiplos argumentos

### Tratamento de Erros

- **Erros léxicos**: Caracteres inválidos
- **Erros sintáticos**: Estrutura gramatical incorreta
- **Erros semânticos**: Variáveis não definidas, divisão por zero
- **Erros de escopo**: Variáveis locais não acessíveis fora do bloco

---

## Limitações do Escopo Atual

### Não Implementado

- Funções definidas pelo usuário (apenas funções built-in)
- Estruturas de dados complexas: tabelas, metatables
- Orientação a objetos (classes e objetos)
- Módulos (`require` e `module`)
- Tratamento de exceções (`pcall`/`xpcall`)
- Operadores de bit (`&`, `|`, `~`, `<<`, `>>`)
- Operadores de atribuição composta (`+=`, `-=` etc. não existem no Lua)
- Loop `for`: Apenas `while` implementado
- `elseif`: Apenas `if/else` básico

### Implementado

- Operações aritméticas básicas
- Controle de fluxo (`if/else` e `while`)
- Variáveis (declaração e atribuição)
- Tipos básicos (`number`, `string`, `boolean`)
- Blocos `do ... end`
- Comentários (`-- linha única`)
- Tratamento de erros com mensagens detalhadas
- Suite de testes com cobertura funcional

---

## Estrutura do Projeto

### Documentação (`/docs`)

- `Escopo.md`: Documento de escopo do projeto
- `Glossário de termos.md`: Definições e termos utilizados
- `Guia - Configuração do ambiente de desenvolvimento.md`: Passo a passo para preparar o ambiente
- `Guia - Projeto de um compilador.md`: Guia conceitual do compilador
- `Trabalho de Compiladores.md`: Documento principal do trabalho
- `tokens.md`: Tabela de tokens do projeto (léxico)
- `sprints/`: Planejamento das entregas


### ⚙️ Código Fonte (`/src`)

- `main.c`: Arquivo principal (ponto de entrada)
- `lexer.l`: Especificação do analisador léxico
- `parser.y`: Especificação do analisador sintático

### Testes (`/tests`)

- `variable.c`: Testes escritos em C
- `variable.lua`: Testes escritos em Lua

### Outros Arquivos

- `Cronograma.md`: Cronograma do projeto
- `Makefile`: Arquivo de automação de compilação
- `README.md`: Este documento

---

## Conclusão

Este projeto demonstra a implementação de um interpretador **Lua** simplificado usando as ferramentas **Flex** e **Bison**.  
O escopo cobre os conceitos fundamentais de compiladores: análise léxica, análise sintática, construção de AST e interpretação.

O projeto oferece uma base sólida para futuras extensões e serve como excelente material educacional para o estudo de compiladores e interpretadores.
