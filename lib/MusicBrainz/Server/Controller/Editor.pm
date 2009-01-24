package MusicBrainz::Server::Controller::Editor;

use strict;
use warnings;

use base 'Catalyst::Controller';

use MusicBrainz::Server::Form::Editor::Login;

sub login : Private
{
    my ($self, $c) = @_;
    return 1 if $c->user_exists;

    my $form = MusicBrainz::Server::Form::Editor::Login->new();

    $c->stash->{template} = 'editor/login.tt';
    $c->stash->{form}     = $form;

    $c->session->{__login_dest} = $c->req->uri
        unless defined $c->session->{__login_dest};

    $c->detach unless $form->submitted_and_validated($c->req->params);

    if( !$c->authenticate({ name     => $form->username->dirty,
                            password => $form->password->dirty }) )
    {
        $form->add_general_error('Username/password combination invalid');
        $c->detach;
    }
    else
    {
        # In - remember me cookie
    }

    $c->response->redirect(delete $c->session->{__login_dest});
    $c->detach;
}

sub login_form : Local Path('login')
{
    my ($self, $c) = @_;

    $c->detach('profile', [ $c->user->name ])
        if $c->user_exists;

    $c->session->{__login_dest} = $c->req->referer
        unless defined $c->session->{__login_dest};

    $c->forward('login');
}

sub logout :Local
{
    my ($self, $c) = @_;

    $c->logout;
    $c->response->redirect($c->req->referer);
}

sub user : Chained('/') PathPart('editor') CaptureArgs(1) {
    my ($self, $c, $name) = @_;
    $c->stash->{user} = $c->model('MainDB::Editor')->find({ name => $name });
}

sub profile : Chained('user') { }

1;
