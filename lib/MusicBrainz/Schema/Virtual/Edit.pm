package MusicBrainz::Schema::Virtual::Edit;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core InflateColumn::DateTime /);
__PACKAGE__->table('moderation_');
__PACKAGE__->add_columns(qw/
    id moderator automod prevvalue newvalue yesvotes novotes type status
    artist tab col rowid
/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_columns(
    expiretime => { data_type => 'timestamp' },
    closetime => { data_type => 'timestamp' },
    opentime => { data_type => 'timestamp' },
);

__PACKAGE__->belongs_to(artist => 'MusicBrainz::Schema::Result::Artist');
__PACKAGE__->belongs_to(editor => 'MusicBrainz::Schema::Result::Editor', 'moderator');

1;