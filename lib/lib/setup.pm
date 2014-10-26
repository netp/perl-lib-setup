package lib::setup;

# ABSTRACT: flexible @INC setup
our $VERSION = '0.001'; # VERSION
our $AUTHORITY = 'cpan:MELO'; # AUTHORITY

use strict;
use warnings;
use Path::Tiny ();

sub import {
  my (undef, $files, @dirs) = @_;
  undef $files if $files and ref($files) eq 'ARRAY' and !@$files;
  $files = ['.git', 'Makefile.PL', 'BUILD.PL', 'MANIFEST'] unless $files;
  $files = [$files] unless ref($files);

  push @dirs, 'lib' unless @dirs;

  return _setup_lib($files, @dirs);
}


sub _setup_lib {
  my ($files, @dirs) = @_;

  my $root = _find_project_root($files);
  return unless $root;    ## TODO: show warning in this case?

  my %current_libs = map { Path::Tiny::path($_)->realpath->stringify => 1 } @INC;
  for (reverse @dirs) {
    my $d = $root->child($_)->realpath->stringify;
    next if not -d $d or exists $current_libs{$d};
    unshift @INC, $current_libs{$d} = $d;
  }
}

sub _find_project_root {
  my $c = Path::Tiny::path($FindBin::Bin)->realpath->parent;

  while (!$c->is_rootdir) {
    for (@{ $_[0] }) {
      return $c if $c->child($_)->exists;
    }
  }

  return;
}

1;

__END__

=pod

=encoding UTF-8

=for :stopwords Pedro Melo ACKNOWLEDGEMENTS cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 NAME

lib::setup - flexible @INC setup

=head1 VERSION

version 0.001

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

If a directory to be added is already there, we will not added it again. L<lib::setup> uses L<File::Spec::realpath()

=encoding utf-8

=head1 STATUS

This module status is: Alpha, Extreme-DogFooding.

Alpha means that the interface is still subject to change. Extreme
DogFooding means that the author is using this module on a production
environement where real money is involved.

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

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc lib::setup

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/lib-setup>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/l/lib-setup>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=lib-setup>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=lib::setup>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/lib-setup>

=back

=head2 Email

You can email the author of this module at C<MELO at cpan.org> asking for help with any problems you have.

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web interface at L<https://github.com/melo/perl-lib-setup/issues>. You will be automatically notified of any progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/melo/perl-lib-setup>

  git clone git://github.com/melo/perl-lib-setup.git

=head1 AUTHOR

Pedro Melo <melo@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Pedro Melo.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
