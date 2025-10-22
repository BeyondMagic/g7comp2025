# Relatório de Semântica — Sprint 3

**Responsável:** @Liviarodrigues1  
**Escopo:** Variáveis locais, expressões, promoções numéricas, operadores lógicos, arrays 1D, mapeamento `printf/puts`, helpers de runtime.

## 1. Regras implementadas
- **Promoções:** `int→float`, `char→int`, `bool→int` (0/1) quando permitido.
- **Operadores lógicos:** `&&/||/!` → `and/or/not` (curto-circuito preservado).
- **Arrays 1D:** tabela Lua com base 1; `arr[i]` → `arr[i+1]` no código gerado.
- **I/O:** `printf/puts` via `runtime/printf.lua` (`rt_printf`, `rt_puts`).

## 2. Casos validados (pass)
- Aritmética mista `int+float` → `float`.
- Índice de array numérico (`int/char/bool`) com promoção quando aplicável.
- Curto-circuito preservado em `&&` e `||`.
- `printf` e `puts` mapeados corretamente.

## 3. Casos conhecidos a resolver
- Verificação de limites de arrays (bounds-check) opcional somente para modo debug.
- `%f` segue locale do host; padronização futura.
- Conversão de `char` para `%c` (usa `string.char`) — coberto pelo helper.

## 4. Mensagens de erro (formato)
```
<arquivo>:<linha>:<coluna>: <código> <mensagem>
Ex.: main.c:12:8: E004: atribuição incompatível: float ← int*
```

## 5. Checklist (DoD)
- [x] Símbolos por escopo (global/função/bloco)
- [x] `AstExpression.type` e `AstExpression.flags`
- [x] Regras de promoção / casts implícitos
- [x] Operadores lógicos para `and/or/not`
- [x] Arrays com deslocamento `+1`
- [x] Runtime `printf.lua`
- [x] Testes `pass` e `fail` com golden files
- [x] Este relatório

