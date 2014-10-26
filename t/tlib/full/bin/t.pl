use lib::setup 'MyRootIsHere', 'lib', 'lib', 'elib/xpto/lib', 'no_such_dir/for/real';

print join("\0", @INC);
