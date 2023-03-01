#include <stdio.h>
#include <stdlib.h>
#include "csvinfo.h"
#include <gsl/gsl_block.h>
int main(void) {
	struct counts dc = data_counts("data/oilspills.dat");
	printf("%lu\n", dc.fields);
	printf("%lu\n", dc.rows);
	gsl_block *raw_dat = gsl_block_alloc(dc.fields);
	gsl_block_free(raw_dat);
	return EXIT_SUCCESS;
}
