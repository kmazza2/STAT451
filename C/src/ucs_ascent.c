#include "ucs_ascent.h"
#include "ucs_convergence.h"
#include <math.h>
#include <float.h>
#include <time.h>

struct ucs_iter_result ucs_ascent(
		gsl_vector *param,
                size_t max_iter,
                double epsabs,
                double epsrel,
                void (*ll)(gsl_vector *param, gsl_matrix *data,
			double *val),
                void (*d1)(gsl_vector *param, gsl_matrix *data,
			gsl_vector *val),
                gsl_matrix *data,
		bool verbose
)
{
	clock_t start_clock = clock();
	struct ucs_iter_result result = {
		.converged = false,
		.iter = 0,
		.time = 0,
		.param = gsl_vector_alloc(param->size),
	};
	gsl_vector_memcpy(result.param, param);
	gsl_vector *next_param = gsl_vector_alloc(result.param->size);
	gsl_vector_memcpy(next_param, param);
	gsl_vector *first_deriv = gsl_vector_alloc(result.param->size);
	gsl_matrix *identity = gsl_matrix_alloc(result.param->size,
		result.param->size);
	gsl_matrix_set_identity(identity);
	double ll1;
	double ll2;
	while (result.iter < max_iter) {
		d1(result.param, data, first_deriv);
		ll(result.param, data, &ll2);
		for(;;) {
			gsl_vector_memcpy(next_param, result.param);
			gsl_vector_add(next_param, first_deriv);
			ll(next_param, data, &ll1);
			if (ll1 >= ll2) {
				break;
			}
			gsl_vector_scale(first_deriv, 1.0/2.0);
		}
		++result.iter;
		if (
				convergence_occurred(
					result.param,
					next_param,
					epsabs,
					epsrel
				)
		) {
			result.converged = true;
			break;
		}
		if (ll1 == ll2) {
			break;
		}
		gsl_vector_memcpy(result.param, next_param);
	}
	/* Return final value to user in param, even if no convergence */
	gsl_vector_memcpy(result.param, next_param);
	gsl_vector_free(next_param);
	gsl_vector_free(first_deriv);
	clock_t end_clock = clock();
	result.time = (end_clock - start_clock) / (double) CLOCKS_PER_SEC;
	return result;
}
