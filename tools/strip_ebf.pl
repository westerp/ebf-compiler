#!/usr/bin/perl
# $Id$
#
# This file is part of ebf-compiler package
#
# strips ebf of commments for faster processing
#
# ebf-compiler is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ebf-compiler is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License

my $param = pop(@ARGV) if( @ARGV > 1 );

while ( <> )
{
  if( $param eq '-v1' ){
    s/(?<![&:\$@\{])[^\+-<>\[\],.\(\)&:\$\@\{\};\n]//g
  }
  else
  {
  s/;.*\n/ /;
    if( $param ne '-c' )
    {
      s/(?:^|\s)(?:\w+(?:\s|$))+/ /g;
      s/\s+/ /g;
      s/\s(?=[&:\$@\{])//g;
      s/\s+\n+/\n/;
    }
  }
  print;
}
