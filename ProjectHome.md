<wiki:gadget url="http://hosting.gmodules.com/ig/gadgets/file/101298749992945970251/facebook-like-button.xml" up\_url\_to\_like="http://facebook.com/#!/pages/EBF-Compiler-suit/187363671326729" synd="open" w="480" h="80" output="js" width="480" height="80" border="0"  />

# A self hosting Extended brainfuck to pure brainfuck compiler #
EFB Compiler extends brainfuck by using extra symbols. The output will be valid brainfuck code that can run on any interpreter/compiler. If you are interested in the process of making this compiler, please go to the [Introduction](Introduction.md). To find out more about the the syntax have a look at [EBF language introduction](EBFLang.md)

## Serious use: Zozotez - a LISP interpreter implemented in EBF ##
The high level goal was to be able to implement a LISP interpreter which runs on brainfuck and bootstrapped with EBF.  I have spawned a new project called **[Zozotez for creating LISP with EBF](http://code.google.com/p/zozotez/)**.


## Current features ##
  * Variables with variable length names
  * Alternative bracket () for automatic bracket aligning
  * A macro replace mechanism that is nestable with parameter passing
  * multiplication of bf commands by using number in front of them. eg. 256>
  * print string and store string for easy string manipulation
  * All the power of `BrainFuck`. All BF programs are EBF programs :)
  * Compatible with most cross compilers/interpreters. Supports all EOF convensions

