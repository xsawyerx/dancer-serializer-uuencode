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
    Storable->import( qw/ nfreeze thaw / );
}

sub serialize {
    my ( $self, $entity ) = @_;

    return pack( 'u', nfreeze($entity) );
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

    return $s->deserialize($uuencode);
}

sub to_uuencode {
    my ($data) = @_;
    my $s = Dancer::Serializer::UUEncode->new;

    return $s->serialize($data);
}

1;

__END__

=head1 SYNOPSIS

    # in your Dancer app:
    setting serializer => 'UUEncode';

    # or in your Dancer config file:
    serializer: 'UUEncode'

=head1 DESCRIPTION

This serializer serializes your data structure to UU Encoding. Since UU Encoding
is just encoding and not a serialization format, it first freezes it using
L<Storable> and only then serializes it.

It uses L<Storable>'s C<nfreeze> function.

=head1 SEE ALSO

The Dancer Advent Calendar 2010.
