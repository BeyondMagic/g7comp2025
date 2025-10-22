#ifndef CODEGEN_LUA_H
#define CODEGEN_LUA_H

#include <stdio.h>

#include "ast.h"
#include "symbol_table.h"

void codegen_lua_emit(FILE *out, const AstProgram *program, const FunctionTable *functions);

#endif
