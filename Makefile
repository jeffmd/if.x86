# Makefile
INCS = *.S

all: if

if :  main.o input.o
	gcc -Os -ldl -o $@ $+

if.o : $(INCS)
	as -o $@ $<

lst:
	objdump -h -x -D -S if > lst.txt

clean:
	rm -vf if *.o
