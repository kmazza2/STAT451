#include "ucs_ftodm.h"
#include "ucs_ftodv.h"
#include "ucs_solve.h"
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <gsl/gsl_linalg.h>
#include <math.h>

int main(void) {
	gsl_matrix *A = ucs_ftodm("data/A1.dat", false);
	gsl_vector *b = ucs_ftodv("data/b1.dat", false);
	gsl_vector *x = gsl_vector_alloc(b->size);
	ucs_solve(A, x, b);
	const double eps = 0.001;
	if (
			fabs(gsl_vector_get(x,0) - 0.4310) > eps ||
			fabs(gsl_vector_get(x,1) - (-0.1034)) > eps
	) {
		return EXIT_FAILURE;
	}
	gsl_matrix_free(A);
	gsl_vector_free(b);
	gsl_vector_free(x);
	return EXIT_SUCCESS;
}
