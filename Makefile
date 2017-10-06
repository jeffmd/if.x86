# Makefile
INCS = *.S

all: if

if :  main.o input.o if.o
	gcc -O2 -ldl -o $@ $+

if.o : if.S $(INCS)
	as -o $@ $<

lst:
	objdump -h -x -D -S if > lst.txt

clean:
	rm -vf if *.o
