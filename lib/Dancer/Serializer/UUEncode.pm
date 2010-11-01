use strict;
use warnings;
package Dancer::Serializer::UUEncode;
# ABSTRACT: UU Encoding serializer for Dancer

use Carp;
use base 'Dancer::Serializer::Abstract';

sub init {
    my ($self) = @_;
    $self->loaded;
}

sub loaded {
    require Storable;
    Storable->import('nfreeze');
}

sub serialize {
    my ( $self, $entity ) = @_;

    return pack( 'u', nfreeze $entity );
}

sub deserialize {
    my ( $self, $content ) = @_;
    my $data = thaw( unpack( 'u', $content ) );

    defined $data or croak "Couldn't thaw unpacked content '$content'";

    return $data;
}

sub content_type {'text/uuencode'}

# helpers
sub from_uuencode {
    my ($uuencode) = @_;
    my $s = Dancer::Serializer::UUEncode->new;

    return $s->deserializer($uuencode);
}

sub to_uuencode {
    my ($data) = @_;
    my $s = Dancer::Serializer::UUEncode->new;

    return $s->serialize($data);
}

1;

__END__

