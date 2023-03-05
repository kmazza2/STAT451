#include "ucs_ascent.h"
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <math.h>

void ll(gsl_vector *param, gsl_matrix *data, double *val)
{
	double x = gsl_vector_get(param, 0);
	double y = gsl_vector_get(param, 1);
	*val = (-1) * pow(x, 2) + (-1) * pow(y, 2);
}

void d1(gsl_vector *param, gsl_matrix *data, gsl_vector *val)
{
	double x = gsl_vector_get(param, 0);
	double y = gsl_vector_get(param, 1);
	gsl_vector_set(val, 0, -2 * x);
	gsl_vector_set(val, 1, -2 * y);
}

int main(void)
{
	gsl_vector *param = gsl_vector_alloc(2);
	gsl_vector_set(param, 0, 3);
	gsl_vector_set(param, 1, -3);
	struct ucs_iter_result result = ucs_ascent(
		param,
		10000,
		0.0001,
		0.0001,
		ll,
		d1,
		NULL,
		false
	);
	if (!result.converged) {
		return EXIT_FAILURE;
	}
	if (
			(fabs(gsl_vector_get(result.param, 0) - 0) > 0.3) ||
			(fabs(gsl_vector_get(result.param, 1) - 0) > 0.3)
	) {
		return EXIT_FAILURE;
	}
	gsl_vector_free(param);
	gsl_vector_free(result.param);
	return EXIT_SUCCESS;
}
