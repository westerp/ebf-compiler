# Creating a self-hosting compiler #
## What I expect you to know to understand this ##

I expect you to know elementary brainfuck and I expect you to have
tried to create your own brainfuck programs. You may try some of the links
on this page or google it.

## What is a compiler ##
<p>According to <a href='http://en.wikipedia.org/wiki/Compiler'>Wikipedia</a> it is a program<br>
that converts a high level source code to a lower level source code or<br>
machine code. brainfuck, how I see it, is machine code with readable<br>
instructions so that there is no need for a Assembly language other than<br>
the instructions themselves. A <a href='http://www.clifford.at/bfcpu/bfcpu.html'>brainfuck CPU </a> design<br>
example is made by Clifford Wolf.<br>
<br>
<br>
<h2>Has this been done before?</h2>
<p>There are several approaches made by many to create extensions to<br>
brainfuck.<br>
<h3>By changing the language</h3>
<p>Some create extensions in the interpreter/compiler so that you actually<br>
change the CPU. a notable example would be<br>
<a href='http://www.parkscomputing.com/code/pbrain/'>pbrain</a>, where Paul M. Parks<br>
used <tt>()</tt> to enclose procedures and <tt>:</tt> to call them. Which procedure you define<br>
or call was the value of the current cell. Nice idea but it will never run<br>
on any brainfuck CPU/interpreter og even be compiled by any brainfuck to<br>
native/other compiler. (though Tim Rohlfs did write support in his IDE)<br>
<br>
<br>
<h3>By creating a compiler in perl/c/other language</h3>
<p>You define a language and create a compiler that creates valid and<br>
standard brainfuck code. <a href='http://www.cs.tufts.edu/~couch/bfmacro/bfmacro/'>bfmacro</a>
by Alva L. Couch and  <a href='http://www.clifford.at/bfcpu/bfcomp.html'>2 stage compiler bfc=&gt;bfa=&gt;bf</a>
by Clifford Wolf. Both of these compile their own invented<br>
extensions to standard brainfuck but non of the compiler are written in<br>
either brainfuck or the language the compiler supports.<br>
<br>
<h2>The aim of this project</h2>
<p>
The aim of this project was to make a self-hosting (written in itself)<br>
compiler and see how I could bootstrap this and how it will eventually<br>
evolve. Beeing <a href='http://www.iwriteiam.nl/Ha_bf_Turing.html'>Turing complete</a> there is nothing you cannot implement in<br>
brainfuck. It's very inspired by <a href='http://homepage.ntlworld.com/edmund.grimley-evans/bcompiler.html'>Edmund GRIMLEY EVANS' Bootstrapping a simple compiler from nothing</a> which I highly recommend.<br>
<br>
If you are interested you may go to  <a href='Part1Design.md'>Part 1: Design</a>