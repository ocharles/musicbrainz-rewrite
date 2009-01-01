package MusicBrainz::Server::Controller::Root;

use strict;
use warnings;

use base 'Catalyst::Controller';
__PACKAGE__->config->{namespace} = '';

use MusicBrainz::Server::Form::Editor::Login;
use MusicBrainz::Server::Form::Search::Simple;

use Form::Moose::Renderer::Paragraphs;

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
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;
    $c->stash->{login_form} = MusicBrainz::Server::Form::Editor::Login->new;
    $c->stash->{sidebar_search} = MusicBrainz::Server::Form::Search::Simple->new;
    $c->stash->{object_link} = sub {
        my ($object, $action_name, @args) = @_;
        
        my $object_name = ref $object;
        my ($controller_name) = ($object_name =~ /.*::([A-Za-z]+)/);

        my $action = $c->controller($controller_name)->action_for($action_name)
            or die "$object_name does not have an $action_name action";
            
        my $id = $object->can('gid') ? $object->gid : $object->id;
        
        return $c->uri_for($action, [ $id ], @args);
    };
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
