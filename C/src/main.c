#include <stdio.h>
#include <stdlib.h>
#include "csvinfo.h"
int main(void) {
	struct counts dc = data_counts("data/oilspills.dat");
	printf("%lu\n", dc.fields);
	printf("%lu\n", dc.rows);
	return EXIT_SUCCESS;
}
