#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <math.h>
#include <stdbool.h>
#include "ucs_poiss_newton.h"
#include "ucs_ftodv.h"
#include "ucs_ftodm.h"

int main(void)
{
	gsl_vector *param = ucs_ftodv("data/poiss_d1_param.dat", true);
	gsl_matrix *data = ucs_ftodm("data/poiss_d1.dat", true);
	gsl_vector *val = gsl_vector_alloc(param->size);
	d1(param, data, val);
	if (
			(fabs(
				gsl_vector_get(val, 0) -
				0.3702401814245953
			) > 0.01) ||
			(fabs(
				gsl_vector_get(val, 1) -
				0.1951809091846201
			) > 0.01)
	) {
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
