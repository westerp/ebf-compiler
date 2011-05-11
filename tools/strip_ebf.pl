#!/usr/bin/perl
# strips ebf of commments for faster processing

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
