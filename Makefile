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
INTERPRETER = tools/jitbf
INTERPRETER_FLAGS =
BOOTSTRAP_FLAGS = --eof 0 -b 32
EBF = ebf.bf
JITBF = tools/jitbf
CC = gcc -O2
DESIGN = genie4.txt
LOADING = loading.txt
PREFIX = /usr/bin
VERSION := $(shell git describe --always --tags --abbrev=4 --dirty)

test: 	$(INTERPRETER).test.tmp
	@echo "To make (perhaps new) binary, run make binary or better, make test-bin,  to create binary"

all: 	test test-bin examples

install: ebf tools/ebf_error.pl $(JITBF)
	@if [ -w $(PREFIX) ]; then\
		echo cp ebf tools/ebf_error.pl $(JITBF) $(PREFIX);\
		cp ebf tools/ebf_error.pl $(JITBF) $(PREFIX);\
	else\
		echo "No rights to install in $(PREFIX). Please use make install-local to install in ~/bin or set PREFIX=<your directory>" ;\
		false;\
	fi

install-local:
	make install PREFIX=~/bin

testall: test test-bin test-interprenters

test-interpreters:
	make test INTERPRETER=bf INTERPRETER_FLAGS=
	make test INTERPRETER=beef INTERPRETER_FLAGS=
	make test INTERPRETER=bf1.pl INTERPRETER_FLAGS=

$(INTERPRETER).test.tmp: ebft.bf tools/test.sh
	tools/test.sh "$(INTERPRETER) ${INTERPRETER_FLAGS}" ebft.bf
	@touch $(INTERPRETER).test.tmp

test-bin: $(INTERPRETER).test-bin.tmp

$(INTERPRETER).test-bin.tmp: ebf-bin.bf tools/test.sh
	tools/test.sh "$(INTERPRETER) ${INTERPRETER_FLAGS}" ebf-bin.bf
	tools/test.sh "$(INTERPRETER) -b 8" ebf-bin.bf
	tools/test.sh "$(JITBF) --perl" ebf-bin.bf
	tools/test.sh bf ebf-bin.bf
	tools/test.sh beef ebf-bin.bf
	@touch $(INTERPRETER).test-bin.tmp

ebft: ebft.bf

ebft.bf: $(EBF) ebf.ebf
	cat ebf.ebf | sed 's/VERSION/$(VERSION)/' | $(INTERPRETER) ${INTERPRETER_FLAGS} $(EBF) | tee  ebft.tmp | tools/apply_code.pl object-design/$(LOADING) && \
	tools/ebf_error.pl ebft.tmp && \
	mv ebft.tmp ebft.bf && ( diff -wu ebf.bf ebft.bf || true ) 

fast: ebf.bf ebf.ebf
	tools/strip_ebf.pl ebf.ebf -c | sed 's/VERSION/$(VERSION)/' | $(INTERPRETER) ${INTERPRETER_FLAGS} ebf.bf | tee  ebft.tmp | tools/apply_code.pl object-design/$(LOADING) && \
	tools/ebf_error.pl ebft.tmp && \
	mv ebft.tmp ebft.bf 


ebf    : ebf.bf
	$(JITBF) --description "EBF compiler $(VERSION) - A Extended brainfuck to brainfuck compiler" --fuzzy -p -b 8 ebf.bf > ebf.c
	$(CC) ebf.c -o ebf

ebf.bf: ebf-bin-bootstrap.bf
	cat ebf.ebf | sed 's/VERSION/$(VERSION)/' | $(INTERPRETER) $(BOOTSTRAP_FLAGS) ebf-bin-bootstrap.bf | tee  ebf.tmp | tools/apply_code.pl object-design/$(LOADING) && \
	tools/ebf_error.pl ebf.tmp && \
	mv ebf.tmp ebf.bf || false

