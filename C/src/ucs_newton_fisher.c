#include "ucs_newton_fisher.h"
#include "ucs_solve.h"
#include <math.h>
#include <float.h>

bool convergence_occurred(gsl_vector *, gsl_vector *, double, double);

struct ucs_iter_result ucs_newton_fisher(
		gsl_vector *param,
                size_t max_iter,
                double epsabs,
                double epsrel,
                void (*d1)(gsl_vector *param, gsl_vector *val),
                void (*d2)(gsl_vector *param, gsl_matrix *val),
                const char *data,
		bool verbose
) {
	struct ucs_iter_result result = {
		.converged = false,
		.iter = 0,
	};
	gsl_vector *cur_param = gsl_vector_alloc(param->size);
	gsl_vector_memcpy(cur_param, param);
	gsl_vector *first_deriv = gsl_vector_alloc(param->size);
	gsl_matrix *second_deriv = gsl_matrix_alloc(param->size, param->size);
	gsl_vector *update = gsl_vector_alloc(param->size);
	while (1) {
		if (result.iter == max_iter) {
			break;
		}
		d1(cur_param, first_deriv);
		d2(cur_param, second_deriv);
		gsl_matrix_scale(second_deriv, -1);
		ucs_solve(second_deriv, update, first_deriv);
		gsl_vector_add(cur_param, update);
		++result.iter;
		if (
				convergence_occurred(
					param,
					cur_param,
					epsabs,
					epsrel
				)
		) {
			result.converged = true;
			break;
		}
		gsl_vector_memcpy(param, cur_param);
	}
	/* Return final value to user in param, even if no convergence */
	gsl_vector_memcpy(param, cur_param);
	gsl_vector_free(cur_param);
	gsl_vector_free(first_deriv);
	gsl_vector_free(update);
	gsl_matrix_free(second_deriv);
	return result;
}


bool convergence_occurred(
		gsl_vector *param,
		gsl_vector *cur_param,
		double epsabs,
		double epsrel
) {
	double abs_diff;
	for (int i = 0; i < param->size; ++i) {
		double param_i = gsl_vector_get(param, i);
		double cur_param_i = gsl_vector_get(cur_param, i);
		abs_diff = fabs(cur_param_i - param_i);
		if (
				(abs_diff >= epsabs) ||
				(abs_diff / (fabs(param_i) + DBL_MIN) >= epsrel)
		) {
			return false;
		}
	}
	return true;
}
