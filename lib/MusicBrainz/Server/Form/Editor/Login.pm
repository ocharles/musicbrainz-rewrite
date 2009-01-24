package MusicBrainz::Server::Form::Editor::Login;
use Form::Moose;

form_name 'user-login';

field 'username' => (
    required => 1,
    constraints => [ 'SingleLine' ],
    label => 'User name',
);

field 'password' => (
    required => 1,
    constraints => [ 'SingleLine' ],
    label => 'Password',
);

1;
