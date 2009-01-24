package MusicBrainz::Schema::Result::Track;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('track');
__PACKAGE__->add_columns(qw/
    id gid name modpending artist length
/,);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('artist' => 'MusicBrainz::Schema::Result::Artist');
__PACKAGE__->has_many('track_releases' => 'MusicBrainz::Schema::Result::ReleaseTrack');

1;
