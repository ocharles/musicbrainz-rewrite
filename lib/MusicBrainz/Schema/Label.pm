package MusicBrainz::Schema::Label;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('label');
__PACKAGE__->add_columns(qw/
    id gid name modpending labelcode sortname resolution
    begindate enddate type
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(release_events => 'MusicBrainz::Schema::ReleaseEvent', 'label');
__PACKAGE__->many_to_many(releases => 'release_events', 'release', { order_by => [ 'releasedate' ] });

1;
