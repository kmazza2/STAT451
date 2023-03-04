#include "ucs_newton_fisher.h"

void d1(gsl_vector *param, gsl_matrix *data, gsl_vector *val)
{
	gsl_vector_set(val, 0, 2 * gsl_vector_get(param, 0));
}

void d2(gsl_vector *param, gsl_matrix *data, gsl_matrix *val)
{
	gsl_matrix_set(val, 0, 0, 2);
}

int main(void)
{
	gsl_vector *param = gsl_vector_alloc(1);
	gsl_vector_set(param, 0, 5);
	struct ucs_iter_result result = ucs_newton_fisher(
		param,
		10000,
		0.0001,
		0.0001,
		d1,
		d2,
		NULL,
		false
	);
	if (
			(!result.converged) ||
			(gsl_vector_get(result.param, 0) != 0)
) {
		return EXIT_FAILURE;
	}
	gsl_vector_free(result.param);
	return EXIT_SUCCESS;
}
