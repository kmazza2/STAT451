#testsrc := $(wildcard tests/*.c)
#make test: tests/%.o
#	echo "hi"
#tests/%.o: tests/%.c
#	$(CC) $(CFLAGS) $(INCLUDES) -c $(input) -o $(output)
#make check: $(testsrc)
#	@echo ${testsrc}

CC = clang
CFLAGS = -O2 -Wall
all: $(patsubst %.c, %.test, $(wildcard tests/*.c))
%.test : %.c Makefile
	$(CC) $(CFLAGS) $< -o $@
check:
	@./test.sh
clean:
	rm tests/*.test
