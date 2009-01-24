package MusicBrainz::Schema::Virtual::Alias;

use strict;
use warnings;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->add_columns(qw/ id name modpending lastused ref /);
__PACKAGE__->add_columns(timesused => { accessor => 'times_used' });
__PACKAGE__->set_primary_key('id');

1;
