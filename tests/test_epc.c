#include <assert.h>
#include <stdio.h>
#include "epc.h"

int main(void) {
    assert(epc_version() == 1);
    printf("PASS\n");
    return 0;
}