package MusicBrainz::Schema::Result::ReleaseCDToc;

use strict;
use warnings;

use base 'DBIx::Class';

use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('album_cdtoc');
__PACKAGE__->add_columns(qw/
    id album cdtoc modpending
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(release  => 'MusicBrainz::Schema::Result::Release', 'album');
__PACKAGE__->belongs_to(disc_id  => 'MusicBrainz::Schema::Result::DiscID', 'cdtoc');

1;
