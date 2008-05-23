use strict;
use Test::More qw(no_plan);

use SVN::Parse;
use Perl6::Slurp;

my $data = slurp \*DATA;
my $result = SVN::Parse->parse($data);

my $logs = $result->logs;
is(2, scalar(@$logs));

my $log1 = shift @$logs;
isa_ok($log1, "SVN::Parse::Log");
is($log1->revision, 104);
is($log1->author, "yohei");
is($log1->date, DateTime->new(
    year => 2008, month => 4, day=> 10,
    hour => 3, minute => 7, second => 8));
is_deeply(
    $log1->paths,
    [qw(
        /bus/trunk/bus.cgi    
    )],
);

my $log2 = shift @$logs;
isa_ok($log2, "SVN::Parse::Log");
is($log2->revision, 95);
is($log2->author, "yohei");
is($log2->date, DateTime->new(
    year => 2008, month => 2, day=> 4,
    hour => 12, minute => 22, second => 13));
is_deeply(
    $log2->paths,
    [qw(
        /bus/trunk/bus_data/rits_minakusa/weekday.yaml
        /bus/trunk/bus.cgi
        /bus/trunk/bus_data/rits_minakusa/vacation.yaml
        /bus/trunk/data_gen_tool/gen_rits_minakusa_table.pl
    )],
);

__DATA__
<?xml version="1.0"?>
<log>
<logentry
   revision="104">
<author>yohei</author>
<date>2008-04-10T03:07:08.073534Z</date>
<paths>
<path
   action="M">/bus/trunk/bus.cgi</path>
</paths>
<msg>Fix to treat summer and spring vacation.</msg>
</logentry>
<logentry
   revision="95">
<author>yohei</author>
<date>2008-02-04T12:22:13.531792Z</date>
<paths>
<path
   action="M">/bus/trunk/bus_data/rits_minakusa/weekday.yaml</path>
<path
   action="M">/bus/trunk/bus.cgi</path>
<path
   action="M">/bus/trunk/bus_data/rits_minakusa/vacation.yaml</path>
<path
   action="M">/bus/trunk/data_gen_tool/gen_rits_minakusa_table.pl</path>
</paths>
<msg>Updated bus for timetable changing at 2008/02/01</msg>
</logentry>
</log>
