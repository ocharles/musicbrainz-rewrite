package MusicBrainz::Server::Model::Search;

use strict;
use warnings;

use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config(
    class => 'MusicBrainz::Search',
    search_server => 'search.musicbrainz.org',
);

sub prepare_arguments {
    my $self = shift;

    return {
        external_server => $self->config->{search_server}
    };
}

1;