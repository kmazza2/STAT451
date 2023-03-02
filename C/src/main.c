#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "ucs_readfile.h"
#include <gsl/gsl_matrix.h>
int main(void) {
	gsl_matrix *data = ucs_readfile("data/oilspills.dat", true);
	gsl_matrix_fprintf(stdout, data, "%f");
	gsl_matrix_free(data);
	return EXIT_SUCCESS;
}