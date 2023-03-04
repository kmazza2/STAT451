#include "ucs_ftodm.h"
#include <stdbool.h>
#include <stdlib.h>

int main(void)
{
	gsl_matrix *data = ucs_ftodm("data/small_mat.dat", true);
	if (
			(gsl_matrix_get(data,0,0) != -3) ||
			(gsl_matrix_get(data,0,1) != 4) ||
			(gsl_matrix_get(data,1,0) != 1) ||
			(gsl_matrix_get(data,1,1) != 9)
	) {
		return EXIT_FAILURE;
	}
	gsl_matrix_free(data);
	return EXIT_SUCCESS;
}
