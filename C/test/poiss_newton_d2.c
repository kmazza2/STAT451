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
	gsl_matrix *val = gsl_matrix_alloc(param->size, param->size);
	d2(param, data, val);
	if (
			(fabs(
				gsl_matrix_get(val, 0, 0) -
				-1.444953113663958
			) > 0.01) ||
			(fabs(
				gsl_matrix_get(val, 0, 1) -
				-0.927506487901246
			) > 0.01) ||
			(fabs(
				gsl_matrix_get(val, 1, 0) -
				-0.927506487901246
			) > 0.01) ||
			(fabs(
				gsl_matrix_get(val, 1, 1) -
				-0.6102036501114272
			) > 0.01)
	) {
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
