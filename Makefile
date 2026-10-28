CC_HOST   = clang
CC_ARM    = arm-none-eabi-gcc
ARM_FLAGS = -mcpu=cortex-m4 -mthumb -Os
FLASH_BUDGET = 16384

.PHONY: all test arm size-check clean

all: test arm

build:
	mkdir -p build

test: build
	$(CC_HOST) -Isrc src/epc.c tests/test_epc.c -o build/test_host && ./build/test_host

arm: build
	$(CC_ARM) $(ARM_FLAGS) -c src/epc.c -o build/epc_arm.o

size-check: arm
	@SIZE=$$(arm-none-eabi-size build/epc_arm.o | awk 'NR==2 {print $$1+$$2}'); \
	echo "Flash used: $$SIZE / $(FLASH_BUDGET) bytes"; \
	if [ $$SIZE -gt $(FLASH_BUDGET) ]; then echo "FAIL: over budget"; exit 1; fi

clean:
	rm -rf build