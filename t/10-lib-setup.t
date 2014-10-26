#!perl

use strict;
use warnings;
use Test::More;
use Path::Tiny;

subtest('Test ' . $_->basename, sub { run_test_case($_) }) for scan_for_test_cases();

done_testing();

sub run_test_case {
  my ($t) = @_;
  my $cmd = $t->child('bin/t.pl');
  my @got = split(/\0/, `$^X $cmd`);
  my @expected = map { chomp; $_ } $t->child('matches.lst')->lines;

  for my $e (@expected) {
    if ($e =~ s/^!//) { unlike($got[0], qr{.*/$e$}, "didn't match '$e'") }
    else {
      like($got[0], qr{.*/$e$}, "matched '$e'");
      shift @got;
    }
  }
}

sub scan_for_test_cases {
  my $p = path('t/tlib');
  return grep { $_->stringify !~ m/^[.]/ and $_->is_dir } $p->children;
}

