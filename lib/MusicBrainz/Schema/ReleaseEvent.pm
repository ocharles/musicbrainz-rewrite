package MusicBrainz::Schema::ReleaseEvent;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('release');
__PACKAGE__->add_columns(qw/
    id barcode catno releasedate format album
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_one('country' => 'MusicBrainz::Schema::Country');
__PACKAGE__->has_one('label'   => 'MusicBrainz::Schema::Label');
__PACKAGE__->belongs_to('release' => 'MusicBrainz::Schema::Release', 'album');

1;
