#include "ucs_ascent.h"
#include "ucs_poiss_ascent.h"
#include "ucs_ftodm.h"
#include "ucs_ftodv.h"
#include <math.h>

int main(void)
{
	gsl_vector *param = ucs_ftodv("data/fakeoilspillsparam.dat", true);
	gsl_matrix *data = ucs_ftodm("data/fakeoilspills.dat", true);
	struct ucs_iter_result result = ucs_ascent(
		param,
		10000,
		0.0001,
		0.0001,
		ll,
		d1,
		data,
		false
	);
	if (!result.converged) {
		return EXIT_FAILURE;
	}
	if (
			(fabs(gsl_vector_get(result.param, 0) - 3) > 0.3) ||
			(fabs(gsl_vector_get(result.param, 1) - 1) > 0.3)
	) {
		return EXIT_FAILURE;
	}
	gsl_vector_free(param);
	gsl_vector_free(result.param);
	gsl_matrix_free(data);
	return EXIT_SUCCESS;
}
