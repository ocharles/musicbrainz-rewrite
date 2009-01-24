package MusicBrainz::Schema::Result::Alias::Artist;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('artistalias');
__PACKAGE__->add_columns(qw/ id name ref /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('label' => 'MusicBrainz::Schema::Result::Artist', 'ref');

1;
