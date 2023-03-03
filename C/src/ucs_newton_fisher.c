#include "ucs_newton_fisher.h"

int ucs_newton_fisher(
		gsl_vector *init_guess,
                size_t max_iter,
                double epsabs,
                double epsrel,
                void (*d1)(gsl_vector *param, gsl_vector *val),
                void (*d2)(gsl_vector *param, gsl_matrix *val),
                const char *data
) {
	return 0;
}
