# implementation of bracket balancing #

We can have nestet bracket and therefor need a stack to handle the positions of closing parenthesis.  So with the current design we have this high level memory map

| array of variable positions with size 255 | crubmle | variable | zero|global|input|tmp|working|adding|position|
|:------------------------------------------|:--------|:---------|:----|:-----|:----|:--|:------|:-----|:-------|

A stack should be placed on the left. After doing some statistics I found out that variable use was greater than bracket use. Therefor it should be placed **before** the variable lookup.

| stack |-1/255| array of variable positions with size 255 | crubmle | variable | zero|global|input|tmp|working|adding|position|
|:------|:-----|:------------------------------------------|:--------|:---------|:----|:-----|:----|:--|:------|:-----|:-------|

## Using -1/ as a marker ##
By doing a ` +[-<+]- ` we do a backward seek until we match -1/255 and restore the value. Having two like this will make the movement from **stack space** to **variable space** easily. This also means that there cannot be 255 in any cells between the markers and 254 cannot be in the stack either. Since the actual limit for once byte variables are 95 and that a hash would be modulus 251+1 the number of positions will never reach 253 or above but individual >'s and <'s might put positions that will cause problems. TYHe fix is to ERROR when below 0 or above 253 is encountered and the next command is not @.

|-1|top|...|bottom|-2| array | variables | unused space |
|:-|:--|:--|:-----|:-|:------|:----------|:-------------|

## Macroes ##
With Macroes we will need several things.

  * Stack to store return address if one want's to move position back to before the macro started. This will work as a variable only that it has a constant name for each entered macro.
  * Extra lookup amongst the array for the macro name. this will ensure we can have a macro named a and a variable named a and when long names come along we will have less chance of collisions.
  * A variable index like global for macroes.
  * A array of indexes of  macroes starting with 0. for copying the macro to input
  * A area for expanded macro. To save memory we only have expanded macroes there and when there are no bytes in buffer ebf will read from stdin.

## Where to put it ##

| stack of brackets(odd) and macro positions(even)|-1| array of variable positions and macro indexes| variables |-2| macroes delimited by 3 cells of 0's |-1|input buffer|
|:------------------------------------------------|:-|:---------------------------------------------|:----------|:-|:------------------------------------|:-|:-----------|

Input buffer must be set left to right. As long as a Macro cannot be defined in a macro, there is no chance of a macro definition overwriting input buffer. There is no problem in creating macroes after using other macroes since when a macro is inserted the buffer will be empty.

[Part4: Macro expansion performance problems](Part4MacroPerformance.md)