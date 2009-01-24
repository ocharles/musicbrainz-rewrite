package MusicBrainz::Server::Form::Search::Simple;
use Form::Moose;

form_name 'search-simple';

field 'query' => (
    constraints => [ 'SingleLine' ],
    required => 1,
    label => 'Query',
);

field 'type' => (
    constraints => [ {
        Option => [
            artist => 'Artist',
            label => 'Label',
            release => 'Release',
            track => 'Track',
            editor => 'Editor',
        ]
    } ],
    required => 1,
    label => 'Search Type'
);

field 'enable_advanced';

1;
