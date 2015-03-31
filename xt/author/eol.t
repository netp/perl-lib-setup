use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.17

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/lib/setup.pm',
    't/00-compile.t',
    't/10-lib-setup.t',
    't/tlib/defaults-1/Makefile.PL',
    't/tlib/defaults-1/bin/t.pl',
    't/tlib/defaults-1/matches.lst',
    't/tlib/dup-dirs/Makefile.PL',
    't/tlib/dup-dirs/bin/t.pl',
    't/tlib/dup-dirs/matches.lst',
    't/tlib/full/MyRootIsHere',
    't/tlib/full/bin/t.pl',
    't/tlib/full/matches.lst'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
