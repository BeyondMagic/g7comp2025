CC = gcc
LEX = flex
YACC = bison
CFLAGS = -Wall
TARGET = c2lua

SRC = src/main.c
LEX_SRC = src/lexer.l
YACC_SRC = src/parser.y

LEX_OUT = lex.yy.c
YACC_OUT = parser.tab.c
YACC_HEADER = parser.tab.h

all: $(TARGET)

$(TARGET): $(LEX_OUT) $(YACC_OUT) $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_OUT) $(YACC_OUT) $(SRC) -lfl

$(LEX_OUT): $(LEX_SRC)
	$(LEX) $(LEX_SRC)

$(YACC_OUT): $(YACC_SRC)
	$(YACC) -d $(YACC_SRC)

clean:
	rm -f $(TARGET) $(LEX_OUT) $(YACC_OUT) $(YACC_HEADER)

test: all
	@echo "== Running sample tests =="
	@./c2lua tests/expr1.txt | diff -u - tests/expr1.ast && echo "expr1 ✓" || (echo "expr1 ✗"; exit 1)
	@./c2lua tests/expr2.txt | diff -u - tests/expr2.ast && echo "expr2 ✓" || (echo "expr2 ✗"; exit 1)
	@./c2lua tests/expr3.txt | diff -u - tests/expr3.ast && echo "expr3 ✓" || (echo "expr3 ✗"; exit 1)
	@echo "All tests passed."
