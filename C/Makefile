CC = clang
CFLAGS = -O3 -Wall
LIBCSV = /Users/kevin/lib/libcsv
LIBGSL = /Users/kevin/lib/gsl
LIBCSV_FLAGS = -lcsv
GSL_FLAGS = -lgsl -lgslblas -lm
all: main tests
main:
	$(CC) $(CFLAGS) -I$(LIBCSV)/include -c -o src/csvinfo.o src/csvinfo.c
	$(CC) -L$(LIBCSV)/lib -o bin/csvinfo src/csvinfo.o $(LIBCSV_FLAGS)
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
	rm src/*.o
