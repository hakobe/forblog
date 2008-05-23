package SVN::Parse::Log;
use Moose;
use Moose::Autobox;
use Data::Dumper;
use DateTime::Format::Strptime;

has author => (
    is => "ro",
    isa => "Str"
);

has revision => (
    is => "ro",
    isa => "Int",
);

has date => (
    is => "ro",
    isa => "DateTime",
);

has paths => (
    is => "ro",
);

sub parse {
    my($class, $nodes) = @_;

    my $strp = DateTime::Format::Strptime->new(
        pattern => "%Y-%m-%dT%H:%M:%S",
    );
    my $result = [];
    for my $logentry ($nodes->findnodes("logentry")) {
        push @$result, $class->new(
            revision => $logentry->getAttribute("revision"),
            author   => $logentry->findvalue("author"),
            date     => $strp->parse_datetime($logentry->findvalue("date")), 
            paths    => [$logentry->findnodes("paths/path")]
                ->map(sub { $_->textContent; }),
        );
    }

    return $result;
}

1;
