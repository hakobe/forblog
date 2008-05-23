use inc::Module::Install;
name 'SVN-Parse';
all_from 'lib/SVN/Parse.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
