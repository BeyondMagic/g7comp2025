CC = gcc
LEX = flex
YACC = bison
CFLAGS = -Wall -Wextra -std=c11 -D_POSIX_C_SOURCE=200809L -Isrc -I.
TARGET = c2lua

SRC = src/main.c \
	  src/ast.c \
	  src/symbol_table.c \
	  src/semantic.c \
	  src/codegen_lua.c
LEX_SRC = src/lexer.l
YACC_SRC = src/parser.y

LEX_OUT = lex.yy.c
YACC_OUT = parser.tab.c
YACC_HEADER = parser.tab.h

SMOKE_DIR = tests/smoke
SMOKE_SOURCES := $(wildcard $(SMOKE_DIR)/*.c)
SMOKE_CASES := $(basename $(notdir $(SMOKE_SOURCES)))
SEMANTIC_SCRIPT = scripts/run_semantic_tests.sh

all: $(TARGET)

$(TARGET): $(LEX_OUT) $(YACC_OUT) $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_OUT) $(YACC_OUT) $(SRC) -lfl

$(LEX_OUT): $(LEX_SRC) $(YACC_HEADER)
	$(LEX) $(LEX_SRC)

$(YACC_OUT) $(YACC_HEADER): $(YACC_SRC) src/ast.h src/ast.c
	cd src && $(YACC) -d --defines=../parser.tab.h -o ../parser.tab.c parser.y

clean:
	rm -f $(TARGET) $(LEX_OUT) $(YACC_OUT) $(YACC_HEADER)

test: all
	@echo "== Running smoke tests =="
	@if [ -z "$(SMOKE_CASES)" ]; then \
		echo "No smoke tests found under $(SMOKE_DIR)"; \
	else \
		for case in $(SMOKE_CASES); do \
			input="$(SMOKE_DIR)/$$case.c"; \
			expected_file="$(SMOKE_DIR)/$$case.lua"; \
			if [ ! -f "$$expected_file" ]; then \
				echo "Missing expected Lua file for $$case"; \
				exit 1; \
			fi; \
			output=$$(./c2lua "$$input"); \
			expected=$$(cat "$$expected_file"); \
			printf '%s' "-- $$case... "; \
			if [ "$$output" = "$$expected" ]; then \
				echo "ok"; \
			else \
				echo "fail"; \
				printf 'Expected:\n%s\n\nGot:\n%s\n' "$$expected" "$$output"; \
				exit 1; \
			fi; \
		done; \
		echo "All smoke tests passed."; \
	fi

semantic-test: all
	@echo "== Running semantic tests =="
	@COMPILER_CMD=./c2lua bash $(SEMANTIC_SCRIPT)
