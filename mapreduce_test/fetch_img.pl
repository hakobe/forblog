package FetchImg::Mapper;
use Moose;
use URI;
use Web::Scraper;
with 'MapReduce::Lite::Mapper';

my $img_scraper = scraper {
    process 'img', 'urls[]' => '@src';
    result 'urls';
};

sub map {
    my ($self, $key, $value) = @_;
    my $urls = $img_scraper->scrape( URI->new($value) );

    for my $url (@$urls) {
        $self->emit($url, $value);
    };
}

package FetchImg::Reducer;
use Moose;
use URI::Fetch;

with 'MapReduce::Lite::Reducer';

sub reduce {
    my ($self, $key, $values) = @_;

    my $url  = URI->new($key);
    my $name = ($url->path_segments)[-1];
    return if $url !~ m/\.jpg$/xms;

    my $res = URI::Fetch->fetch( $url );

    open my $fh, '>', "$name"
        or die "File open error: $!";
    print $fh $res->content;
    close $fh;

    $self->emit($key, $values->to_a);
}

1;

package main;
use MapReduce::Lite;

my $spec = MapReduce::Lite::Spec->new(intermidate_dir => "/tmp");

for (@ARGV) {
    my $in = $spec->create_input;
    $in->file($_);
    $in->mapper('FetchImg::Mapper');
}

$spec->out->reducer('FetchImg::Reducer');
$spec->out->num_tasks(3);

mapreduce($spec);
