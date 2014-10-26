package lib::setup;

# ABSTRACT: flexible @INC setup
# VERSION
# AUTHORITY

use strict;
use warnings;

1;

=encoding utf-8

=head1 SYNOPSIS

    ## Automagically setup @INC for you
    use lib::setup;

    ## Default is
    use lib::setup ['.git', 'Makefile.PL', 'BUILD.PL', 'MANIFEST'], 'lib';

=head1 DESCRIPTION

L<lib::setup> uses a set of (tweakable) heuristics to find your C<< lib/
>> directory.

Starting on C<< $FindBin::Bin >> directory, it will search upwards
through the directory tree, looking for a set of marker files that
designate the root of your project. Then, a set of directories relative
to this directory is prepend to C<< @INC >> .

The default set of files that L<lib::setup> searches for is:

=over 4

=item * .git

=item * Makefile.PL

=item * BUILD.PL

=item * MANIFEST

=back

The default set of directories that L<lib::setup> will add, relative to
the project root, is:

=over 4

=item * lib/

=back

You can override this by passing arguments to the C<< use lib::setup >>
statement.

The first argument is either a scalar or a list of scalars, and it tells
L<lib::setup> which files to look for.

The rest of the arguments is a list of relative directory paths that
will be added to C<@INC>.

=head1 EXTENDING

You may want to create your own L<lib::setup> project-specific rule set.

The current recommended way of doing this is to create your own package like this:

    package my::lib::setup;
    
    use strict;
    use lib::setup ();
    
    sub import {
      @_ = (... your parameters go here...);
      goto &lib::setup::import;
    }
    
    1;
