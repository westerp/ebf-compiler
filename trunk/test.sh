#!/bin/bash

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
   	 desc=$(echo $i| cut -d\; -f3)
   	 todo=$(echo $i| cut -d\; -f4)
   	 ret=$(echo "$test1" | beef ebft.bf)
   	 tests=$[$tests+1]
    	if [ "$ret" != "$exp" ]; then
            	if [ "$todo" != "todo" ]; then 
	            	echo ERROR $desc \($test1\): \"$ret\" != proof \"$exp\"
       		 	nok=$[$nok+1]
       		else
	            	echo warning $desc: \"$ret\" != \"$exp\"
       			todos=$[$todos+1]
       		fi
	else
	        ok=$[$ok+1]
	        if [ "$todo" = "todo" ]; then 
	        	echo "REMOVE todo from $i"
	        fi
	fi
    fi
done

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
:a<<<<$a;:a<<<<$a;below-zero;
:a:a;:a:aERROR;redefine-existing;
:a:b<<<<$b;:a:b<<<<$b>;below-zero2;
:a:a:a$a;:a:aERROR;redefine-existing;
@a;@aERROR;at-undefined;
$a;$aERROR;to-undefined;
:a!a:a;:a!a:a;dealloc-alloc;
!a;!aERROR;dealloc-nonalloc;
(->+);[->+<];auto-balance;todo
