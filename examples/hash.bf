






















ML|c|v|m|z|i|t|w|a|d

:c
:v 
:m
:z

:i input
:t temporary must be next to w and i
:w working must be between t and a
:a adding aide must be next to w
:d



$m>>+
[
  &i
    $v<, read byte into v

  ----------
  [++++++++++

    $t>>>>[-$w>+<] move t to w
    $w>[-$t<+++++++++++++++++++++++++++++++++>] multiply last value in t by 33 and set back to t
    $v<<<<<[-$t>>>>+<<<<] pour v to t
    $m>+
  <]
  $m>-
]

print result
$i>>- 255 in i
$t>[
$w>++++++++++ store 10 in v
$t<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]@t     t with w eq 8
after 0=0 1=positive 2=n%d 3=n/d
$w>[-]
$a>[-$t<<+>>]
$d>[-$w<<+>>]$w<<
@t]
$w>+
$i<<+[+++++++++++++++++++++++++++++++++++++++++++++++.[-]<@i+]
$w>>[+++++++++++++++++++++++++++++++++++++++++++++++.[-]]
++++++++++.
