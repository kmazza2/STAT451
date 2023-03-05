#include "ucs_convergence.h"

bool convergence_occurred(
		gsl_vector *param,
		gsl_vector *next_param,
		double epsabs,
		double epsrel
)
{
	double abs_diff;
	for (int i = 0; i < param->size; ++i) {
		double param_i = gsl_vector_get(param, i);
		double next_param_i = gsl_vector_get(next_param, i);
		abs_diff = fabs(next_param_i - param_i);
		if (
				(abs_diff >= epsabs) ||
				(abs_diff / (fabs(param_i) + DBL_MIN) >= epsrel)
		) {
			return false;
		}
	}
	return true;
}
