# First draft #

```
:c variable crumble
:n variable value
:z zero
:g global variable index
:i input
:t temporary
:w working
:a adding aide
:p position

++++++++[->++++++++<]>							; 64
[->>>>>>>[>>>>>>>>]+[<<<<<<<<]>]					; 8*64 = 512
>>>>>>>[->>>>>>>>]							; goto 520
@i ; indicates that we are on i

$i ,[									; outer loop. EOF=0

; copy $i to $w
[- $t+ $w+ $i ]								; pour $i to $w and $t
$t [- $i+ $t  ] 							; pour $t to $i
+									; i=I|t=1|w=I|p=x|n=0|v=0
; switch
$a +++[- $w ----------- $a]						; reduce $w with 3*11=33(!)
 $w [---								; no, reduce $w with 3($)
  [ $a++[- $w----------- $a ] $w					; no, reduce $w with 22(:)
   [ -									; no, reduce by 1 (;)
    [ -									; no, reuce by 1 (<)
     [ --								; no, reuce by 2 (>)
      [ --								; no, reduce by 2 (@)
       [ $i . $t+++++++[- $w ++++++++ $t] $w [-] ]  			; reset $t and $w
       $t [- 								; in @
 			$p[-]$i.$n,.[-<[<<]+[>>]<] @n			; move to ascii value of variable left
			$c [<<]>[-<<<+>>>>[>>] @z $p + $c [<<]>]	; copy n to p and c-1
			<<<[->>>+<<<]>>>>[->>] @z			; restore original value
          $t] $w							; in @ end
      ]$t [- $i.$p+$t ] $w						; in > adjusts pos
     ]$t [- $i.$p-$t ] $w						; in < adjusts pos
    ]$t [[,----------]++++++++++.[-]] $w 				; in ; removes comment
   ]$t [
			$i.$n,.[-<[<<]+[>>]<] @n			; move to ascii value of variable left
			$g [- $t+ $c[<<]>+>[>>] @z >]			; copy g to t and n
			$c [<<]>>[->>] @z				; clear trail
			$t [- $g+ $t]					; increase g and pour t on g
	 $t]$w								; in :
  ]$t [- 								; move to a ($)
			$i.[-]$n,.[-<[<<]+[>>]<] @n			; move to ascii value of variable left
			$c [<<]>[-<<<+>>>>[>>] @z $i + $a + $c [<<]>]	; copy n to i and a and c-1
			<<<[->>>+<<<]>>>>[->>] @z			; restore original value
			<++++++[->++++++++++<]				; 60 in z (<)
									; we have new position in i and old in p
			$w+$p[ $a [-$w-]<[@w-
				$p[-$z.$p] + $t] $w+$p-]		; a is smaller than p, eg. <
			$z++$w-$a[-$z.$a]$z[-]
			$i[-$p+$i]					; set current position
    $t] $w
 ]$t [- remove var ] $w							; in ! need to implement (but not yet)
$i,]									; loop until read EOF == 0
```

# Hand compiling #
Since the code did not include use the destructor I did not implement it yet, but I have a placeholder for it so I don't have to redo the switch. I used the very structured list of variables and assumed the fort to be 0 and so om and for every @x i assumed position x and for every $x i added < or > according to its distance from what I saw was the current position. After that i used `perl -pi~ -e 's/;.*//'`
to remove all the comments and tried to run itself with the original source above as input. I then did a diff between them to see that when hand compiling I had added the arrows before the variable and. The very first compiled version is called ebf10\_handcompiled.bf. This require a interprenter/compiler that sets the cell to 0 on EOF to work and has wrapping cells (of any size).

[Part3: Implementation Macroes and Bracket balancing](Part3MacroAndBracketBalance.md)