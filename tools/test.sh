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
        echo -en "\r                                                                             \r"
        echo -en "test $tests: $desc"
        ret=$(echo -n "$test1" | $INTERPRENTER  $EBF)
        if [ "$ret" != "$exp" ]; then
                if [ "$todo" = "todo"  -o "$todo" = "warn" ]; then
                    echo warning $desc: \"$ret\" != \"$exp\"
                    todos=$[$todos+1]
                else
                    echo " ERROR $test1: \"$ret\" != proof \"$exp\""
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
:a;:a;allcation
>:a$a;>:a$a<;pointer1
:a:b$b<$b;:a:b$b><$b>;pointer2
:a:b@b$a;:a:b@b$a<;pointer3
:a:a;:a:aERROR;redefine-existing;
:a:a:a$a;:a:aERROR;redefine-existing;
@a;@aERROR;at-undefined;
$a;$aERROR;to-undefined;
:a!a:a;:a!a:a;dealloc-alloc;
!a;!aERROR;dealloc-nonalloc;
(->+);[->+<];auto-balance;
);]ERROR;auto-balance-error;
(;[ERROR;auto-balance-missing;
:b:c!c!b;:b:c!c!b;simple-deallocation-all;
:a:b:c$c++++(-$b+++++++(-$a+++++++++++))!c!b;:a:b:c$c>>++++[-$b<+++++++[-$a<+++++++++++>]>]!c!b;triple-multiply;
:a<$a;:a<ERROR;overflow-below-zero;
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ERROR;256-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ERROR;255-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ERROR;254-overflow-Not-to-worry-if-your-interprenter-does-more-than-8-bits;warn
:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a;:a>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$a<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;253-no-overflow
{x~012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234()}&x;&x~012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234[];above256-in-buffer;
:a<<<<$a;:a<<<<ERROR;below-zero;
:a:b<<<<$b;:a:b<<<<ERROR;below-zero2;
<();<(ERROR;overflow-open;
(<);[<)ERROR;overflow-close;
:a<<<<@a$a;:a<<<<@a$a;below-zero-at;
:a:b<<<<@a$b;:a:b<<<<@a$b>;below-zero2-at;
:a<@a();:a<@a[];overflow-open-at;
:a(<@a);:a[<@a];overflow-close-at;
:b{a$a};:b;macro-definition;
:b{a$a}{a$a};:bERROR;macro-redefinition-error;
:a{a};:aERROR;macro-empty-error;
{a....;;macro-definition-not-terminated;
{a~ba}&a;&a~ba;macro-expansion;
{a~ba}{b~ba}&b;&b~ba;macro-expansion;
{a:a}&a>$a;&a:a>$a<;macro-create-var
{x!q}&x;&x!qERROR;macro-dealloc-nonalloc;
{x@a}:a&x;:a&x@a;macro-at;
{x@a}:a(>>>&x);:a[>>>&x@a];macro-at-loop;
{x&b}{b$a}:a>&x;:a>&x&b$a<;macro-call-macro;
{p:a:b:c$c++++(-$b+++++++(-$a+++++++++++))!c!b}&p;&p:a:b:c$c>>++++[-$b<+++++++[-$a<+++++++++++>]>]!c!b;macro-triple-multiply;
&a;&aERROR;macro-undefined-macro;
{a~test&b}&a;&a~test&bERROR;macro-call-undefined-macro;
a{a{bb}};aERROR;macro-definition-in-macro-definition-error;
{bba}&b;ERROR;macro-variable-long-body-empty-error;
>>{my~test}&my;>>&my~test;macro-long-use
