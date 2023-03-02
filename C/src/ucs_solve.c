#include <gsl/gsl_matrix.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_permutation.h>
#include <gsl/gsl_linalg.h>
#include "ucs_solve.h"

gsl_vector *ucs_solve(gsl_matrix *A, gsl_vector *b) {
	gsl_permutation *p = gsl_permutation_alloc(b->size);
	gsl_vector *x = gsl_vector_alloc(b->size);
	int s;
	gsl_linalg_LU_decomp(A, p, &s);
	gsl_linalg_LU_solve(A, p, b, x);
	gsl_permutation_free(p);
	return x;
}
