use lib::setup 'MyRootIsHere', 'lib', 'lib', 'elib/xpto/lib';

print join("\0", @INC);
