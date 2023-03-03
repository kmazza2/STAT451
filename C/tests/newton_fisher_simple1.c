#include "ucs_newton_fisher.h"

void d1(gsl_vector *param, gsl_vector *val) {
	gsl_vector_set(val, 0, 2 * gsl_vector_get(param, 0));
}

void d2(gsl_vector *param, gsl_matrix *val) {
	gsl_matrix_set(val, 0, 0, 2);
}

int main(void) {
	gsl_vector *init_guess = gsl_vector_alloc(1);
	gsl_vector_set(init_guess, 0, 5);
	bool converged = ucs_newton_fisher(
		init_guess,
		10000,
		0.0001,
		0.0001,
		d1,
		d2,
		"data/A1.dat",
		false
	);
	if (
			(!converged) ||
			(gsl_vector_get(init_guess, 0) != 0)
) {
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
