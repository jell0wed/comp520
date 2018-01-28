all: mini.l mini.y
	bison -d mini.y
	flex mini.l
	gcc mini.tab.c lex.yy.c -o mini
clean:
	rm -rf lex.yy.c mini.tab.c mini.tab.h
