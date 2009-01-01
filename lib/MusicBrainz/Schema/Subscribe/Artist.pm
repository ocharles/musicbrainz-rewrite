package MusicBrainz::Schema::Subscribe::Artist;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('moderator_subscribe_artist');
__PACKAGE__->add_columns(qw/id moderator artist/);

__PACKAGE__->belongs_to(editor => 'MusicBrainz::Schema::Editor', 'moderator');
__PACKAGE__->belongs_to(artist => 'MusicBrainz::Schema::Artist');

1;