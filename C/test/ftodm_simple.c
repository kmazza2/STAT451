#include "ucs_ftodm.h"
#include <stdbool.h>
#include <stdlib.h>

int main(void)
{
	gsl_matrix *data = ucs_ftodm("data/items.dat", true);
	gsl_matrix_free(data);
	return EXIT_SUCCESS;
}
