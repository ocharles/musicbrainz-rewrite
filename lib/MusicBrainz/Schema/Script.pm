package MusicBrainz::Schema::Script;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('script');
__PACKAGE__->add_columns(qw/
    id isocode isonumber name frequency
/);
__PACKAGE__->set_primary_key('id');

1;
