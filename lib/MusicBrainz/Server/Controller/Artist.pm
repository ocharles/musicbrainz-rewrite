package MusicBrainz::Server::Controller::Artist;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub load :Chained('/') PathPart('artist') :CaptureArgs(1)
{
    my ($self, $c, $mbid) = @_;

    $c->stash->{artist} = $c->model('MainDB::Artist')->single({ gid => $mbid });
}

sub show :Chained('load') :PathPart('')
{
    my ($self, $c) = @_;

    $c->stash->{releases} = [ $c->stash->{artist}->releases(undef, {
        join     => 'meta',
        order_by => [ 'meta.firstreleasedate', 'name' ],
    }) ];
}

sub aliases :Chained('load') :PathPart { }
sub details :Chained('load') :PathPart { }
sub subscribers :Chained('load') :PathPart { }

1;
