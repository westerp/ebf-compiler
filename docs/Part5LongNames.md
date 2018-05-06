# Legal variable name syntax #

The current version takes a variable name for each of the commands :,!,$,@,{ and &. A command can follow immediately so $a-b would be goto variable a, reduce, comment "b". We would like our code to be able to run ebf without change so a variable name should be limited to `/[0-9a-zA-z_]/`. As a test i have created an example using variables from ebf to check if a character is within `/[0-9a-zA-Z_]/`. Have a look at [match\_word\_or\_underscore.ebf](https://code.google.com/p/ebf-compiler/source/browse/trunk/examples/match_word_or_underscore.ebf) under examples. I'd like to credit `(>>[-<]<[>]@m$v-)` which is used to identify more than one character within a range with only one if test to [Daniel B. Cristofani](http://www.hevanet.com/cristofd/brainfuck/intermediate.html)

# New flow #

  * We keep the main switch. If the command is one of :,!,$,@,{ or &, store a index which indicates which command and remove call to the implementing macro.
  * After the switch the index is checked. If non-zero a routine to retrieve (from , or buffer) the characters invoving the name of routine. First char is always taken, next char has to be `[0-9a-zA-Z_]`.
  * a hash function is applied if there are more than one character
  * if the char last read is not `[0-9a-zA-Z_]` (except first char), that is put in a location for further use.
  * a last switch checks and arund appropriate macro and macroes are changed to retrieve byte from a predefined location (v) instead of reading.
  * read routine needs to check for left over char first, before checking buffer and stdin.
  * macro create should add leftover char to macro.
  * macro expand needs to move leftover char to buffer so that it will be interpreted after the body of the macro.

# Hash function #

At first I though the very easy Bernstein hash ( h = h\*33 + new\_val ) was a good choice, but that algorithm is good when we have larger cell sizes and arrays. I ended up having to reduce the value to something below 256 and the larger cell size the slower implementation. The actual method used now is h = h\*11 + new\_val-1 and h is then mod 251-ed and incremented so we have from 1 to 251 as values.

# `^, ^0..^9` #

I did plan this and have had made room for a second stack in the beginning of the memory [(See Bracket balancing)](Part3MacroAndBracketBalance.md). I implemented two commands 1 and 2 where 1 pushed current position to macro stack and 2 removes the top of the stack. Then, when ^ occurs I copy the top most position (calling cell of current macro expansion) and apply < or > to move the pointer to that position. Here I reuse move\_var-code by moving most of it to it's own macro. Then I added support for an optional numeric argument. If it's not a number i put it in h (left over char) which always be processed before anything else.

# `12>` #

`12>` turns one > into 12 >'s and, used to program in ebf, there is  much repetition. Another thing is `97+` might be a better way to create an 'a' than a loop. Here I again used Daniels wonderful substract algo to check if each char read is a number. It also checks for > and < and updates position, again with the substract which also works as a addition with overflow check. I would want it to be able to have more than 255 for 8 bit, but its'a good start.

# `~"store"` #

This one is a bit of a pickle. I need to store the whole string and divide them in 10's or similar and create the string by writing it using an extra cell on the right that will end up being 0. Heres an example of storing the word test:
```
~"test"++++>+>+++++>++++++>>++++++++++[-<+<+++++++++++<+++++++++++<++++++++++<++++++++>>>>>]
```