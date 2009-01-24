package MusicBrainz::Schema::Result::Country;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core PK::Auto /);
__PACKAGE__->table('country');
__PACKAGE__->add_columns(qw/
    id isocode name
/);
__PACKAGE__->set_primary_key('id');

1;
