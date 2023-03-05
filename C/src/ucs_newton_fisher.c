#include "ucs_newton_fisher.h"
#include "ucs_solve.h"
#include "ucs_convergence.h"
#include <math.h>
#include <float.h>
#include <time.h>

struct ucs_iter_result ucs_newton_fisher(
		gsl_vector *param,
                size_t max_iter,
                double epsabs,
                double epsrel,
                void (*d1)(gsl_vector *param, gsl_matrix *data,
			gsl_vector *val),
                void (*d2)(gsl_vector *param, gsl_matrix *data,
			gsl_matrix *val),
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
	gsl_vector_memcpy(next_param, result.param);
	gsl_vector *first_deriv = gsl_vector_alloc(result.param->size);
	gsl_matrix *second_deriv = gsl_matrix_alloc(result.param->size, result.param->size);
	gsl_vector *update = gsl_vector_alloc(result.param->size);
	while (result.iter < max_iter) {
		d1(next_param, data, first_deriv);
		d2(next_param, data, second_deriv);
		gsl_matrix_scale(second_deriv, -1);
		ucs_solve(second_deriv, update, first_deriv);
		gsl_vector_add(next_param, update);
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
		gsl_vector_memcpy(result.param, next_param);
	}
	/* Return final value to user in param, even if no convergence */
	gsl_vector_memcpy(result.param, next_param);
	gsl_vector_free(next_param);
	gsl_vector_free(first_deriv);
	gsl_vector_free(update);
	gsl_matrix_free(second_deriv);
	clock_t end_clock = clock();
	result.time = (end_clock - start_clock) / (double) CLOCKS_PER_SEC;
	return result;
}
