package MusicBrainz::Schema::Result::Editor;

use strict;
use warnings;

use base 'DBIx::Class';

use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('moderator');
__PACKAGE__->add_columns(qw/
    id name password email weburl bio modsaccepted modsrejected membersince
    automodsaccepted modsfailed privs
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(preferences => 'MusicBrainz::Schema::Result::UserPreference', 'moderator');

sub preference {
    my ($self, $key) = @_;
 
    my $value = $self->preferences->single({ name => $key });
    $value = defined $value ? $value 
           : MusicBrainz::Schema::Result::UserPreference->default_preference($key);

    return $value;
}

Readonly::Scalar our $AUTOMOD_FLAG           => 1;
Readonly::Scalar our $BOT_FLAG               => 2;
Readonly::Scalar our $UNTRUSTED_FLAG         => 4;
Readonly::Scalar our $LINK_MODERATOR_FLAG    => 8;
Readonly::Scalar our $DONT_NAG_FLAG          => 16;
Readonly::Scalar our $WIKI_TRANSCLUSION_FLAG => 32;
Readonly::Scalar our $MBID_SUBMITTER_FLAG    => 64;
Readonly::Scalar our $ACCOUNT_ADMIN_FLAG     => 128;

sub is_auto_editor      { (shift->privs & $AUTOMOD_FLAG) > 0; }
sub is_bot              { (shift->privs & $BOT_FLAG) > 0; }
sub is_untrusted        { (shift->privs & $UNTRUSTED_FLAG) > 0; }
sub is_link_moderator   { (shift->privs & $LINK_MODERATOR_FLAG) > 0; }
sub is_wiki_transcluder { (shift->privs & $WIKI_TRANSCLUSION_FLAG) > 0; }
sub is_mbid_submitter   { (shift->privs & $MBID_SUBMITTER_FLAG) > 0; }
sub is_account_admin    { (shift->privs & $ACCOUNT_ADMIN_FLAG) > 0; }

1;