#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>

/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
void ucs_solve(gsl_matrix *A, gsl_vector *x, gsl_vector *b);
