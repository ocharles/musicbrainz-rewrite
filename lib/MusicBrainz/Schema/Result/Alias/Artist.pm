package MusicBrainz::Schema::Result::Alias::Artist;

use strict;
use warnings;

use base 'MusicBrainz::Schema::Virtual::Alias';

__PACKAGE__->table('artistalias');
__PACKAGE__->belongs_to('label' => 'MusicBrainz::Schema::Result::Artist', 'ref');

1;
