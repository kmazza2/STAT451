#ifndef __UCS_FTODV_H__
#define __UCS_FTODV_H__

#include <stdbool.h>
#include <gsl/gsl_vector.h>

/* reads file into vector of doubles */
/* This either succeeds or crashes the program, so
   it can be used as though it always succeeds.    */
gsl_vector *ucs_ftodv(char* path, bool header);

#endif
