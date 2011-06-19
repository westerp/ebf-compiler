#!/bin/bash

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


INTERPRENTER="bf"
EBF=ebft.bf
if [ "$1" != "" -a "$1" != "$INTERPRENTER" ]; then
	INTERPRENTER="$1"
	echo "Using $INTERPRENTER as interprenter"
fi
if [ "$2" != "" -a "$2" != $EBF ]; then
        EBF=$2
        echo "Using $EBF as ebf-binary"
fi

dir=$(dirname $0)
if [ "$dir" = "" ]; then
	dir="."
fi
ok=0
nok=0
tests=0
todos=0
NAME=#TEST
for i in $(grep -A9999 "${NAME}NAME" $0);  do
    test1=$(echo $i| cut -d\; -f1)
    if [ "$test1" != "${NAME}NAME" ]; then
        exp=$(echo $i| cut -d\; -f2)
        desc=$(echo $i| cut -d\; -f3| sed 's/\-/ /g')
        todo=$(echo $i| cut -d\; -f4)
        tests=$[$tests+1]
        echo -en "\r                                                                                                       \r"
        echo -en "test $tests: $desc"
        ret=$(echo -n "$test1" | $INTERPRENTER  $EBF)
        if [ "$ret" != "$exp" ]; then
                if [ "$todo" = "todo"  -o "$todo" = "warn" ]; then
                    echo " warning: \"$ret\" != proof \"$exp\""
                    todos=$[$todos+1]
                else
                    echo " ERROR: \"$ret\" != proof \"$exp\""
                    nok=$[$nok+1]
                fi
        else
                ok=$[$ok+1]
                if [ "$todo" = "todo" ]; then
                    echo "REMOVE todo"
                fi
        fi
    fi
done
echo -e "\r                                                                             "
echo "we had $tests tests"
echo "$ok successful tests"
echo "$todos known limitations"
echo "$nok errors"
exit $nok

#TESTNAME;TEST;INPUT;EXPECTEDOUTPUT
:a;:a=KF;allcation
>:a$a;>:a=KF$a<;pointer1
:a:b$b<$b;:a=KF:b=KE$b><$b>;pointer2
:a:b@b$a;:a=KF:b=KE@b$a<;pointer3
:a:a;:a=KF:a=KFERROR;redefine-existing;
:a:a:a$a;:a=KF:a=KFERROR;redefine-existing;
@a;@aERROR;at-undefined;
$a;$aERROR;to-undefined;
:a!a:a;:a=KF!a:a=KF;dealloc-alloc;
!a;!aERROR;dealloc-nonalloc;
(->+);[->+<];auto-balance;
);]ERROR;auto-balance-error;
(;[ERROR;auto-balance-missing;
:b:c!c!b;:b=KE:c=KD!c!b;simple-deallocation-all;
:a:b:c$c++++(-$b+++++++(-$a+++++++++++))!c!b;:a=KF:b=KE:c=KD$c>>++++[-$b<+++++++[-$a<+++++++++++>]>]!c!b;triple-multiply;
:a<$a;:a=KF<$aERROR;overflow-below-zero;
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a=KF>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$aERROR;256-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a=KF>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$aERROR;255-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a=KF>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$aERROR;254-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a=KF>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;253-no-overflow
{x~012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234()}&x;~x=IM&x~012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234[];above256-in-buffer;
:a<<<<$a;:a=KF<<<<$aERROR;below-zero;
:a:b<<<<$b;:a=KF:b=KE<<<<$bERROR;below-zero2;
<();<(ERROR;overflow-open;
(<);[<)ERROR;overflow-close;
:a<<<<@a$a;:a=KF<<<<@a$a;below-zero-at;
:a:b<<<<@a$b;:a=KF:b=KE<<<<@a$b>;below-zero2-at;
:a<@a();:a=KF<@a[];overflow-open-at;
:a(<@a);:a=KF[<@a];overflow-close-at;
:b{a$a};:b=KE~a=KF;macro-definition;
:b{a$a}{a$a};:b=KE~a=KF~a=KFERROR;macro-redefinition-error;
:a{a};:a=KF~a=KFERROR;macro-empty-error;
{a....;~a=KF;macro-definition-not-terminated;
{aaa;~aaa=BM;variable-name-not-terminated;
{a~ba}&a;~a=KF&a~ba;macro-expansion;
{a~ba}{b~ba}&b;~a=KF~b=KE&b~ba;macro-expansion;
{a:a}&a>$a;~a=KF&a:a=KF>$a<;macro-create-var
{x!q}&x;~x=IM&x!qERROR;macro-dealloc-nonalloc;
{x@a}:a&x;~x=IM:a=KF&x@a;macro-at;
{x@a}:a(>>>&x);~x=IM:a=KF[>>>&x@a];macro-at-loop;
{x&b}{b$a}:a>&x;~x=IM~b=KE:a=KF>&x&b$a<;macro-call-macro;
{p:a:b:c$c++++(-$b+++++++(-$a+++++++++++))!c!b}&p;~p=JF&p:a=KF:b=KE:c=KD$c>>++++[-$b<+++++++[-$a<+++++++++++>]>]!c!b;macro-triple-multiply;
&a;&aERROR;macro-undefined-macro;
{a~test&b}&a;~a=KF&a~test&bERROR;macro-call-undefined-macro;
a{a{bb}};a~a=KFERROR;macro-definition-in-macro-definition-error;
{bba}&b;~bba=LDERROR;macro-variable-long-body-empty-error;
>>{my~test}&my;>>~my=FA&my~test;macro-long-use
>:test:test2:test3$test$test3;>:test=AE:test2=LE:test3=LD$test<$test3>>;long-variable-goto
^;^ERROR;parameter-non-macro
{q>^}&q;~q=JE&q>^<;parameter-simple-once
{times_c:t1:t2(-$c(-$t2+$t1+)$t2(-$c+))$t1(-^+)!t2!t1}:c:d$c+++$d++++&times_c;~times_c=HA:c=KD:d=KC$c+++$d>++++&times_c:t1=OO:t2=ON[-$c<[-$t2>>>+$t1<+<<]$t2>>>[-$c<<<+>>>]<<]$t1>[-^<+>]!t2!t1;parameter-complex
{t1>>&t2^}{t2>>,(-^+)}&t1;~t1=OO~t2=ON&t1>>&t2>>,[-^<<+>>]^<<<<;parameter-nested
{t^1}&t;~t=JB&t^1>;parameter-move-simple
{t^2}&t;~t=JB&t^2>>;parameter-move-simple-2
{add_by_a$a(-^0+^1+)^1(-$a+)}:a+++>++&add_by_a;~add_by_a=AD:a=KF+++>++&add_by_a$a<[-^0>+^1>+<<]^1>>[-$a<<+>>];parameter-complex
*5>;*5>>>>>;multiplication-single
*10>;*10>>>>>>>>>>;multiplication-multiple
*260+;*260++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;multiplication-multiple-overflow-might-happen;todo
:a*5>$a;:a=KF*5>>>>>$a<<<<<;multiplication-pointer-movement;
:a*3<$a;:a=KF*3<<<$aERROR;multiplication-pointer-movement;
:a*254>$a;:a=KF*254>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$aERROR;multiplication-254-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
%"test";;create-string;todo
|"test";;print-string;todo


