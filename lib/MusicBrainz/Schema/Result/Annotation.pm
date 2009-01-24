package MusicBrainz::Schema::Result::Annotation;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('annotation');
__PACKAGE__->add_columns(qw/
    id moderator type rowid text changelog created moderation
/);
__PACKAGE__->set_primary_key('id');

1;