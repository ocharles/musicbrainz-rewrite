package MusicBrainz::Schema::Artist;

use strict;
use warnings;

use base 'DBIx::Class';

use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('artist');
__PACKAGE__->add_columns(qw/
    id name gid modpending sortname resolution begindate
    enddate type quality modpending_qual
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(releases => 'MusicBrainz::Schema::Release', 'artist');

Readonly::Scalar our $ARTIST_TYPE_UNKNOWN => 0;
Readonly::Scalar our $ARTIST_TYPE_PERSON  => 1;
Readonly::Scalar our $ARTIST_TYPE_GROUP   => 2;

my %artist_type_names = (
    $ARTIST_TYPE_UNKNOWN => [ 'Unknown', 'Begin Date', 'End Date' ],
    $ARTIST_TYPE_PERSON  => [ 'Person', 'Born', 'Deceased' ],
    $ARTIST_TYPE_GROUP   => [ 'Group', 'Founded', 'Dissolved' ],
);

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

Readonly::Scalar our $QUALITY_UNKNOWN        => -1;
Readonly::Scalar our $QUALITY_UNKNOWN_MAPPED => 1;
Readonly::Scalar our $QUALITY_LOW            => 0;
Readonly::Scalar our $QUALITY_NORMAL         => 1;
Readonly::Scalar our $QUALITY_HIGH           => 2;

Readonly::Hash our %QUALITY_NAMES => (
    $QUALITY_LOW    => 'low',
    $QUALITY_NORMAL => 'default',
    $QUALITY_HIGH   => 'high',
);

sub quality_name {
    my $self = shift;

    my $quality = $self->quality;
    $quality = $QUALITY_UNKNOWN_MAPPED if $quality == $QUALITY_UNKNOWN;
    return $QUALITY_NAMES{$quality};
}

1;
