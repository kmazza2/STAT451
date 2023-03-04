#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <math.h>
#include <stdbool.h>
#include "ucs_poiss_d.h"
#include "ucs_ftodv.h"
#include "ucs_ftodm.h"

int main(void)
{
	gsl_vector *param = ucs_ftodv("data/poiss_d1_param.dat", true);
	gsl_matrix *data = ucs_ftodm("data/poiss_d1.dat", true);
	gsl_vector *val = gsl_vector_alloc(param->size);
	gsl_vector_fprintf(stderr, param, "%f");  /* DEBUG */
	gsl_matrix_fprintf(stderr, data, "%f");  /* DEBUG */
	d1(param, data, val);
	gsl_vector_fprintf(stderr, val, "%f");  /* DEBUG */
	if (
			(fabs(
				gsl_vector_get(val, 0) -
				1.370240181424595
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
