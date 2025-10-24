# Cobertura de Testes Semânticos

| Categoria/Construto                  | Casos                                   | Coberto? |
|-------------------------------------|-----------------------------------------|----------|
| Atribuição (tipos compatíveis)      | `pass/test_sum.c`                       | ✅       |
| Atribuição (tipos incompatíveis)    | `fail/invalid_type.c`                   | ✅       |
| Escopo (símbolo não encontrado)     | `fail/scope_error.c`                    | ✅       |
| Retorno obrigatório em função       | `fail/missing_return.c`                 | ✅       |
| Chamadas a função                   | `pass/test_sum.c`                       | ✅       |
| Soma/operadores aritméticos         | `pass/test_sum.c`                       | ✅       |
| Impressão/IO runtime                | `pass/test_sum.c`                       | ✅       |
| **Faltantes**                       | conversão implícita, short-circuit, etc | ❌       |

Legenda: ✅ coberto • ❌ pendente
