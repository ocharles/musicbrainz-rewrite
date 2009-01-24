package MusicBrainz::Schema::Result::DiscID;

use strict;
use warnings;

use base 'DBIx::Class';

use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('cdtoc');
__PACKAGE__->add_columns(qw/
  discid freedbid id trackcount leadoutoffset trackoffset degraded
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(release_tocs => 'MusicBrainz::Schema::Result::ReleaseCDToc', 'cdtoc');

sub duration
{
    my $self = shift;
    return $self->leadoutoffset / 75 * 1000;
}

1;
