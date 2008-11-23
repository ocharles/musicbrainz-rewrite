package MusicBrainz::Schema::Track;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('track');
__PACKAGE__->add_columns(qw/
    id gid name length modpending artist
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('artist' => 'MusicBrainz::Schema::Artist');

1;
