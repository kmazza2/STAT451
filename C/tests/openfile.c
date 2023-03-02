#include "ucs_readfile.h"
#include <stdbool.h>
#include <stdlib.h>

int main(void) {
	gsl_matrix *data = ucs_readfile("data/items.dat", true);
	return EXIT_SUCCESS;
}
