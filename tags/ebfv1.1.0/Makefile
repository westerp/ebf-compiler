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
INTERPRENTER = beef
DESIGN = structure-cloud.txt

all: 	test test-bin

test: 	test.tmp

test.tmp: ebft.bf
	tools/test.sh $(INTERPRENTER) ebft.bf
	@touch test.tmp

test-bin: test-bin.tmp

test-bin.tmp: ebf-bin.bf
	tools/test.sh $(INTERPRENTER) ebf-bin.bf
	@touch test-bin.tmp

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
	rm -f ebft.bf ebf.bf *.tmp  *~ ebf-bin-bootstrap.bf

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
	elif [ -r ebf-handcompiled.bf ]; then \
		echo "Using handcompiled (v1.0) binary to bootstrap"; \
		cp ebf-handcompiled.bf ebf-bin-bootstrap.bf;  \
	else \
		echo "No way to bootstrap. need ebf-bin.bf or ebf-handcompiled.bf"; \
		false ; \
	fi

.PHONY: clean version

