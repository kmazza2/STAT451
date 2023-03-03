#include "ucs_newton_fisher.h"
#include "sample/newton_fisher_dummy.h"

int main(void) {
	int err = ucs_newton_fisher(
		gsl_vector_alloc(0),
		1000,
		0.0001,
		0.0001,
		d1,
		d2,
		"data/A1.dat"
	);
	if (err == 0) {
		return EXIT_SUCCESS;
	} else {
		return EXIT_FAILURE;
	}
}
