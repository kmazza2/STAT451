#ifndef __UCS_NEWTON_FISHER_H__
#define __UCS_NEWTON_FISHER_H__

#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <stdbool.h>
#include "ucs_iter_result.h"

/* runs Newton-like method on function with
   first derivative d1 and second derivative d2 */
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
);

#endif
