package MusicBrainz::Server::Controller::Label;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub load :Chained('/') :PathPart('label') :CaptureArgs(1)
{
    my ($self, $c, $mbid) = @_;

    $c->stash->{label} = $c->model('MainDB::Label')->single({ gid => $mbid });
}

sub show :Chained('load') :PathPart('')
{
    my ($self, $c) = @_;
}

1;
