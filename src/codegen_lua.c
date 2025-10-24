#include "codegen_lua.h"

#include <stdio.h>
#include <string.h>

static void emit_program(FILE *out, const AstProgram *program, const FunctionTable *functions);
static void emit_function(FILE *out, const AstFunction *fn, const FunctionSignature *signature, const FunctionTable *functions);
static void emit_main_wrapper(FILE *out, const AstFunction *fn, const FunctionSignature *signature, const FunctionTable *functions);
static void emit_block(FILE *out, const AstBlock *block, const FunctionTable *functions, const FunctionSignature *signature, int indent, int wrap_with_do);
static void emit_statement(FILE *out, const AstStmt *stmt, const FunctionTable *functions, const FunctionSignature *signature, int indent);
static void emit_expression_raw(FILE *out, const AstExpr *expr, const FunctionTable *functions);
static void emit_expression_expected(FILE *out, const AstExpr *expr, const FunctionTable *functions, TypeKind expected_type);
static void emit_call(FILE *out, const AstExpr *expr, const FunctionTable *functions);
static const FunctionSignature *lookup_signature(const FunctionTable *functions, const char *name);
static const char *binary_op_token(AstBinaryOp op);
static void emit_indent(FILE *out, int indent);

void codegen_lua_emit(FILE *out, const AstProgram *program, const FunctionTable *functions)
{
	if (!out || !program || !functions)
	{
		return;
	}
	emit_program(out, program, functions);
}

static void emit_program(FILE *out, const AstProgram *program, const FunctionTable *functions)
{
	const AstFunction *main_function = NULL;
	const FunctionSignature *main_signature = NULL;

	for (size_t i = 0; i < program->functions.count; ++i)
	{
		const AstFunction *fn = program->functions.items[i];
		if (fn && strcmp(fn->name, "main") == 0)
		{
			main_function = fn;
			main_signature = lookup_signature(functions, fn->name);
			continue;
		}
		const FunctionSignature *signature = lookup_signature(functions, fn->name);
		emit_function(out, fn, signature, functions);
		fputc('\n', out);
	}

	if (main_function && main_signature)
	{
		emit_main_wrapper(out, main_function, main_signature, functions);
	}
}

static void emit_function(FILE *out, const AstFunction *fn, const FunctionSignature *signature, const FunctionTable *functions)
{
	(void)signature;
	emit_indent(out, 0);
	fprintf(out, "local function %s(", fn->name);
	for (size_t i = 0; i < fn->params.count; ++i)
	{
		if (i > 0)
		{
			fputs(", ", out);
		}
		fputs(fn->params.items[i].name, out);
	}
	fputs(")\n", out);
	emit_block(out, &fn->body, functions, signature, 1, 0);
	emit_indent(out, 0);
	fputs("end\n", out);
}

static void emit_main_wrapper(FILE *out, const AstFunction *fn, const FunctionSignature *signature, const FunctionTable *functions)
{
	emit_indent(out, 0);
	fputs("os.exit((function(args)\n", out);

	if (fn->params.count > 0)
	{
		emit_indent(out, 1);
		fputs("local args_table = args\n", out);
		for (size_t i = 0; i < fn->params.count; ++i)
		{
			const AstParam *param = &fn->params.items[i];
			emit_indent(out, 1);
			switch (param->type)
			{
			case TYPE_INT:
				fprintf(out, "local %s = args_table and tonumber(args_table[%zu]) or 0\n", param->name, i + 1);
				break;
			case TYPE_FLOAT:
				fprintf(out, "local %s = args_table and tonumber(args_table[%zu]) or 0.0\n", param->name, i + 1);
				break;
			case TYPE_BOOL:
				fprintf(out, "local %s = args_table and args_table[%zu] ~= nil or false\n", param->name, i + 1);
				break;
			default:
				fprintf(out, "local %s = args_table and args_table[%zu] or nil\n", param->name, i + 1);
				break;
			}
		}
	}

	emit_block(out, &fn->body, functions, signature, 1, 0);

	emit_indent(out, 0);
	fputs("end)(arg))\n", out);
}

static void emit_block(FILE *out, const AstBlock *block, const FunctionTable *functions, const FunctionSignature *signature, int indent, int wrap_with_do)
{
	if (!block)
	{
		return;
	}

	int current_indent = indent;
	if (wrap_with_do)
	{
		emit_indent(out, indent);
		fputs("do\n", out);
		current_indent = indent + 1;
	}

	for (size_t i = 0; i < block->statements.count; ++i)
	{
		const AstStmt *stmt = block->statements.items[i];
		emit_statement(out, stmt, functions, signature, current_indent);
	}

	if (wrap_with_do)
	{
		emit_indent(out, indent);
		fputs("end\n", out);
	}
}

