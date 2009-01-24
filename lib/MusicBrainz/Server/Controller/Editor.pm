package MusicBrainz::Server::Controller::Editor;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub login : Private
{
    my ($self, $c) = @_;

    return 1
        if $c->user_exists;

    use MusicBrainz::Server::Form::Editor::Login;
    my $form = MusicBrainz::Server::Form::Editor::Login->new();

    $c->stash->{template} = 'editor/login.tt';
    $c->stash->{form}     = $form;

    $c->session->{__login_dest} = $c->req->uri
        unless defined $c->session->{__login_dest};

    $c->detach unless $form->submitted_and_validated($c->req->params);

    if( !$c->authenticate({ username => $form->username->clean,
                            password => $form->password->clean }) )
    {
        $form->add_general_error('Username/password combination invalid');
        $c->detach;
    }
    else
    {
        if ($form->value('remember_me'))
        {
        }
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

1;
