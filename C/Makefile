CC = clang
CFLAGS = -O3 -Wall
LIBCSV = /Users/kevin/lib/libcsv
LIBGSL = /Users/kevin/lib/gsl
LIBCSV_FLAGS = -lcsv
INCLUDE = include
GSL_FLAGS = -lgsl -lgslcblas -lm
all: main csvinfo tests
main: csvinfo
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(LIBGSL)/include -c -o src/main.o src/main.c
	$(CC) -L$(LIBCSV)/lib -L$(LIBGSL)/lib -o bin/main src/csvinfo.o src/main.o $(LIBCSV_FLAGS) $(GSL_FLAGS)
csvinfo:
	$(CC) $(CFLAGS) -I$(LIBCSV)/include -I$(INCLUDE) -c -o src/csvinfo.o src/csvinfo.c
tests: $(patsubst %.c, %.test, $(wildcard tests/*.c))
%.test : %.c Makefile
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(LIBCSV)/include -L$(LIBCSV)/lib $< src/csvinfo.o -o $@ $(LIBCSV_FLAGS)
check:
	@tests/test.sh
run:
	@bin/main
clean:
	rm tests/*.test
	rm bin/*
	rm src/*.o
