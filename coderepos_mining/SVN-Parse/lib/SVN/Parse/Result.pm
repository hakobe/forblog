package SVN::Parse::Result;
use Moose;

has logs => (
    is  => 'ro',
    isa => 'ArrayRef',
    default => sub { [] },
);


1;
