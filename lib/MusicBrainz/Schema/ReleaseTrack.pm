package MusicBrainz::Schema::ReleaseTrack;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('albumjoin');
__PACKAGE__->add_columns(qw/
    id sequence album track
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('release' => 'MusicBrainz::Schema::Release', 'album');
__PACKAGE__->belongs_to('track'   => 'MusicBrainz::Schema::Track', 'track');

1;
