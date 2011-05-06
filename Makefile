#
# $Id$
#
# This file is part of ebf-compiler
#
# ebf-compiler is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ebf-compiler is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License

SVNREPO = https://ebf-compiler.googlecode.com/svn
INTERPRETER = tools/jitbf8
INTREPRETER_FLAGS =
BOOTSTRAP_FLAGS = --eof 0
JITBF = tools/jitbf
CC = gcc -O2
DESIGN = bunny.txt
LOADING = loading.txt

test: 	$(INTERPRETER).test.tmp
	@echo "To make (perhaps new) binary, run make binary or better, make test-bin,  to create binary"

all: 	test test-bin

testall: test test-bin test-interprenters

test-interpreters:
	make test INTERPRETER=bf INTREPRETER_FLAGS=
	make test INTERPRETER=beef INTREPRETER_FLAGS=
	make test INTERPRETER=bf1.pl INTREPRETER_FLAGS=

$(INTERPRETER).test.tmp: ebft.bf tools/test.sh
	tools/test.sh "$(INTERPRETER) ${INTREPRETER_FLAGS}" ebft.bf
	@touch $(INTERPRETER).test.tmp

test-bin: $(INTERPRETER).test-bin.tmp

$(INTERPRETER).test-bin.tmp: ebf-bin.bf tools/test.sh
	tools/test.sh "$(INTERPRETER) ${INTREPRETER_FLAGS}" ebf-bin.bf
	tools/test.sh "$(INTERPRETER)" ebf-bin.bf
	tools/test.sh "$(JITBF) --perl" ebf-bin.bf
	tools/test.sh bf ebf-bin.bf
	tools/test.sh beef ebf-bin.bf
	@touch $(INTERPRETER).test-bin.tmp

compile: ebft.bf

ebft.bf: ebf.bf ebf.ebf
	$(INTERPRETER) ${INTREPRETER_FLAGS} ebf.bf < ebf.ebf | tee  ebft.tmp | tools/apply_code.pl object-design/$(LOADING)
	@perl -e 'while(<>){die("compilation failed: $$_") if( $$_=~ /ERROR/)}' ebft.tmp
	@mv ebft.tmp ebft.bf
	@diff -wu ebf.bf ebft.bf || true

ebf    : ebf.bf
	$(JITBF) --fuzzy -p ebf.bf > ebf.c
	$(CC) ebf.c -o ebf

ebf.bf: ebf-bin-bootstrap.bf
	$(INTERPRETER) ebf-bin-bootstrap.bf < ebf.ebf | tee  ebf.tmp | tools/apply_code.pl object-design/$(LOADING)
	@perl -e 'while(<>){die("compilation failed: $$_") if( $$_=~ /ERROR/)}' ebf.tmp
	@mv ebf.tmp ebf.bf

clean:
	rm -rf ebf ebf.c ebft.bf ebf.bf *.tmp  tools/*.tmp *~  ebf-compiler-* ebf-*.ebf ebf-bin-* ebf-handcompiled.bf

replace: ebft.bf test
	cp ebft.bf ebf.bf

binary: ebf-bin.bf

ebf-bin.bf: ebft.bf
	@cat ebft.bf | tools/apply_code.pl object-design/$(DESIGN) > ebf-bin.bf
	@rm -f ebf-bin.tmp
	@cat ebf-bin.bf

release: version replace binary
	@rm -rf ebf-compiler-$(REV).tar.gz  bf-compiler-$(REV).zip ebf-compiler-$(REV)
	svn copy  -m "tagged release ebfv$$REV" $(SVNREPO)/trunk  $(SVNREPO)/tags/ebfv$(REV);
	svn export $(SVNREPO)/tags/ebfv$(REV) ebf-compiler-$(REV)
	cp ebf-bin.bf ebf-compiler-$(REV)
	zip -r ebf-compiler-$(REV).zip ebf-compiler-$(REV)
	tar -czf ebf-compiler-$(REV).tar.gz ebf-compiler-$(REV)

version:
	@if [ "$$REV" != "" -a "x`echo $$REV|sed 's/[\.0-9]//g'`" = "x" ]; then \
		echo "tag will be ebfv$$REV ($$REV)";\
		true;\
	else \
		echo "REV=$$REV is invalid. You need to pass release REV=<revision> where revision is numbers separated by ."; \
		false; \
	fi

ebf-bin-bootstrap.bf:
	@if [ -r ebf-bin.bf ]; then \
		echo "Using precompiled binary ebf-bin.bf to bootstrap"; \
		cp ebf-bin.bf ebf-bin-bootstrap.bf; \
	else \
		echo "Need extra files to bootstrap. please run make help if this goes wrong" && \
		echo "Downloading very first binary version of ebf (ebf-handcompiled.bf)" &&\
		wget -nv 'http://ebf-compiler.googlecode.com/svn/tags/ebfv1.0/ebf-handcompiled.bf' && \
		echo "Downloading previous source ebfv1.1.0 to compile it with the very first handcompiled version"&& \
		wget -nv 'http://ebf-compiler.googlecode.com/svn/tags/ebfv1.1.0/ebf.ebf' -O ebf-1.1.0.ebf && \
		echo "Downloading previous source ebfv1.2.0 to compile it with v1.1.0" && \
		wget -nv 'http://ebf-compiler.googlecode.com/svn/tags/ebfv1.2.0/ebf.ebf' -O ebf-1.2.0.ebf && \
		echo "Downloading previous source ebfv1.3.0 to compile it with v1.2.0" && \
		wget -nv 'http://ebf-compiler.googlecode.com/svn/tags/ebfv1.3.0/ebf.ebf' -O ebf-1.3.0.ebf && \
		echo "tools/pure_ebf.pl ebf-1.1.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-handcompiled.bf > ebf-bin-1.1.0.bf" && \
		tools/pure_ebf.pl ebf-1.1.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-handcompiled.bf > ebf-bin-1.1.0.bf && \
		tools/ebf_error.pl ebf-bin-1.1.0.bf && \
		echo "tools/pure_ebf.pl ebf-1.2.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.1.0.bf > ebf-bin-1.2.0.bf" && \
		tools/pure_ebf.pl ebf-1.2.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.1.0.bf > ebf-bin-1.2.0.bf && \
		tools/ebf_error.pl ebf-bin-1.2.0.bf && \
		echo "tools/pure_ebf.pl ebf-1.3.0.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.2.0.bf > ebf-bin-1.3.0.bf" && \
		tools/pure_ebf.pl ebf-1.3.0.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.2.0.bf > ebf-bin-1.3.0.bf && \
		tools/ebf_error.pl ebf-bin-1.3.0.bf && \
		cp  ebf-bin-1.3.0.bf ebf-bin-bootstrap.bf || false; \
	fi

help:
	@echo This source release does not have the means to bootstrap itself. The bootstrapper
	@echo actually tries to get previous versions of the compiler source from tags in the svn repository.
	@echo
	@echo The compile chain done is the reverse of this dependency tree:
	@echo 1. ebf.ebf in this release requires binary from ebf-1.3.0 or newer
	@echo 2. ebf-1.3.0 requires binary from ebf-1.2.0 or newer (we use 1.2.2 because of performance gain)
	@echo 3. ebf-1.2.0 requires binary from ebf-1.1.0 or newer
	@echo 4. ebf-1.1.0 requires binary from any previous version of ebf. It will work with the first hand.compiled version.. 
	@echo
	@echo "All packed releases has a binary from it's own version and the bootstrap resolver will use that if it exists."
	@echo
	@echo Happy compiling
	@echo Sylwester

.PHONY: clean version test-interprenters help

