#include "csvinfo.h"
#include <stdlib.h>

int main(void) {
	struct counts dc = data_counts("../data/oilspills.dat");
	if (dc.fields == 108 && dc.rows == 27) {
		return EXIT_SUCCESS;
	} else {
		return EXIT_FAILURE;
	}
}
