package MusicBrainz::Schema::Result::Language;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('language');
__PACKAGE__->add_columns(qw/
    id isocode_3t isocode_3b isocode_2 name frequency
/);
__PACKAGE__->set_primary_key('id');

1;
