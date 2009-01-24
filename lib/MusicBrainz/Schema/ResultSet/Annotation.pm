package MusicBrainz::Schema::ResultSet::Annotation;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

use Carp;

sub for_artist {
    my ($self, $artist) = @_;
    $self->_for_entity($artist, 1);
}

sub for_release {
    my ($self, $release) = @_;
    $self->_for_entity($release, 2);
}

sub for_label {
    my ($self, $label) = @_;
    $self->_for_entity($label, 3);
}

sub for_track {
    my ($self, $track) = @_;
    $self->_for_entity($track, 4);
}

sub _for_entity {
    my ($self, $entity, $type) = @_;
    $self->search_rs({
        rowid => $entity->id,
        type  => $type,
    }, { order_by => 'id DESC' });
}

sub create_artist_annotation {
    my ($self, $opts) = @_;
    return $self->_create($opts, 1, 'artist');
}

sub create_release_annotation {
    my ($self, $opts) = @_;
    return $self->_create($opts, 2, 'release');
}

sub create_label_annotation {
    my ($self, $opts) = @_;
    return $self->_create($opts, 3, 'label');
}

sub create_track_annotation {
    my ($self, $opts) = @_;
    return $self->_create($opts, 4, 'track');
}

sub _create {
    my ($self, $opts, $type, $key) = @_;

    croak "Cannot create an annotation without an editor"
        unless defined $opts->{editor};

    $self->create({
        rowid      => $opts->{$key}->id,
        text       => $opts->{text},
        changelog  => $opts->{changelog} || '',
        moderator  => $opts->{editor}->id,
        moderation => $opts->{moderation},
        type       => $type,
    });
}

sub latest {
    shift->first;
}

1;