clean:
	rm -rf ebf ebf.c ebft.bf ebf.bf *.tmp  examples/*.bf tools/*.tmp *~  ebf-compiler-* ebf-*.ebf ebf-bin-* ebf-handcompiled.bf*

replace: ebft.bf test
	mv ebf.bf ebf-old.bf
	cp ebft.bf ebf.bf

binary: ebf-bin.bf

ebf-bin.bf: design ebft.bf
	@cat ebft.bf | tools/apply_code.pl design.tmp | tee ebf-bin.bf

design: 
	cat object-design/$(DESIGN) | sed 's/VERSION/$(VERSION)/' > design.tmp

examples: ebft.bf
	cd examples && \
	make

release: version cleanrelease binary ebf
	@rm -rf ebf-compiler-$(VERSION) ebf-compiler-$(VERSION).tar.gz  bf-compiler-$(VERSION).zip bf-compiler-$(VERSION).bf
	mkdir ebf-compiler-$(VERSION)
	cp ebf-bin.bf ebf-compiler-$(VERSION)/ebf.bf
	cp COPYING ebf tools/ebf-kate.xml tools/jitbf ebf-compiler-$(VERSION)
	cp docs/binary.md ebf-compiler-$(VERSION)/readme.md
	zip -r ebf-compiler-$(VERSION).zip ebf-compiler-$(VERSION)
	tar -czf ebf-compiler-$(VERSION).tar.gz ebf-compiler-$(VERSION)
	cp ebf-bin.bf bf-compiler-$(VERSION).bf


cleanrelease: ebft.bf
	if [ "$(shell echo "?" | $(INTERPRETER) ${INTERPRETER_FLAGS} $(EBF) | cut -d ' ' -f 2)" != "$(VERSION)" ]; then \
            echo "Version of ebft.bf is not $(VERSION). Need to build it again";\
            rm ebft.bf;\
            false;\
        else \
            echo "Version of ebft.bf is same as tag $(VERSION)";\
        fi

version:
	@if [ "$(VERSION)" != "" -a "x`echo $(VERSION)|sed 's/[v\.0-9]//g'`" = "x" ]; then \
		echo "Version EBF $(VERSION) is clean";\
		true;\
	else \
		echo "Version $(VERSION) is invalid. You need to tag a version eg 'git tag v2.0.0' before running this."; \
		false; \
	fi

ebf-bin-bootstrap.bf:
	@if [ -r ebf-bin.bf ]; then \
		echo "Using precompiled binary ebf-bin.bf to bootstrap"; \
		cp ebf-bin.bf ebf-bin-bootstrap.bf; \
	else \
		echo "Need extra files to bootstrap. please run make help if this goes wrong" && \
		echo "Checking out the only binary version of ebf (ebf-handcompiled.bf) from the ebfv1.1.0 tag" &&\
		git show tags/ebfv1.0:ebf-handcompiled.bf > ebf-handcompiled.bf && \
		echo "Checking out version ebfv1.1.0 to compile it with the very first handcompiled version"&& \
		git show tags/ebfv1.1.0:ebf.ebf > ebf-1.1.0.ebf && \
		echo "Checking out version ebfv1.2.0 to compile it with v1.1.0" && \
		git show tags/ebfv1.2.0:ebf.ebf > ebf-1.2.0.ebf && \
		echo "Checking out version ebfv1.3.0 to compile it with v1.2.0" && \
		git show tags/ebfv1.3.0:ebf.ebf > ebf-1.3.0.ebf && \
		echo "Checking out version ebfv1.3.2 to compile it with v1.3.0" && \
		git show tags/ebfv1.3.2:ebf.ebf > ebf-1.3.2.ebf && \
		echo "Checking out version ebfv1.3.4 to compile it with v1.3.2" && \
		git show tags/ebfv1.3.4:ebf.ebf > ebf-1.3.4.ebf && \
		echo "Checking out version ebfv1.4.0 to compile it with v1.3.4" && \
		git show tags/ebfv1.4.0:ebf.ebf > ebf-1.4.0.ebf && \
		echo "tools/strip_ebf.pl ebf-1.1.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-handcompiled.bf > ebf-bin-1.1.0.bf" && \
		tools/strip_ebf.pl ebf-1.1.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-handcompiled.bf > ebf-bin-1.1.0.bf && \
		tools/ebf_error.pl ebf-bin-1.1.0.bf && \
		echo "tools/strip_ebf.pl ebf-1.2.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.1.0.bf > ebf-bin-1.2.0.bf" && \
		tools/strip_ebf.pl ebf-1.2.0.ebf | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.1.0.bf > ebf-bin-1.2.0.bf && \
		tools/ebf_error.pl ebf-bin-1.2.0.bf && \
		echo "tools/strip_ebf.pl ebf-1.3.0.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.2.0.bf > ebf-bin-1.3.0.bf" && \
		tools/strip_ebf.pl ebf-1.3.0.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.2.0.bf > ebf-bin-1.3.0.bf && \
		tools/ebf_error.pl ebf-bin-1.3.0.bf && \
		echo "tools/strip_ebf.pl ebf-1.3.2.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.3.0.bf > ebf-bin-1.3.2.bf" && \
		tools/strip_ebf.pl ebf-1.3.2.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.3.0.bf > ebf-bin-1.3.2.bf && \
		tools/ebf_error.pl ebf-bin-1.3.2.bf && \
		echo "tools/strip_ebf.pl ebf-1.3.4.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.3.2.bf > ebf-bin-1.3.4.bf" && \
		tools/strip_ebf.pl ebf-1.3.4.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.3.2.bf > ebf-bin-1.3.4.bf && \
		tools/ebf_error.pl ebf-bin-1.3.2.bf && \
		echo "tools/strip_ebf.pl ebf-1.4.0.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.3.4.bf | tee  ebf-bin-1.4.0.bf | tools/apply_code.pl object-design/$(LOADING)" && \
		tools/strip_ebf.pl ebf-1.4.0.ebf  | $(JITBF) $(BOOTSTRAP_FLAGS) ebf-bin-1.3.4.bf | tee  ebf-bin-1.4.0.bf | tools/apply_code.pl object-design/$(LOADING) && \
		tools/ebf_error.pl ebf-bin-1.4.0.bf && \
		cp  ebf-bin-1.4.0.bf ebf-bin-bootstrap.bf && cp ebf-bin-1.4.0.bf ebf.bf || false; \
	fi

help:
	@echo This source release does not have the means to bootstrap itself. The bootstrapper
	@echo actually tries to get previous versions of the compiler source from tags in the git repository.
	@echo
	@echo The compile chain done is the reverse of this dependency tree:
	@echo 1. ebf.ebf in this release requires binary from ebf-1.4.0 or newer
	@echo 2. ebf-1.4.0 requires binary from ebf-1.3.4 or newer
	@echo 2. ebf-1.3.4 requires binary from ebf-1.3.2 or newer
	@echo 3. ebf-1.3.2 requires binary from ebf-1.3.0 or newer
	@echo 4. ebf-1.3.0 requires binary from ebf-1.2.0 or newer
	@echo 5. ebf-1.2.0 requires binary from ebf-1.1.0 or newer
	@echo 6. ebf-1.1.0 requires binary from any previous version of ebf. It will work with the first hand.compiled version.. 
	@echo
	@echo "All packed releases has a binary from it's own version and the bootstrap resolver will use that if it exists."
	@echo
	@echo Happy compiling
	@echo Sylwester

.PHONY: clean version cleanrelease test-interprenters help design

