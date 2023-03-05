#ifndef __UCS_CONVERGENCE_H__
#define __UCS_CONVERGENCE_H__

#include <math.h>
#include <gsl/gsl_vector.h>
#include <float.h>
#include <stdbool.h>

bool convergence_occurred(gsl_vector *, gsl_vector *, double, double);

#endif
