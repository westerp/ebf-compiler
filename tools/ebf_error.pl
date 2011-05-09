#!/usr/bin/perl -w

die("usage: $0 object-file\n") unless defined $ARGV[0];
die("Compilation of $ARGV[0] failed: zero size\n") if(! -s $ARGV[0] );
my $file = $ARGV[0];
$/=undef;
$in=<>;
die("compilation of $file failed: $&\n") if( $in=~ /^.*ERROR.*$/m )
