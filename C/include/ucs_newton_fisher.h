#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <stdbool.h>

bool ucs_newton_fisher(
		gsl_vector *param,
		size_t max_iter,
		double epsabs,
		double epsrel,
		void (*d1)(gsl_vector *param, gsl_vector *val),
		void (*d2)(gsl_vector *param, gsl_matrix *val),
		const char *data,
		bool verbose
);
