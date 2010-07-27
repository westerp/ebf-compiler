#!/usr/bin/perl -w
#
# $Id$
#
# This file is part of ebf-compiler
#
# ebf-compiler is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# (at your option) any later version.
#
# ebf-compiler is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
#

open(CODE, $ARGV[0])|| die("Could not open code file: $!");
my $line = <CODE>;
chomp($line);
my @code = split//,$line;

my $index = 0;
my $mod = @code;

open(IMG, $ARGV[1])||die("could not open design file: $!");
while(<IMG>)
{
  foreach $i (split(//,$_))
  {
    #print $i;
    if( $i eq '#' ){
        if( $index == $mod ){
            print "~";
        } else {
            print $code[$index];
            $index++;
        }
    } else {
      print $i;
    }
  }
}
if( $index <= $mod )
{
 my $c=0;
 while( $index != $mod )
 {
   print "\n" if( $c % 80 == 0);
   print $code[$index];
   $index++;
   $c++;
 }
 while($c % 80 != 0)
 {
   print "~";
   $c++
 }
 print "\n";
}