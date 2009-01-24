package MusicBrainz::Schema::Result::Subscribe::Artist;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('moderator_subscribe_artist');
__PACKAGE__->add_columns(qw/id moderator artist/);

__PACKAGE__->belongs_to(editor => 'MusicBrainz::Schema::Result::Editor', 'moderator');
__PACKAGE__->belongs_to(artist => 'MusicBrainz::Schema::Result::Artist');

1;