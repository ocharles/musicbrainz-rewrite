package MusicBrainz::Utils;

use strict;
use warnings;

use Sub::Exporter;
Sub::Exporter::setup_exporter({
    exports => [qw/ valid_uuid /]
});

sub valid_uuid {
    my $uuid = shift;

    defined($uuid) and not ref($uuid)
        or return;
    length($uuid) eq 36
        or return;

    $uuid =~ /[^0-]/
        or return;

    $uuid = lc $uuid;
    $uuid =~ /\A(
        [0-9a-f]{8}
        - [0-9a-f]{4}
        - [0-9a-f]{4}
        - [0-9a-f]{4}
        - [0-9a-f]{12}
        )\z/x
        or return;

    return 1;
}

1;