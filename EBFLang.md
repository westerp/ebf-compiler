# Extended means everything BF is EBF #
If You would like to write ` +++++++++[->++++++++++<]>. ` to print a Z then do it. But I would at least have done ` 9+(->11+)>. `. Every <,>,+ or - following a number repeats the operation said number times and reduces a risc of writing one more or one less operation making bugs in your code. To be honest I though I had written 10 pluses both times making a lower case d. Z was just as good a example so I stuck with it. If I would have started off with EBF the example here would have been d. Normal parenthesis will convert to bracket parenthesis making the extra < before ]. If you use () for balanced and [.md](.md) for deliberate unbalanced the code will be more easily read. Whenever you want to do as this example using |"d" would save you a lot of agony since it will use square root to do this as optimum as possible yielding the not so different ` >9+(-<11+)<. ` and all you need is that current and next cell is empty.

# Variables #
A variable is a symbolic name for a cell location. You define a new variable with : before use and if you would like you can deallocate it with !. You move to the variable location with $ and whenever you have a unbalanced loop you can tell the compiler where you are with either @ (if you know the exact name) or `*` if you know the exact offset.

Assume you have a value in test to check if is either 3 or 2
```
:test
:flag
$test 3+ ; depending on number here it will change outcome
$flag+
switch $test-- ; word switch has no function other than readability
(-
        ((-) $flag- |"It was no match"(-)  )
  $flag (- |"It was 3"(-) )
)
$flag   (- |"It was 2"(-) )
```

Here is another example testing for linefeed or not using a asymmetric (as in the cell tested are not always the same) loop for non destructive testing.
```
:test
:flag
:zero
$test , 10- ; read and reduce with 10 aka linefeed
$flag+
if $test ; the word if before the command to move to test has no fucntion other than readability
[
  $flag- ; moves to flag and resets. compiler will think its in flag
  |"Input was not linefeed"(-)
]
@test                   ; tell compiler that we are in test
if $flag set
[-                      ; remove flag
  |"Linefeed!"(-)
  $zero                 ; move
]
```

The compiler counts < and >'s and the $where's and it expects to get an @ whenever compiler pointer may be in limbo. The placement of the @ here resets the compiler back as if the first loop was not entered making the compiler assumptions from there on correct.

# Macroes #
Macroes are excellent ways to reduce the complexity of your code. A macro content will be evaluated as EBF after expansion and can be nested. The resulting code does not need to be the same since it all depends on from where it is called.

```
{print_twice_macro
  .. ; print whatever was there twice
}

:d
:Z
$d 100+
$Z 99+
&print_twice_macro ; prints ZZ
$d
&print_twice_macro ; prints dd
```

Macroes knows from which data location it had when called and `^/^0` is that location. ^1 is the next cell to that and so on. This can be used as parameters to a macro. Combined with variable allocation and deallocation it can do more than a static macro.

```
{print_plusone
  :tmp:pri
  ^0(-$tmp+$pri+)       ; destructive
  $tmp(-^0+)            ; but restores
  $pri+.(-)             ; prints the next char
  !pri!tmp              ; deallocate the cells
}

:s:e:t  ; placeholder for my string
~"set"  ; we now have s in $s...
$t &print_plusone
$e &print_plusone
$s &print_plusone
$t &print_plusone ; this will work since print_plusone is not destructive!
```

The code above will print uftu which is the Caesar cipher for test with key 1. This is not efficient as we could just have done ` >~"tset"<[+.<] ` to do the same.

# stay tuned for more cool stuff here... #