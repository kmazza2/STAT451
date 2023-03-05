#include "ucs_ascent.h"
#include "ucs_ftodm.h"
#include "ucs_ftodv.h"
#include "ucs_poiss_ascent.h"
#include <math.h>

int main(int argc, char *argv[])
{
	gsl_vector *param = ucs_ftodv(argv[1], true);
	gsl_matrix *data = ucs_ftodm(argv[2], true);
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
	fprintf(stderr, "Initial guess: \n");
	gsl_vector_fprintf(stderr, param, "%f");
	fprintf(stderr, "Converged: %d\n", result.converged);
	fprintf(stderr, "Iterations: %zu\n", result.iter);
	fprintf(stderr, "Time: %.20f sec\n", result.time);
	fprintf(stderr, "Estimate: \n");
	gsl_vector_fprintf(stdout, result.param, "%f");
	gsl_vector_free(param);
	gsl_matrix_free(data);
	gsl_vector_free(result.param);
	return EXIT_SUCCESS;
}
