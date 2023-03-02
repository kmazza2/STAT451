CC = clang
CFLAGS = -O3 -Wall
LIBCSV = /Users/kevin/lib/libcsv
GSL = /Users/kevin/lib/gsl
LIBCSV_FLAGS = -lcsv
INCLUDE = include
GSL_FLAGS = -lgsl -lgslcblas -lm
all: main tests
main: ucs_readfile
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/main.o src/main.c
	$(CC) -L$(GSL)/lib -o bin/main obj/main.o obj/ucs_readfile.o $(GSL_FLAGS)
ucs_readfile:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_readfile.o src/ucs_readfile.c
tests: $(patsubst %.c, %.test, $(wildcard tests/*.c))
%.test : %.c Makefile
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -L$(GSL)/lib $< obj/ucs_readfile.o -o $@ $(GSL_FLAGS)
check:
	@./test.sh
run:
	@bin/main
clean:
	rm tests/*.test
	rm bin/*
	rm obj/*
