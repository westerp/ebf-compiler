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

INTERPRETER = ../tools/jitbf
INTERPRETER_FLAGS =
EBF = ../ebft.bf
EBF_ERROR=../tools/ebf_error.pl

all: helloworld.bf quine.bf quine2.bf binary-quine.bf quine-generator.bf utf.bf cat.bf

.SUFFIXES:
.SUFFIXES: .bf .ebf

.ebf.bf :
	cat $< | $(INTERPRETER) ${INTERPRETER_FLAGS} $(EBF) | tee  $*.tmp  && \
	${EBF_ERROR} $*.tmp && \
	mv $*.tmp $*.bf

binary-quine.bf:
	cat binary-quine.ebf | $(INTERPRETER) ${INTERPRETER_FLAGS} ${EBF} | tee  binary-quine.tmp  && \
	${EBF_ERROR}  binary-quine.tmp && \
	perl -e 'undef $$/;$$orig_code=$$_=<>;s/[^\Q+-<>[].\E]//g;$$_=substr($$_,5);%h=("+"=>0,">"=>1,"<"=>2,"["=>3,"]"=>4,"-"=>5,"."=>6,","=>7);$$quinetxt = ""; foreach $$i (reverse split//){ $$quinetxt .= "" . ("+" x $$h{$$i}) . ">" }$$orig_code =~ s/PLACEHOLDER/$$quinetxt/;print $$orig_code' binary-quine.tmp  > binary-quine.tmp2 && \
	rm binary-quine.tmp && \
	mv binary-quine.tmp2 binary-quine.bf

