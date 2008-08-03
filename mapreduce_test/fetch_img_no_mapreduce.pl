use strict;
use warnings;
use URI;
use URI::Fetch;
use Web::Scraper;

my $img_scraper = scraper {
    process 'img', 'urls[]' => '@src';
    result 'urls';
};

my %all_urls = ();

while ( chomp(my $site = <>) ) {
    my $urls = $img_scraper->scrape( URI->new($site) );

    for my $url (@$urls) {
        $all_urls{$url} ||= [];
        push @{ $all_urls{$url} }, $site;
    }
}

for my $key (keys %all_urls) {
    my $url = URI->new($key);
    my $name = ($url->path_segments)[-1];
    next if $name !~ m/\.jpg$/xms;

    my $res = URI::Fetch->fetch( $url );

    open my $fh, '>', "$name"
        or die "File open error: $!";
    print $fh $res->content;
    close $fh;
}
