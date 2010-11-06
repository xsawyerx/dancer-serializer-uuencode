#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Test::Fatal;
use Dancer::Serializer::UUEncode;

my $s    = Dancer::Serializer::UUEncode->new;
my $data = $s->serialize( { this => 'will fail' } );

{
    no warnings qw/redefine once/;
    *Dancer::Serializer::UUEncode::thaw = sub { return };
}

like(
    exception { $s->deserialize($data) },
    qr/^Couldn't thaw unpacked content/,
    'Bad thaw throws exception',
);

