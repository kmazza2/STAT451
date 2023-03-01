#include <stdio.h>
#include <stdlib.h>
#include "csvinfo.h"
int main(void) {
	struct counts data_dim = data_shape("data/oilspills.dat");
	printf("%lu\n", data_dim.fields);
	printf("%lu\n", data_dim.rows);
	printf("Success?\n");
	return EXIT_SUCCESS;
}
