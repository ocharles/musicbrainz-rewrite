package MusicBrainz::Controller::Artist;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub load :Chained('/') PathPart('artist') :CaptureArgs(1)
{
    my ($self, $c, $mbid) = @_;

    $c->stash->{artist} = $c->model('MainDB::Artist')->find({ gid => $mbid });
}

sub show :Chained('load') :PathPart('')
{
    my ($self, $c) = @_;
}

1;
