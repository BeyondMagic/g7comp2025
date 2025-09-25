# Tabela de Tokens - Projeto C → Lua

| Categoria     | Lexema            | Token      | Valor associado        |
|---------------|------------------|------------|------------------------|
| Identificador | `nome`, `x`, `_y`| IDENT      | `char* id`             |
| Número        | `123`, `45.6`    | NUM        | `int intValue` (ou float futuramente) |
| Palavra-chave | `int`            | INT        | -                      |
| Palavra-chave | `float`          | FLOAT      | -                      |
| Palavra-chave | `bool`           | BOOL       | -                      |
| Palavra-chave | `true`, `false`  | BOOL_VAL   | `int boolValue`        |
| Palavra-chave | `if`             | IF         | -                      |
| Palavra-chave | `else`           | ELSE       | -                      |
| Palavra-chave | `while`          | WHILE      | -                      |
| Palavra-chave | `for`            | FOR        | -                      |
| Palavra-chave | `return`         | RETURN     | -                      |
| Palavra-chave | `printf`, `puts` | PRINT      | -                      |
| Operador      | `+`              | PLUS       | -                      |
| Operador      | `-`              | MINUS      | -                      |
| Operador      | `*`              | TIMES      | -                      |
| Operador      | `/`              | DIVIDE     | -                      |
| Operador      | `%`              | MOD        | -                      |
| Operador      | `=`              | ASSIGN     | -                      |
| Operador      | `==`             | EQ         | -                      |
| Operador      | `!=`             | NEQ        | -                      |
| Operador      | `<`              | LT         | -                      |
| Operador      | `<=`             | LEQ        | -                      |
| Operador      | `>`              | GT         | -                      |
| Operador      | `>=`             | GEQ        | -                      |
| Operador      | `&&`             | AND        | -                      |
| Operador      | `ll`             | OR         | -                      |
| Operador      | `!`              | NOT        | -                      |
| Símbolo       | `(`              | LPAREN     | -                      |
| Símbolo       | `)`              | RPAREN     | -                      |
| Símbolo       | `{`              | LBRACE     | -                      |
| Símbolo       | `}`              | RBRACE     | -                      |
| Símbolo       | `;`              | SEMICOLON  | -                      |
| Símbolo       | `,`              | COMMA      | -                      |