![http://sylwester.no/gcodeimg/lamp_50.png](http://sylwester.no/gcodeimg/lamp_50.png)


## Current Commands in addition to BFs `<>+-[],.` ##

_var in these examples can be any string of alphanumeric characters and underscore `[\w_]+`._

<table cellpadding='2' border='1'>
<tr><th>group</th><th>function</th><th>description</th></tr>
<tr><td>variable</td><td><b>:var</b></td><td>Defines a variable. It allocates variable in the order of appearance, eg. :a:b will give a position and b position 1. If you try to redefine a variable it will report ERROR. For byte-oriented interpreters/cross compilers the maximum number of variable allocated at the same time is 253.</td></tr>
<tr><td><b>$var</b></td><td>Applies <'s or >'s in order to move from current position to the position allocated to variable named x. It assumes it is at position 0 at the start of the application and it will follow < and > given that you don't create an asymmetric loop.</td></tr>
<tr><td><b>@var</b></td><td>To give the compiler the position after a asymmetric loop. Take for instance: <code>:a:b:c:d [&gt;-]&gt;[-&gt;] @c&lt; </code> It is impossible for the code to actually go into both loops so in reality you will always be in c and not d as the compiler thinks. </td></tr>
<tr><td><b>!var</b></td><td>Deallocates variable x. It is assumed that x was the last variable allocated and will halt with an ERROR if not.</td></tr>
<tr><td>structure</td><td><b>(</b>...<b>)</b></td><td>Auto-aligning brackets. <code> $a($b+++) =&gt; $a[$b+++$a] </code>. This might be used in rotating data structures like array seeking as well. consider we have an array left of <code> :c:a:z </code> which is open.. <code> $c(@z) </code> will seek until bread crumb is zero. It supports up to 251 nested loops. awib 0.2 has 18 and as of writing ebf has 12 as it's highest nesting level.</td></tr>
<tr><td>macro</td><td><b>{name</b>...<b>}</b></td><td>Create macro named x. Contents will not be echoed since it might contain brainfuck code that will affect execution. A macro cannot create other macroes. When macroes are expanded ebf will treat the expanded text as ebf code, not just pure brainfuck. This enables a macro expansion to trigge runderlying macro expansins and the posibility to create complex code in layers of abstraction.</td></tr>
<tr><td><b>&name</b></td><td>Insert macro x.</td></tr>
<tr><td><b><code>^&lt;index&gt;</code></b></td><td>
<code>^0</code> works like $var. <code>^0</code> is the cell from which the macro was called and ^1 is the first cell after making this a kind if parameter passing possible eg we have<br>
:a:b:c and we are at a when invoking &a. In there <code>^ and ^0 is $a, ^1 is $b and ^2 is $c</code>.<br>
If we afterwards are at $b and call the macro, then ^0 would be $b.</td></tr>
<tr><td><b><code>*&lt;+-&gt;&lt;offset&gt;</code></b></td><td>Another way to indicate offset. Like @a, but you tell the relative offset fix. Eg. <code>*-3</code> will reduce the compilers assumed position with 3. Used in combination with <code>^&lt;number&gt;</code> where macro does not know of it's real position (eg. it could be called from any position and hench reused)</td></tr>
<tr><td>Syntax sugar</td><td><b><code>&lt;number&gt;&lt;+-&lt;&gt;&gt;</code></b></td><td>
Eg. 10+ reads like "times 10 plus". It replicates any of the commands <code>&lt;&gt;+-</code> the number of times indicated by the digits before the operation (+ in example). It does not have cell boundry limits. <code>512&gt;</code> is OK for 8 bit interpreter/compilers.<br>
</td></tr>
<tr><td><b><code>~</code>"text"</b></td><td>Stores the string denoted by text from the current cell. Position end up one cell to the right from the last character in the string. Example uses double quotes, but in reality any character will do, eg. <code>~*"'^*</code> uses asterix as quote character</td></tr>
<tr><td><b>|"text"</b></td><td>Prints the string denoted by test using the current and the next cell, which needs to be empty. Current cell contains last character after operation.Like store string you might use any quote char.<br>
</td></tr>
</table>

## Examples,. The advantage of EBF comes apparent when dealing with larger projects than these examples ##
<table border='1'>
<tr><td><b>desc</b></td><td><b>EBFsource</b></td><td><b>BFobject</b></td></tr>
<tr><td><code>HelloWorld</code></td><td>
<pre><code>|"Hello World<br>
"<br>
</code></pre>
</td><td>
<pre><code>&gt;++++++++[-&lt;+++++++++&gt;]&lt;.<br>
&gt;+++++[-&lt;++++++&gt;]&lt;-.+++++<br>
++..+++.&gt;+++++++++[-&lt;----<br>
-----&gt;]&lt;++.&gt;+++++++[-&lt;+++<br>
+++++&gt;]&lt;-.&gt;+++++[-&lt;+++++&gt;<br>
]&lt;-.+++.------.--------.&gt;<br>
++++++++[-&lt;--------&gt;]&lt;---<br>
.&gt;++++[-&lt;-----&gt;]&lt;---.<br>
</code></pre>
</td></tr>
<tr><td>echo</td>
<blockquote><td>
<pre><code>;;macro definitions<br>
{read $eof_flag+$input(-),[+[-&gt;-]]&gt;[@eof_flag-&gt;]}<br>
{print .}<br>
var :input<br>
var :eof_flag<br>
;;main program<br>
&amp;read<br>
$input(<br>
  &amp;print<br>
  &amp;read<br>
)<br>
</code></pre>
</td>
<td>
<pre><code>&gt;+&lt;[-],[+[-&gt;-]]&gt;[-&gt;]&lt;&lt;[.<br>
&gt;+&lt;[-],[+[-&gt;-]]&gt;[-&gt;]&lt;&lt;]<br>
</code></pre>
</td></tr>
<tr><td>simple<br>
add</td>
<td>
<pre><code>{read ^1eof_flag+^0input(-),[+[-&gt;-]]&gt;[-&gt;] *-1}<br>
:num1<br>
:num2<br>
$num1 &amp;read<br>
$num2 &amp;read<br>
$num1 48-<br>
$num1(-$num2+)<br>
$num2 .<br>
</code></pre>
</td><td>
<pre><code>&gt;+&lt;[-],[+[-&gt;-]]&gt;[-&gt;]&lt;&gt;<br>
+&lt;[-],[+[-&gt;-]]&gt;[-&gt;]&lt;&lt;&lt;<br>
----------------------<br>
----------------------<br>
----[-&gt;+&lt;]&gt;. <br>
</code></pre>
</td></tr>
<tr><td>reverse<br>
echo</td><td>
<pre><code>:input<br>
:end_flag<br>
<br>
{read<br>
  $end_flag+ <br>
  $input,<br>
  +[11-[$end_flag-]]&gt;[@end_flag-&gt;]<br>
}<br>
<br>
; read until linefeed/eof<br>
+(-&gt;@input &amp;read ) <br>
; print in reverse order<br>
&lt;@input[11+.(-)&lt;] <br>
; print newline<br>
10+.<br>
</code></pre>
</td><td>
<pre><code>+[-&gt;&gt;+&lt;,+[-----------[<br>
&gt;-]]&gt;[-&gt;]&lt;&lt;]&lt;[++++++++<br>
+++.[-]&lt;]++++++++++.<br>
</code></pre>
</td>
</tr>
</table></blockquote>

[See more examples in source repository](http://code.google.com/p/ebf-compiler/source/browse/#svn%2Ftrunk%2Fexamples)


# This site is a member of a `Web Ring`. #
To browse visit [The Esoteric Programming Languages Ring](http://ss.webring.com/navbar?f=l;y=webringcom44;u=defurl)
<br /><br />
