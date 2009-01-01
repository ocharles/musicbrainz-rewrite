package MusicBrainz::Server;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use parent qw/Catalyst/;

use Catalyst qw/
-Debug
ConfigLoader
Static::Simple

StackTrace

Session
Session::State::Cookie
Session::Store::FastMmap

Authentication
/;

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in musicbrainz.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'MusicBrainz::Server',
    'View::Default' => {
        TEMPLATE_EXTENSION => '.tt',
        PLUGIN_BASE        => 'MusicBrainz::Server::Plugin',
    },
);

__PACKAGE__->config->{'Plugin::Authentication'} = {
    default_realm => 'moderators',
    realms => {
        moderators => {
            credential => {
                class => 'Password',
                password_field => 'password',
                password_type => 'clear'
            },
            store => {
                class => 'DBIx::Class',
                user_model => 'MainDB::Editor',
            }
        }
    }
};

# Start the application
__PACKAGE__->setup();


=head1 NAME

MusicBrainz - Catalyst based application

=head1 SYNOPSIS

    script/musicbrainz_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<MusicBrainz::Server::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
