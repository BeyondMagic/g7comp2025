#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1024

static void transpile_stream(FILE *in);
static void emit_line(char *line);
static void trim_trailing(char *line);

int main(int argc, char **argv)
{
	FILE *in = stdin;

	if (argc > 2)
	{
		fprintf(stderr, "Uso: %s [arquivo.c]\n", argv[0]);
		return EXIT_FAILURE;
	}

	if (argc == 2)
	{
		in = fopen(argv[1], "r");
		if (!in)
		{
			fprintf(stderr, "Erro ao abrir %s: %s\n", argv[1], strerror(errno));
			return EXIT_FAILURE;
		}
	}

	transpile_stream(in);

	if (in != stdin)
	{
		fclose(in);
	}

	return EXIT_SUCCESS;
}

static void transpile_stream(FILE *in)
{
	char buffer[MAX_LINE];

	while (fgets(buffer, sizeof(buffer), in))
	{
		trim_trailing(buffer);
		emit_line(buffer);
	}
}

static void emit_line(char *line)
{
	char *cursor = line;

	while (*cursor && isspace((unsigned char)*cursor))
	{
		cursor++;
	}

	if (*cursor == '\0')
	{
		return;
	}

	trim_trailing(cursor);

	size_t len = strlen(cursor);
	if (len == 0)
	{
		return;
	}

	if (cursor[len - 1] == ';')
	{
		cursor[len - 1] = '\0';
		trim_trailing(cursor);
	}

	if (strncmp(cursor, "int ", 4) == 0)
	{
		char *rest = cursor + 4;
		while (*rest && isspace((unsigned char)*rest))
		{
			rest++;
		}
		if (*rest == '\0')
		{
			return;
		}
		printf("local %s\n", rest);
		return;
	}

	printf("%s\n", cursor);
}

static void trim_trailing(char *line)
{
	size_t len = strlen(line);

	while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r'))
	{
		line[--len] = '\0';
	}

	while (len > 0 && isspace((unsigned char)line[len - 1]))
	{
		line[--len] = '\0';
	}
}
