CFLAGS = -O3 -Wall
GSL = /Users/kevin/lib/gsl
INCLUDE = include
GSL_FLAGS = -lgsl -lgslcblas -lm
all: p1_newton test
p1_newton: ucs_ftodm ucs_ftodv ucs_solve ucs_newton_fisher
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/p1_newton.o src/p1_newton.c
	$(CC) -L$(GSL)/lib -o bin/p1_newton obj/p1_newton.o obj/ucs_ftodm.o obj/ucs_ftodv.o obj/ucs_solve.o obj/ucs_newton_fisher.o $(GSL_FLAGS)
ucs_ftodm:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_ftodm.o src/ucs_ftodm.c
ucs_ftodv:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_ftodv.o src/ucs_ftodv.c
ucs_solve:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_solve.o src/ucs_solve.c
ucs_newton_fisher:
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -c -o obj/ucs_newton_fisher.o src/ucs_newton_fisher.c
test: $(patsubst %.c, %.test, $(wildcard test/*.c))
%.test : %.c Makefile
	$(CC) $(CFLAGS) -I$(INCLUDE) -I$(GSL)/include -L$(GSL)/lib $< obj/ucs_ftodm.o obj/ucs_ftodv.o obj/ucs_solve.o obj/ucs_newton_fisher.o -o $@ $(GSL_FLAGS)
check:
	@tool/test.sh
run:
	@bin/p1_newton data/oilspills.dat data/oilspillsparam.dat
clean:
	rm test/*.test
	rm bin/*
	rm obj/*
