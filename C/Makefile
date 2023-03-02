CC = clang
CFLAGS = -O3 -Wall
GSL = /Users/kevin/lib/gsl
INCLUDE = include
GSL_FLAGS = -lgsl -lgslcblas -lm
all: main tests
main: ucs_ftodm ucs_ftodv
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/main.o src/main.c
	$(CC) -L$(GSL)/lib -o bin/main obj/main.o obj/ucs_ftodm.o $(GSL_FLAGS)
ucs_ftodm:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_ftodm.o src/ucs_ftodm.c
ucs_ftodv:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_ftodv.o src/ucs_ftodv.c
tests: $(patsubst %.c, %.test, $(wildcard tests/*.c))
%.test : %.c Makefile
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -L$(GSL)/lib $< obj/ucs_ftodm.o obj/ucs_ftodv.o -o $@ $(GSL_FLAGS)
check:
	@./test.sh
run:
	@bin/main
clean:
	rm tests/*.test
	rm bin/*
	rm obj/*
