#!/bin/bash
perl -i -e '
my $insert_string = $ARGV[1] . "\n";

splice(@ARGV, 1, 1);

undef $/;
$_ = <>;
pos($_) = 0;
while (m/\\fixed c\s*\{/g) {
  my $pos = pos($_) - 1;
  my $depth = 1;

#counter for hvor mange rekursive paranteser
  
  while ($depth > 0 && m/([{}])/g) {
    $depth++ if $1 eq "{";
    $depth-- if $1 eq "}";
  }
  if ($depth == 0) {
    my $end_pos = pos($_) - 1;
    substr($_, $end_pos, 0, $insert_string);
    pos($_) = $end_pos + length($insert_string);
  }
}
print;
' "$1" "$2"
#puts string (arg 2) right before the end of a score block in file (arg 1)
