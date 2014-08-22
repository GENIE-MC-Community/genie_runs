#!/usr/bin/env perl

# Run on the captured output of a valgrind job with suppression 
# generation turned on to remove everything but the suppression
# messages.

if ($#ARGV < 2 ) {
  print " USAGE:\n";
  print "   $0 [-i valgrind log file] [-o output suppressions file]\n";
  exit 1;
}

foreach $argnum (0 .. $#ARGV) {
  print $argnum."\n";
  if (lc($ARGV[$argnum]) eq "-i") {
    $logfile = $ARGV[$argnum+1];
  }
  elsif (lc($ARGV[$argnum]) eq "-o") {
    $suppfile = $ARGV[$argnum+1];
  }
}
print $logfile."\n";
print $suppfile."\n";

open INPUT, $logfile or die "Can't open raw valgrind log file!";
open OUTPUT, ">$suppfile" or die "Can't open suppressions file!";

while (<INPUT>) {
  chomp;
  if ( !(/==\d+==/ or /--\d+--/) ) { print OUTPUT $_."\n"; }
}

