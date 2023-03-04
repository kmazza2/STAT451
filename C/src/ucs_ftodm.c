#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <gsl/gsl_matrix.h>
#include "ucs_ftodm.h"

/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_matrix *ucs_ftodm(char* path, bool header)
{
	FILE *stream;
	char *line = NULL;
	size_t len = 0;
	ssize_t nread;
	bool read_header = header ? false : true;
	char *token;
	char *end = NULL;
	double num;
	size_t num_cols = 0;
	size_t num_records = 0;
	/* First find number of columns and number of records */
	stream = fopen(path, "r");
	if (stream == NULL) {
		perror("fopen");
		exit(EXIT_FAILURE);
	}
	while ((nread = getline(&line, &len, stream)) != -1) {
		if (header && !read_header) {
			token = strtok(line, " ");
			if (token == NULL) {
				perror("malformed file");
				exit(EXIT_FAILURE);
			}
			do {
				++num_cols;
			} while ((token = strtok(NULL, " ")));
			read_header = true;
			continue;
		}
		size_t num_fields_line = 0;
		token = strtok(line, " ");
		if (token == NULL) {
			perror("malformed file");
			exit(EXIT_FAILURE);
		}
		do {
			if (!header && num_records == 0) {
				++num_cols;
			}
			++num_fields_line;
		} while ((token = strtok(NULL, " ")));
		if (num_fields_line != num_cols) {
			perror("malformed record");
			exit(EXIT_FAILURE);
		}
		++num_records;
	}
	/* Now get the data */
	errno = 0;
	rewind(stream);
	if (errno != 0) {
		perror("could not rewind");
		exit(EXIT_FAILURE);
	}
	gsl_matrix *data = gsl_matrix_alloc(num_records, num_cols);
	size_t i = 0;
	size_t j = 0;
	read_header = header ? false : true;
	while ((nread = getline(&line, &len, stream)) != -1) {
		if (!read_header) {
			read_header = true;
			continue;
		}
		token = strtok(line, " ");
		do {
			num =
				(
					!strcmp(token, "NA") ||
					!strcmp(token, "NA\n")
				) ?
				NAN :
				strtod(token, &end);
			if (token == end) {
				perror("malformed record");
				exit(EXIT_FAILURE);
			}
			gsl_matrix_set(data, i, j, num);
			++j;
		} while ((token = strtok(NULL, " ")));
		j = 0;
		++i;
	}
	free(line);
	fclose(stream);
	return data;
}
