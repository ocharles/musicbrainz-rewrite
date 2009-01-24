package MusicBrainz::Schema::Result::Alias::Label;

use strict;
use warnings;

use base 'MusicBrainz::Schema::Virtual::Alias';

__PACKAGE__->table('labelalias');
__PACKAGE__->belongs_to('label' => 'MusicBrainz::Schema::Result::Label', 'ref');

1;
