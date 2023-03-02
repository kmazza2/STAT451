#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include "ucs_ftodm.h"
#include "ucs_ftodv.h"

/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_vector *ucs_ftodv(char* path, bool header) {
	gsl_matrix *data = ucs_ftodm(path, header);
	size_t length = gsl_matrix_column(data, 0).vector.size;
	gsl_vector *vec = gsl_vector_alloc(length);
	gsl_matrix_get_col(vec, data, 0);
	gsl_matrix_free(data);
	return vec;
}
