#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <math.h>
#include <stdbool.h>
#include "ucs_poiss_ascent.h"
#include "ucs_ftodv.h"
#include "ucs_ftodm.h"

int main(void)
{
	gsl_vector *param = ucs_ftodv("data/poiss_d1_param.dat", true);
	gsl_matrix *data = ucs_ftodm("data/poiss_d1.dat", true);
	double val;
	ll(param, data, &val);
	if (
			(fabs(
				val -
				(-0.4470794995433942)
			) > 0.01)
	) {
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
