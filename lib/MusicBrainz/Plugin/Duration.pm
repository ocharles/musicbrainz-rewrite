package MusicBrainz::Plugin::Duration;

use strict;
use warnings;

use base 'Template::Plugin';

sub new
{
    return sub {
        my $duration = shift;

        my $length_in_secs = int($duration / 1000.0 + 0.5);
	sprintf ("%d:%02d",
                 int($length_in_secs / 60),
                 ($length_in_secs % 60));
    }
}

1;
