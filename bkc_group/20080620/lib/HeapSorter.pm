package HeapSorter;
use Moose;
use YAML;

sub sort {
    my ($self, $array) = @_;
    my $sorted = [];
    while (@$array) {
        $array = $self->_create_heap($array, 0);
        push @$sorted, shift @$array;
    }
    return $sorted;
}

sub _create_heap {
    my ($self, $array, $root) = @_;

    my $n = $root + 1;
    my $left  = ( 2 * $n )     - 1;
    my $right = ( 2 * $n ) + 1 - 1;

    if ( $array->[$left] && !$array->[$right] ) {
        if ($array->[$root] > $array->[$left]) {
            $self->_swap($array, $root, $left);
        }
    }
    elsif ( $array->[$left] && $array->[$right]) {
        $array = $self->_create_heap($array, $left);
        $array = $self->_create_heap($array, $right);

        my $smaller = $array->[$left] <= $array->[$right] ? $left : $right;

        if ( $array->[$smaller] < $array->[$root] ) {
            $self->_swap($array, $root, $smaller);
        }
    }

    return $array;
}

sub _swap {
    my ($self, $array, $n, $m) = @_;
    ($array->[$n], $array->[$m]) = ($array->[$m], $array->[$n]);
}

1;
