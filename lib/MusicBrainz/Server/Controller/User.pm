package MusicBrainz::Server::Controller::User;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub login :Local
{
    my ($self, $c) = @_;

    if ($c->authenticate({ name     => $c->req->params->{username},
                           password => $c->req->params->{password} }))
    {
        $c->response->redirect($c->req->referer);
    }
    else
    {
        $c->error("Could not authenticate");
    }
}

sub logout :Local
{
    my ($self, $c) = @_;

    $c->logout;
    $c->response->redirect($c->req->referer);
}

1;
