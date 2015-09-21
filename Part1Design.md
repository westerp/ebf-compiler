# New instruction set #

One of the largest problems with brainfuck is the location logic. When programs get large enough it's easy to loose our way and get lots of errors so I thought we introduce variables.

```
:a ; defining variable named a
$a ; command to move to th eposition of a
!a ; remove variable named a
;  ; a comment. We allow brainfuck and ebf-code here so ebf need to euither strip it completly or just the harmful characters.
```

## One character variable names ##
There is no point in making this more difficult than it already is. So if we
treat the first character as an operator (: $ and !) and the second character as the parameter
we can have a table lookup on the ascii value of the character to which the pointer value resides.

There is also no pojnt in not using a counter that increases for every allocation. this **requires** that we deallocate variables in reverse order as allocation.

# Arrays in brainfuck (and in EBF implementation) #
Creating fixed sized arrays of elements are easy. You make use of bread crumbs to create a path to one element. In our case we want only one cell array of size 256 (one for each ASCII value). We do it like this:

```
:c
:n
:z

++++++++[->++++++++<]>                       ; 64
[->>>>>>>[>>>>>>>>]+[<<<<<<<<]>]             ; 8*64 = 512
>>>>>>>[->>>>>>>>]                           ; goto 520
@z
```

We passed 512 by 8 but that really doesn't matter. to open a location, say "a" (97), we store it in n and do this:
```
$n [-<[<<]+[>>] @z $n] ; open array
```

now to move from any variable to the 97the element of array we do this:
```
$c[<<]>
```

and to get back
```
>[>>] @z
```

# Switch (and in EBF implementation) #
To implement this we need to read one char and check it against a low number of known set of constants. The easiest way to implement this in brainfuck is to order them from lowest ascii value to highest and substract every value with its previus chars value. This first char is just negated.


```
:w
:t
$w,
----------                      ; reduce by  linefeed (10)
[ ---------                     ; not liefeed, reduce by 10 to space space (20)
 [ do default stuff $t-$w[-]    ; not any. in default
 ]$t[ do space stuff $t-] $w    ; case space
]$t[ do linefeed stuff $t-] $w  ; case finefeed
; end up here when finished switch case
```

[Part2:My first Draft](Part2Design.md)