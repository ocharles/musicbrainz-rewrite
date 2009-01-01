package MusicBrainz::Schema::Editor;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('moderator');
__PACKAGE__->add_columns(qw/id name password email/);
__PACKAGE__->set_primary_key('id');

1;