#testsrc := $(wildcard tests/*.c)
#make test: tests/%.o
#	echo "hi"
#tests/%.o: tests/%.c
#	$(CC) $(CFLAGS) $(INCLUDES) -c $(input) -o $(output)
#make check: $(testsrc)
#	@echo ${testsrc}

CC = clang
CFLAGS = -O2 -Wall
all: main tests
main:
	$(CC) $(CFLAGS) -o bin/main src/main.c
tests: $(patsubst %.c, %.test, $(wildcard tests/*.c))
%.test : %.c Makefile
	$(CC) $(CFLAGS) $< -o $@
check:
	@tests/test.sh
run:
	@bin/main
clean:
	rm tests/*.test
	rm bin/*
