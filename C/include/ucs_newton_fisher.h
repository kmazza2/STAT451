#include "ucs_result.h"
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>

struct ucs_result ucs_newton_fisher(
		size_t max_iter,
		double epsabs,
		double epsrel,
		void (*d1)(gsl_vector *param, gsl_vector *val),
		void (*d2)(gsl_vector *param, gsl_matrix *val),
		const char *data,
		const char *init_guess
);
