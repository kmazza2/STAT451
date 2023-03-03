#include "ucs_converge.h"
#include <gsl/gsl_vector.h>

struct ucs_result {
	enum ucs_converge status;
	gsl_vector *solution;
};
