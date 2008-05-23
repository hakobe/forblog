use strict;
use Test::More qw(no_plan);

use SVN::Parse;

my $parser = SVN::Parse->new;
isa_ok($parser, "SVN::Parse");

my $result = $parser->parse("");
isa_ok($result, "SVN::Parse::Result");
