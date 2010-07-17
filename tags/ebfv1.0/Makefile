
SVNREPO = https://ebf-compiler.googlecode.com/svn
INTERPRENTER = beef


test: compile
	./test.sh

compile: ebft.bf

ebft.bf: ebf.bf
	$(INTERPRENTER) ebf.bf < ebf.ebf > ebft.bf
	diff -wu ebf.bf ebft.bf


ebf.bf:
	$(INTERPRENTER) ebf-handcompiled.bf < ebf.ebf > ebf.bf

clean:
	rm ebft.bf ebf.bf

replace: ebft.bf
	cp ebft.bf ebf.bf


release:
	#REV=rel_`date +%y%m%d`;				     \
	svn copy   $(SVNREPO)/trunk  $(SVNREPO)/tags/$$REV;
