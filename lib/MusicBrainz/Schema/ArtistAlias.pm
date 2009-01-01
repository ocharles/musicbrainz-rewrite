package MusicBrainz::Schema::ArtistAlias;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('artistalias');
__PACKAGE__->add_columns(qw/
    id name modpending lastused ref
/);
__PACKAGE__->add_columns(timesused => { accessor => 'times_used' });
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('artist' => 'MusicBrainz::Schema::Artist', 'ref');

1;
