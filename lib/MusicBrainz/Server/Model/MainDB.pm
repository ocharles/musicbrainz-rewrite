package MusicBrainz::Server::Model::MainDB;

use strict;
use warnings;

use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'MusicBrainz::Schema',
    connect_info => [
        "DBI:Pg:dbname=musicbrainz_db",
        "musicbrainz_user",
    ]
);

1;
