#!/usr/bin/perl -p
# tool to strip ebf1.3 to make it compile faster under unomptimized ebf1.2
s/(?<![&:\$@\{])[^\+-<>\[\],.\(\)&:\$\@\{\};\n]//g
