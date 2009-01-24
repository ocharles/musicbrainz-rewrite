package MusicBrainz::Schema::Result::UserPreference;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('moderator_preference');
__PACKAGE__->add_columns(qw/ id moderator name value /);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(editor => 'MusicBrainz::Schema::Result::Editor', 'moderator');

use Readonly;
Readonly::Hash our %DEFAULT_PREFERENCES => (
    subscriptions_public => 1,
);

sub default_preference {
    my ($class, $key) = @_;
    
    return $DEFAULT_PREFERENCES{$key};
}

1;