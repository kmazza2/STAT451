#include "ucs_ftodv.h"
#include <stdbool.h>
#include <stdlib.h>

int main(void)
{
	gsl_vector *data = ucs_ftodv("data/b1.dat", false);
	if (
		(gsl_vector_get(data,0) != 4) ||
		(gsl_vector_get(data,1) != 1)
	) {
		return EXIT_FAILURE;
	}
	gsl_vector_free(data);
	return EXIT_SUCCESS;
}
