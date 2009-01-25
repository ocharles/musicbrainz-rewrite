package MusicBrainz::Server::Controller::Artist;

use strict;
use warnings;

use base 'Catalyst::Controller';

use MusicBrainz::Server::Form::Artist;

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

sub edit : Chained('load') PathPart {
    my ($self, $c) = @_;

    my $form = MusicBrainz::Server::Form::Artist->new;
    $c->stash->{form} = $form;

    return unless $form->submitted_and_validated($c->req->params);

    use MusicBrainz::Edit::Artist;
    MusicBrainz::Edit::Artist->new({
        schema   => $c->stash->{artist}->result_source->schema,
        artist   => $c->stash->{artist},
        editor   => $c->user->_user,
        name     => $form->name->dirty,
        sortname => $form->sortname->dirty,
    })->insert;
}

1;
