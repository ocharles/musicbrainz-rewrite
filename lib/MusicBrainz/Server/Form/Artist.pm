package MusicBrainz::Server::Form::Artist;
use Form::Moose;

field 'name' => (
    constraints => [qw/ SingleLine /]
);

field 'sortname' => (
    constraints => [qw/ SingleLine /]
);

1;