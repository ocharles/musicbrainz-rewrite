package MusicBrainz::Role::Quality;
use Moose::Role;

use Readonly;
Readonly::Scalar our $QUALITY_UNKNOWN        => -1;
Readonly::Scalar our $QUALITY_UNKNOWN_MAPPED => 1;
Readonly::Scalar our $QUALITY_LOW            => 0;
Readonly::Scalar our $QUALITY_NORMAL         => 1;
Readonly::Scalar our $QUALITY_HIGH           => 2;

Readonly::Hash our %QUALITY_NAMES => (
    $QUALITY_LOW    => 'low',
    $QUALITY_NORMAL => 'default',
    $QUALITY_HIGH   => 'high',
);

sub quality_name {
    my $self = shift;

    my $quality = $self->quality;
    $quality = $QUALITY_UNKNOWN_MAPPED if $quality == $QUALITY_UNKNOWN;
    return $QUALITY_NAMES{$quality};
}

1;