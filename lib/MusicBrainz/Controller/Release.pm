package MusicBrainz::Controller::Release;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub load :Chained('/') :PathPart('release') :CaptureArgs(1)
{
    my ($self, $c, $mbid) = @_;

    $c->stash->{release} = $c->model('MainDB::Release')->find({ gid => $mbid });
}

sub show :Chained('load') :PathPart('')
{
    my ($self, $c) = @_;
}

1;
