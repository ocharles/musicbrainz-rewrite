package MusicBrainz::Server::Form::Editor::Login;
use Form::Moose;

field 'user_name' => (
    required => 1,
    constraints => [ 'SingleLine' ],
    widget => 'Text',
    label => 'User name',
);

field 'password' => (
    required => 1,
    constraints => [ 'SingleLine' ],
    widget => 'Text',
    label => 'Password',
);

1;
