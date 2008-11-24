package MusicBrainz::Schema::Artist;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('artist');
__PACKAGE__->add_columns(qw/
    id name gid modpending sortname resolution begindate
    enddate type quality modpending_qual
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(releases => 'MusicBrainz::Schema::Release', 'artist');

1;
