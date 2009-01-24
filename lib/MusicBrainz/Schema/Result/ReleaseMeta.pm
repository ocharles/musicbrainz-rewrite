package MusicBrainz::Schema::Result::ReleaseMeta;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table("albummeta");
__PACKAGE__->add_columns(qw/
    id tracks discids puids firstreleasedate lastupdate
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(release => 'MusicBrainz::Schema::Result::Release', 'id');

1;
