package MusicBrainz::Controller::Root;

use strict;
use warnings;

use base 'Catalyst::Controller';
__PACKAGE__->config->{namespace} = '';

=head1 NAME

MusicBrainz::Controller::Root - Root Controller for MusicBrainz

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

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Oliver Charles

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
