use strict;
use warnings;
use Test::More tests => 4;
use HeapSorter;

my $sorter = HeapSorter->new;

isa_ok($sorter, "HeapSorter");

is_deeply( $sorter->_create_heap([5, 8, -10, 100, 3], 0), [-10, 3, 5, 100, 8]); 
is_deeply( $sorter->_create_heap([5, 8, -10, 100, 3], 1), [5, 3, -10, 100, 8]); 

is_deeply( $sorter->sort([5, 8, -10, 100, 3]), [-10, 3, 5, 8, 100]);
