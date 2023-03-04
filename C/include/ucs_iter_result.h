#ifndef __UCS_ITER_RESULT_H__
#define __UCS_ITER_RESULT_H__

#include <gsl/gsl_vector.h>

/* provides a return type for iterative methods like Newton-Raphson */
struct ucs_iter_result {
	bool converged;
	size_t iter;
	gsl_vector *param;
};

#endif
