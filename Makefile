# Simple build for CLI that prints AST of expressions (debug tool)
# Requires: flex, bison, gcc
# Targets: make cli, make clean, make test

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -O2 -I./src
LDFLAGS = 
LEX = flex
YACC = bison

# Outputs from Flex/Bison
PARSER_C = parser/parser.tab.c
PARSER_H = parser/parser.tab.h
LEXER_C  = lexer/lex.yy.c

OBJS = $(PARSER_C) $(LEXER_C) src/ast.c src/main.c

all: cli

cli: $(OBJS)
	$(CC) $(CFLAGS) -o c2lua $(OBJS) $(LDFLAGS)

$(PARSER_C) $(PARSER_H): parser/parser.y src/ast.h
	$(YACC) -d -v -Wcounterexamples -o $(PARSER_C) parser/parser.y

$(LEXER_C): lexer/lexer.l $(PARSER_H)
	$(LEX) -o $(LEXER_C) lexer/lexer.l

clean:
	rm -f c2lua $(PARSER_C) $(PARSER_H) $(LEXER_C) parser/parser.output
	rm -rf build

test: cli
	@echo "== Running sample tests =="
	@./c2lua tests/expr1.txt | diff -u - tests/expr1.ast && echo "expr1 ✓" || (echo "expr1 ✗"; exit 1)
	@./c2lua tests/expr2.txt | diff -u - tests/expr2.ast && echo "expr2 ✓" || (echo "expr2 ✗"; exit 1)
	@./c2lua tests/expr3.txt | diff -u - tests/expr3.ast && echo "expr3 ✓" || (echo "expr3 ✗"; exit 1)
	@echo "All tests passed."
