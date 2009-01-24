package MusicBrainz::Server::Controller::Root;

use strict;
use warnings;

use base 'Catalyst::Controller';
__PACKAGE__->config->{namespace} = '';

use MusicBrainz::Server::Form::Editor::Login;
use MusicBrainz::Server::Form::Search::Simple;

=head1 NAME

MusicBrainz::Server::Controller::Root - Root Controller for MusicBrainz

=head1 DESCRIPTION

Handle any generic pages such as the landing page

=head1 METHODS

=cut

=head2 index

Landing page, server at /

=cut

sub index :Path :Args(0)
{
    my ($self, $c) = @_;
}

=head2 default

Served if the URL could not be matched against anything else.
Generally means 404.

=cut

sub default :Path
{
    my ($self, $c) = @_;
    $c->detach('do_404');
}

=head2 do_404

Throw a 404 error and stop processing.

=cut

sub do_404 : Private
{
    my ($self, $c) = @_;

    $c->stash->{template} = 'error/404.tt';
    $c->response->status(404);
    $c->detach;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;
    $c->stash->{forms}->{sidebar}->{login}  = MusicBrainz::Server::Form::Editor::Login->new;
    $c->stash->{forms}->{sidebar}->{search} = MusicBrainz::Server::Form::Search::Simple->new;
}

=head2 css

Renders the CSS stylesheets. We use an action so we can use a TT template

=cut

sub css : Path('/main.css') {
    my ($self, $c) = @_;
    $c->response->content_type('text/css');
    $c->stash->{template} = 'css/main.tt';
}

=head1 AUTHOR

Oliver Charles

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
