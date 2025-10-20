#ifndef SEMANTIC_H
#define SEMANTIC_H

#include "ast.h"
#include "symbol_table.h"

typedef struct
{
	FunctionTable functions;
} SemanticInfo;

int semantic_analyze(AstProgram *program, SemanticInfo *info);
void semantic_info_free(SemanticInfo *info);

#endif
