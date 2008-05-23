package SVN::Parse;
use Moose;
use 5.8.1;
use version;our $VERSION = '0.0.1';

use XML::LibXML;
use SVN::Parse::Result;
use SVN::Parse::Log;
use Data::Dumper;

sub parse {
    my ($class, $xml) = @_;

    if (!$xml) {
        return SVN::Parse::Result->new;
    }

    my $xml_parser = XML::LibXML->new;
    my $doc = $xml_parser->parse_string($xml);

    my $logs = SVN::Parse::Log->parse(
        ($doc->findnodes("//log"))[0]
    );

    return SVN::Parse::Result->new(logs => $logs);
}

1;
__END__

=head1 NAME

SVN::Parse -

=head1 SYNOPSIS

  use SVN::Parse;

=head1 DESCRIPTION

SVN::Parse is

=head1 AUTHOR

Yohei Fushii E<lt>hakobe@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
