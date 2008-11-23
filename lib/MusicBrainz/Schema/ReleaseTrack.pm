package MusicBrainz::Schema::ReleaseTrack;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('albumjoin');
__PACKAGE__->add_columns(qw/
    id sequence artist
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('artist' => 'MusicBrainz::Schema::Artist');
__PACKAGE__->has_one('language'  => 'MusicBrainz::Schema::Language');
__PACKAGE__->has_one('script'    => 'MusicBrainz::Schema::Script');

1;
