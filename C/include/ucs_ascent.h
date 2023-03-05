#ifndef __UCS_ASCENT_H__
#define __UCS_ASCENT_H__

#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <stdbool.h>
#include "ucs_iter_result.h"

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
);

#endif
