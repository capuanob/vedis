#include <stdint.h> //uint8_t
#include <stdbool.h> //booleans
#include <stdlib.h> //exit
#include <string.h> //memcpy

#include "vedis.h"

vedis *pStore; /* Datastore handle */
bool initialized = false;

void initialize_library() {
	int rc;
	rc = vedis_open(&pStore, ":mem:");

	if (rc != VEDIS_OK)
		exit(1);

	initialized = true;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
	if (!initialized) initialize_library();
	
	// Create a non-const copy of the fuzzer data
	char buf[size];
	memcpy(buf, data, size); 
	buf[size - 1] = '\0';

	size_t idx = 0;
	while (idx < size) {
		vedis_exec(pStore, buf + idx, -1);
		idx += 1 + strlen(buf + idx);
	}
	return 0;
}
