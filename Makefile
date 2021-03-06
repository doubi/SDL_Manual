PERL = perl

ifeq "$(PAPER)" ""
	PAPER = $(shell paperconf)
endif

ifneq "$(TEST)" ""
	BOOK = build/test.$(PAPER)
	CHAPTERS = $(wildcard test/*.pod)
else
	BOOK = build/SDL_Manual.$(PAPER)
	CHAPTERS = \
    src/00-preface.pod \
    src/01-first.pod \
    src/02-drawing.pod \
    src/03-events.pod \
    src/04-game.pod \
    src/05-pong.pod 
endif

default: prepare pdf clean

prepare: clean
	mkdir build

html: prepare $(CHAPTERS) bin/book-to-html
	$(PERL) bin/book-to-html $(CHAPTERS) > $(BOOK).html

pdf: tex lib/Makefile
	#cp src/mmd-table.svg build/mmd-table.svg
	cd build && make -I ../lib -f ../lib/Makefile 

tex: prepare $(CHAPTERS) lib/SDLManualLatex.pm lib/book.sty bin/book-to-latex
	$(PERL) -Ilib bin/book-to-latex --paper $(PAPER) $(CHAPTERS) > $(BOOK).tex

release: pdf
	cp $(BOOK).pdf build/book-$$(date +"%Y-%m").$(PAPER).pdf

clean: 
	rm -rf build/

.PHONY: clean

# vim: set noexpandtab
