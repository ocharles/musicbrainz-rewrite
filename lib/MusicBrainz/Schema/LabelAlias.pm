package MusicBrainz::Schema::LabelAlias;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('labelalias');
__PACKAGE__->add_columns(qw/
    id name timesused modpending lastused ref
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('label' => 'MusicBrainz::Schema::Label', 'ref');

1;
