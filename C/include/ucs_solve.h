#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>

/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_vector *ucs_solve(gsl_matrix *A, gsl_vector *b);
