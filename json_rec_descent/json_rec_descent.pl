use strict;
use warnings;
use Parse::RecDescent;
use Perl6::Say;
use YAML ();
use Test::More qw(no_plan);

sub p {
    say YAML::Dump @_;
}


my $grammer = q#
    {
        my %ESCAPED = (
            '\\\\"' => '"', '\\\\\\\\' => '\\\\', '\\\\/' => '/', '\\\\b' => "\\b",
            '\\\\f' => "\\f", '\\\\n' => "\\n", '\\\\r' => "\\r", '\\\\t' => "\\t",
        );
        my $escape = sub {
            $_[0] =~ s{\\\\(?:[\"\\\\\\/bfnrt]|u([0-9a-fA-F]{4}))/}{
                $1 ? chr(hex($1)): $ESCAPED{$&};
            }ge;
            $_[0];
        };
    }

    JSON       : value
    value      : string
               | atom
               | '[' array                             { $return = $item[2] }
               | '{' object                            { $return = $item[2] }
    array      : ']'                                   { $return = [] }
               |     element array_cdr                 { unshift @{$item[2]},   $item[1];   $return = $item[2] }
    array_cdr  : ']'                                   { $return = [] }
               | ',' element array_cdr                 { unshift @{$item[2+1]}, $item[1+1]; $return = $item[2+1] }
    element    : value
    object     : '}'                                   { $return = {} }
               |     member object_cdr                 { $return = { %{ $item[2] }   , %{ $item[1]} } }
    object_cdr : '}'                                   { $return = {} }
               | ',' member object_cdr                 { $return = { %{ $item[2+1] } , %{ $item[1+1]} } }
    member     : key ':' value                         { $return = { $item[1] => $item[3] } }
    key        : string
               | identifier
    atom       : number | 'true' | 'false' | 'null'
    string     : '"' /[^\\x00-\\x1f\\"\\\\]*(?:\\\\(?:[\\"\\\\\\/bfnrt]|u[0-9a-fA-F]{4})[^\\x00-\\x1f\\"\\\\]*)*/ '"'  
               { $return = $escape->($item[2]) }
               | "'" /[^\\x00-\\x1f\\'\\\\]*(?:\\\\(?:[\\'\\\\\\/bfnrt]|u[0-9a-fA-F]{4})[^\\x00-\\x1f\\'\\\\]*)*/ "'"  
               { $return = $escape->($item[2]) }
    number     : /-?(?:0|[1-9]\\d*)(?:\\.\\d+)?(?:[eE][+-]\\d+)?/
    identifier : /[_a-zA-Z][_a-zA-Z0-9]*/
#;

my $parser = Parse::RecDescent->new($grammer);

is_deeply( 
    $parser->JSON(q([{ x : ["aaa", -10.5, 'puu', '手乗りタイガー']}, 1])),
    [
        {
            x => [ "aaa", -10.5, "puu", "手乗りタイガー"]
        },
        1,
    ]
);
