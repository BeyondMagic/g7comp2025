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
	./$(TARGET) < tests/variable.c
