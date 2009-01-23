package MusicBrainz::Server::Form::Search::Simple;
use Form::Moose;

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

1;
