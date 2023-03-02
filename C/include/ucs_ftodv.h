#include <stdbool.h>
#include <gsl/gsl_vector.h>

/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_vector *ucs_ftodv(char* path, bool header);
