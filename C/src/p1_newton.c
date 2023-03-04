#include "ucs_newton_fisher.h"
#include "ucs_ftodm.h"
#include "ucs_ftodv.h"
#include <math.h>

void d1(gsl_vector *param, gsl_matrix *data, gsl_vector *val)
{
	double d1_1 = 0;
	double d1_2 = 0;
	double a1 = gsl_vector_get(param, 0);
	double a2 = gsl_vector_get(param, 1);
	for (int i = 0; i < data->size1; ++i) {
		double n = gsl_matrix_get(data, i, 1);
		double b1 = gsl_matrix_get(data, i, 2);
		double b2 = gsl_matrix_get(data, i, 3);
		d1_1 += b1 * (n * pow(a1 * b1 + a2 * b2, -1) - 1);
		d1_2 += b2 * (n * pow(a1 * b1 + a2 * b2, -1) - 1);
	}
	gsl_vector_set(val, 0, d1_1);
	gsl_vector_set(val, 1, d1_2);
}

void d2(gsl_vector *param, gsl_matrix *data, gsl_matrix *val)
{
	double d2_1_1 = 0;
	double d2_1_2 = 0;  /* d2_2_1 == d2_1_2 */
	double d2_2_2 = 0;
	double a1 = gsl_vector_get(param, 0);
	double a2 = gsl_vector_get(param, 1);
	for (int i = 0; i < data->size1; ++i) {
		double n = gsl_matrix_get(data, i, 1);
		double b1 = gsl_matrix_get(data, i, 2);
		double b2 = gsl_matrix_get(data, i, 3);
		d2_1_1 += (-1) * pow(b1, 2) * n * pow(a1 * b1 + a2 * b2, -2);
		d2_1_2 += (-1) * b1 * b2 * n * pow(a1 * b1 + a2 * b2, -2);
		d2_2_2 += (-1) * pow(b2, 2) * n * pow(a1 * b1 + a2 * b2, -2);
	}
	gsl_matrix_set(val, 0, 0, d2_1_1);
	gsl_matrix_set(val, 0, 1, d2_1_2);
	gsl_matrix_set(val, 1, 0, d2_1_2);
	gsl_matrix_set(val, 1, 1, d2_2_2);
}

int main(int argc, char *argv[])
{
	gsl_matrix *data = ucs_ftodm(argv[1], true);
	gsl_vector *param = ucs_ftodv(argv[2], true);
	struct ucs_iter_result result = ucs_newton_fisher(
		param,
		10000,
		0.0001,
		0.0001,
		d1,
		d2,
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
