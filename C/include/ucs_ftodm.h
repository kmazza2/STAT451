#include <stdbool.h>
#include <gsl/gsl_matrix.h>

/* reads file into matrix of doubles */
/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_matrix *ucs_ftodm(char* path, bool header);
