#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <gsl/gsl_vector.h>
#include "ucs_ftodv.h"

/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_vector *ucs_ftodv(char* path, bool header) {
	FILE *stream;
	char *line = NULL;
	size_t len = 0;
	ssize_t nread;
	bool read_header = header ? false : true;
	char *token;
	char *endptr;
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
			do {
				++num_cols;
				if (num_cols > 1) {
					perror("malformed file");
					exit(EXIT_FAILURE);
				}
			} while ((token = strtok(NULL, " ")));
			read_header = true;
			continue;
		}
		size_t num_fields_line = 0;
		token = strtok(line, " ");
		do {
			if (!header && num_records == 0) {
				++num_cols;
				if (num_cols > 1) {
					perror("malformed file");
					exit(EXIT_FAILURE);
				}
			}
			++num_fields_line;
			if (num_fields_line > 1) {
				perror("malformed file");
				exit(EXIT_FAILURE);
			}
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
	gsl_vector *data = gsl_vector_alloc(num_records);
	size_t i = 0;
	read_header = header ? false : true;
	while ((nread = getline(&line, &len, stream)) != -1) {
		if (!read_header) {
			read_header = true;
			continue;
		}
		token = strtok(line, " ");
		do {
			if (token != endptr) {
				num =
					(
						!strcmp(token, "NA") ||
						!strcmp(token, "NA\n")
					) ?
					NAN :
					strtod(token, &endptr);
				gsl_vector_set(data, i, num);
			}
		} while ((token = strtok(NULL, " ")));
		++i;
	}
	free(line);
	fclose(stream);
	return data;
}
