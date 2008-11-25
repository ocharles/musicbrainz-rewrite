package MusicBrainz::Schema::ReleaseEvent;

use strict;
use warnings;

use base 'DBIx::Class';

use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('release');
__PACKAGE__->add_columns(qw/
    id barcode catno releasedate format album country label
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('country' => 'MusicBrainz::Schema::Country', 'country');
__PACKAGE__->belongs_to('label'   => 'MusicBrainz::Schema::Label', 'label');

__PACKAGE__->belongs_to('release' => 'MusicBrainz::Schema::Release', 'album');

Readonly::Scalar our $RELEASE_FORMAT_CD           => 1;
Readonly::Scalar our $RELEASE_FORMAT_DVD          => 2;
Readonly::Scalar our $RELEASE_FORMAT_SACD         => 3;
Readonly::Scalar our $RELEASE_FORMAT_DUALDISC     => 4;
Readonly::Scalar our $RELEASE_FORMAT_LASERDISC    => 5;
Readonly::Scalar our $RELEASE_FORMAT_MINIDISC     => 6;
Readonly::Scalar our $RELEASE_FORMAT_VINYL        => 7;
Readonly::Scalar our $RELEASE_FORMAT_CASSETTE     => 8;
Readonly::Scalar our $RELEASE_FORMAT_CARTRIDGE    => 9;
Readonly::Scalar our $RELEASE_FORMAT_REEL_TO_REEL => 10;
Readonly::Scalar our $RELEASE_FORMAT_DAT          => 11;
Readonly::Scalar our $RELEASE_FORMAT_DIGITAL      => 12;
Readonly::Scalar our $RELEASE_FORMAT_OTHER        => 13;
Readonly::Scalar our $RELEASE_FORMAT_WAX_CYLINDER => 13;
Readonly::Scalar our $RELEASE_FORMAT_PIANO_ROLL   => 14;

Readonly::Scalar our $LAST_RELEASE_FORMAT         => 15;

my %release_format_names = (
   1 => 'CD',
   2 => 'DVD',
   3 => 'SACD',
   4 => 'DualDisc',
   5 => 'LaserDisc',
   6 => 'MiniDisc',
   7 => 'Vinyl',
   8 => 'Cassette',
   9 => 'Cartridge (4/8-tracks)',
   10 => 'Reel-to-reel',
   11 => 'DAT',
   12 => 'Digital Media',
   13 => 'Other',
   14 => 'Wax Cylinder',
   15 => 'Piano Roll',
);

sub format_name
{
    my $self = shift;
    return $release_format_names{$self->format};
}

1;
