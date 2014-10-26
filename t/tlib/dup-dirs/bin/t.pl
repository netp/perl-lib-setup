use lib::setup undef, 'lib', 'lib';

print join("\0", @INC);
