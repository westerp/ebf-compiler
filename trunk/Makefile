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
INTERPRENTER = bf
DESIGN = lamp-genie.txt

test: 	$(INTERPRENTER).test.tmp
	@echo "To make (perhaps new) binary, run make binary or better, make test-bin,  to create binary"

all: 	test test-bin

testall: test test-bin test-interprenters

test-interprenters:
	make test INTERPRENTER=bf
	make test INTERPRENTER=beef
	make test INTERPRENTER=bf1.pl

$(INTERPRENTER).test.tmp: ebft.bf tools/test.sh
	tools/test.sh $(INTERPRENTER) ebft.bf
	@touch $(INTERPRENTER).test.tmp

test-bin: $(INTERPRENTER).test-bin.tmp

$(INTERPRENTER).test-bin.tmp: ebf-bin.bf tools/test.sh
	tools/test.sh $(INTERPRENTER) ebf-bin.bf
	@touch $(INTERPRENTER).test-bin.tmp

compile: ebft.bf

ebft.bf: ebf.bf ebf.ebf
	$(INTERPRENTER) ebf.bf < ebf.ebf > ebft.tmp
	@perl -e 'while(<>){die("compilation failed: $$_") if( $$_=~ /ERROR/)}' ebft.tmp
	@mv ebft.tmp ebft.bf
	@diff -wu ebf.bf ebft.bf || true

ebf.bf: ebf-bin-bootstrap.bf
	$(INTERPRENTER) ebf-bin-bootstrap.bf < ebf.ebf > ebf.tmp
	@perl -e 'while(<>){die("compilation failed: $$_") if( $$_=~ /ERROR/)}' ebf.tmp
	@mv ebf.tmp ebf.bf

clean:
	rm -rf ebft.bf ebf.bf *.tmp  *~  ebf-compiler-* ebf-*.ebf ebf-bin-* ebf-handcompiled.bf

replace: ebft.bf test
	cp ebft.bf ebf.bf

binary: ebf-bin.bf

ebf-bin.bf: ebft.bf
	@cat ebft.bf | perl -pe 's/[^\Q[]<>-+,.\E]//g' > ebf-bin.tmp
	@tools/apply_code.pl ebf-bin.tmp object-design/$(DESIGN) > ebf-bin.bf
	@rm -f ebf-bin.tmp
	@cat ebf-bin.bf

release: version replace binary
	@rm -rf ebf-compiler-$(REV).tar.gz  bf-compiler-$(REV).zip ebf-compiler-$(REV)
	svn copy   $(SVNREPO)/trunk  $(SVNREPO)/tags/ebfv$(REV);
	svn export $(SVNREPO)/tags/ebfv$(REV) ebf-compiler-$(REV)
	cp ebf-bin.bf ebf-compiler-$(REV)
	zip -r ebf-compiler-$(REV).zip ebf-compiler-$(REV)
	tar -czf ebf-compiler-$(REV).tar.gz ebf-compiler-$(REV)

version:
	@if [ "$$REV" != "" -a "x`echo $$REV|sed 's/[\.0-9]//g'`" = "x" ]; then \
		echo "tag will be ebfv$$REV ($$REVN)";\
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
		echo "beef ebf-handcompiled.bf < ebf-1.1.0.ebf > ebf-bin-1.1.0.bf" && \
		beef ebf-handcompiled.bf < ebf-1.1.0.ebf > ebf-bin-1.1.0.bf && \
		perl -e 'while(<>){die("compilation failed: $$_") if( $$_=~ /ERROR/)}'  ebf-bin-1.1.0.bf && \
		echo $(INTERPRENTER) "ebf-bin-1.1.0.bf < ebf-1.2.0.ebf > ebf-1.2.0.bf" && \
		$(INTERPRENTER) ebf-bin-1.1.0.bf < ebf-1.2.0.ebf > ebf-bin-1.2.0.bf && \
		perl -e 'while(<>){die("compilation failed: $$_") if( $$_=~ /ERROR/)}' ebf-bin-1.2.0.bf && \
		cp  ebf-bin-1.2.0.bf ebf-bin-bootstrap.bf || false; \
	fi

help:
	@echo This source release does not have the means to bootstrap itself. The bootstrapper
	@echo actually tries to get previous versions of the compiler source from tags in the svn repository.
	@echo
	@echo The compile chain done is the reverse of this dependency tree:
	@echo 1. ebf.ebf in this release requires binary from ebf-1.2.0 or newer
	@echo 2. ebf-1.2.0 requires binary from ebf-1.1.0 or newer
	@echo 3. ebf-1.1.0 requires binary from any previous version of ebf. It will work with the first hand.compiled version.
	@echo
	@echo "All packed releases has a binary from it's own version and the bootstrap resolver will use that if it exists."
	@echo
	@echo Happy compiling
	@echo Sylwester

.PHONY: clean version test-interprenters help

