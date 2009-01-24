package MusicBrainz::Schema::Result::Artist;
use Moose;

extends 'DBIx::Class', 'Moose::Object';
with 'MusicBrainz::Role::Quality';

use Data::UUID;
use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('artist');
__PACKAGE__->add_columns(qw/
    id name gid modpending sortname resolution begindate
    enddate type quality modpending_qual page
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(releases => 'MusicBrainz::Schema::Result::Release', 'artist');
__PACKAGE__->has_many(aliases  => 'MusicBrainz::Schema::Result::Alias::Artist', 'ref');

__PACKAGE__->has_many(
    artist_subscribed_editors => 'MusicBrainz::Schema::Result::Subscribe::Artist', 'artist'
);
__PACKAGE__->many_to_many(subscribed_editors => 'artist_subscribed_editors', 'editor');

Readonly::Scalar our $ARTIST_TYPE_UNKNOWN => 0;
Readonly::Scalar our $ARTIST_TYPE_PERSON  => 1;
Readonly::Scalar our $ARTIST_TYPE_GROUP   => 2;

my %artist_type_names = (
    $ARTIST_TYPE_UNKNOWN => [ 'Unknown', 'Begin Date', 'End Date' ],
    $ARTIST_TYPE_PERSON  => [ 'Person', 'Born', 'Deceased' ],
    $ARTIST_TYPE_GROUP   => [ 'Group', 'Founded', 'Dissolved' ],
);

sub new {
    my ($class, $attrs) = @_;

    $attrs->{gid} = lc Data::UUID->new->create_str
        unless defined $attrs->{foo};

    return $class->next::method($attrs);
}

sub type_name
{
    my $self = shift;
    return $artist_type_names{$self->type}->[0];
}

sub begin_date_label
{
    my $self = shift;
    return $artist_type_names{$self->type}->[1];
}

sub end_date_label
{
    my $self = shift;
    return $artist_type_names{$self->type}->[2];
}

sub merge_into {
    my ($self, $destination) = @_;

    $self->aliases->update({ ref => $destination->id });
    $self->releases->update({ artist => $destination->id });

    $self->delete;
}

sub annotations {
    my ($self) = @_;
    my $schema = $self->result_source->schema;
    $schema->resultset('Annotation')->for_artist($self);
}

1;