static void emit_statement(FILE *out, const AstStmt *stmt, const FunctionTable *functions, const FunctionSignature *signature, int indent)
{
	if (!stmt)
	{
		return;
	}

	switch (stmt->kind)
	{
	case STMT_BLOCK:
		emit_block(out, &stmt->data.block, functions, signature, indent, 1);
		break;
	case STMT_DECL:
		emit_indent(out, indent);
		fprintf(out, "local %s", stmt->data.decl.name);
		if (stmt->data.decl.init)
		{
			fputs(" = ", out);
			emit_expression_expected(out, stmt->data.decl.init, functions, stmt->data.decl.type);
		}
		fputc('\n', out);
		break;
	case STMT_ASSIGN:
		emit_indent(out, indent);
		fprintf(out, "%s = ", stmt->data.assign.name);
		emit_expression_expected(out, stmt->data.assign.value, functions, stmt->data.assign.type);
		fputc('\n', out);
		break;
	case STMT_EXPR:
		if (stmt->data.expr)
		{
			emit_indent(out, indent);
			emit_expression_raw(out, stmt->data.expr, functions);
			fputc('\n', out);
		}
		break;
	case STMT_RETURN:
		emit_indent(out, indent);
		fputs("return", out);
		if (stmt->data.expr)
		{
			fputc(' ', out);
			TypeKind expected = signature ? signature->return_type : TYPE_UNKNOWN;
			emit_expression_expected(out, stmt->data.expr, functions, expected);
		}
		fputc('\n', out);
		break;
	}
}

static void emit_expression_expected(FILE *out, const AstExpr *expr, const FunctionTable *functions, TypeKind expected_type)
{
	if (!expr)
	{
		fputs("nil", out);
		return;
	}

	TypeKind actual = expr->type;
	if (expected_type == TYPE_UNKNOWN || actual == TYPE_UNKNOWN || expected_type == actual)
	{
		emit_expression_raw(out, expr, functions);
		return;
	}

	if (expected_type == TYPE_INT && actual == TYPE_FLOAT)
	{
		fputs("math.floor(", out);
		emit_expression_raw(out, expr, functions);
		fputc(')', out);
		return;
	}

	emit_expression_raw(out, expr, functions);
}

static void emit_expression_raw(FILE *out, const AstExpr *expr, const FunctionTable *functions)
{
	if (!expr)
	{
		fputs("nil", out);
		return;
	}

	switch (expr->kind)
	{
	case EXPR_INT_LITERAL:
		fprintf(out, "%lld", expr->data.int_value);
		break;
	case EXPR_FLOAT_LITERAL:
		fprintf(out, "%g", expr->data.float_value);
		break;
	case EXPR_BOOL_LITERAL:
		fputs(expr->data.bool_value ? "true" : "false", out);
		break;
	case EXPR_IDENTIFIER:
		fputs(expr->data.identifier, out);
		break;
	case EXPR_BINARY:
		fputc('(', out);
		emit_expression_raw(out, expr->data.binary.left, functions);
		fprintf(out, " %s ", binary_op_token(expr->data.binary.op));
		emit_expression_raw(out, expr->data.binary.right, functions);
		fputc(')', out);
		break;
	case EXPR_UNARY:
		if (expr->data.unary.op == UN_OP_NEG)
		{
			fputc('-', out);
			fputc('(', out);
			emit_expression_raw(out, expr->data.unary.operand, functions);
			fputc(')', out);
		}
		else if (expr->data.unary.op == UN_OP_NOT)
		{
			fputs("not ", out);
			emit_expression_raw(out, expr->data.unary.operand, functions);
		}
		else
		{
			emit_expression_raw(out, expr->data.unary.operand, functions);
		}
		break;
	case EXPR_CALL:
		emit_call(out, expr, functions);
		break;
	}
}

static void emit_call(FILE *out, const AstExpr *expr, const FunctionTable *functions)
{
	const FunctionSignature *signature = lookup_signature(functions, expr->data.call.callee);
	fputs(expr->data.call.callee, out);
	fputc('(', out);
	for (size_t i = 0; i < expr->data.call.args.count; ++i)
	{
		if (i > 0)
		{
			fputs(", ", out);
		}
		TypeKind expected = TYPE_UNKNOWN;
		if (signature && i < signature->params.count)
		{
			expected = signature->params.items[i].type;
		}
		emit_expression_expected(out, expr->data.call.args.items[i], functions, expected);
	}
	fputc(')', out);
}

static const FunctionSignature *lookup_signature(const FunctionTable *functions, const char *name)
{
	if (!functions || !name)
	{
		return NULL;
	}
	return function_table_find(functions, name);
}

static const char *binary_op_token(AstBinaryOp op)
{
	switch (op)
	{
	case BIN_OP_ADD:
		return "+";
	case BIN_OP_SUB:
		return "-";
	case BIN_OP_MUL:
		return "*";
	case BIN_OP_DIV:
		return "/";
	case BIN_OP_MOD:
		return "%";
	case BIN_OP_EQ:
		return "==";
	case BIN_OP_NEQ:
		return "~=";
	case BIN_OP_LT:
		return "<";
	case BIN_OP_LE:
		return "<=";
	case BIN_OP_GT:
		return ">";
	case BIN_OP_GE:
		return ">=";
	}
	return "?";
}

static void emit_indent(FILE *out, int indent)
{
	for (int i = 0; i < indent; ++i)
	{
		fputs("\t", out);
	}
}
