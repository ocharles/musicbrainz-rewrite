package MusicBrainz::Edit::Artist;
use Moose;
extends 'MusicBrainz::Edit';

=head1 NAME

MusicBrainz::Edit::Artist - edit an existing artist

=head1 DESCRIPTION

Allows you to edit columns of an artist

=head1 METHODS

=head2 artist

The artist being edited

=cut

has 'artist' => (
    is       => 'rw',
    required => 1,
);

has [qw/ name sortname /] => (
    is => 'rw',
    isa => 'Str'
);

sub table  { 'artist' }
sub column { 'name' }
sub type   { 40 }
sub row_id { shift->artist->id }

sub on_approval {
    my $self = shift;
    my %update = map { $_ => $self->$_ } $self->_changed_fields;
    $self->artist->update(\%update);
}

sub new_value {
    my $self = shift;
    return {
        map { $_ => $self->$_ }
            $self->_changed_fields;
    };
}

sub previous_value {
    my $self = shift;
    return {
        map { $_ => $self->artist->$_ }
            $self->_changed_fields;
    };
}

sub _changed_fields {
    my $self = shift;
    return grep {
        my $old = $self->artist->$_ || '';
        (defined $self->$_) && ($self->$_ ne $old);
    } qw/ name sortname /;
}

1;
