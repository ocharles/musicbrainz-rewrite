use strict;
use warnings;

use Data::UUID;
use Test::More tests => 7;

BEGIN { use_ok('MusicBrainz::Schema'); }
my $schema = MusicBrainz::Schema->connect('DBI:Pg:dbname=musicbrainz_db_test', 'musicbrainz_user');

# Integrity
my $annotations_rs = $schema->resultset('Annotation');
my $artist_rs = $schema->resultset('Artist');
my $editor_rs = $schema->resultset('Editor');

$editor_rs->delete;
$annotations_rs->delete;
$artist_rs->delete;

my $artist = $artist_rs->create({
    name => 'Foo',
    sortname => 'Foo',
    page => 0,
    gid => lc Data::UUID->new->create_str,
});

my $editor = $editor_rs->create({
    name => 'Test Editor',
    password => 'foo',
});

my $annotation = $annotations_rs->create_artist_annotation({
    artist => $artist,
    text => 'My annotation',
    editor => $editor,
    moderation => 1
});
is($annotation->type, 1, 'not an artist annotation');

my $newer_annotation = $annotations_rs->create_artist_annotation({
    artist => $artist,
    text => 'My annotation',
    editor => $editor,
    moderation => 2
});
is($newer_annotation->type, 1, 'not an artist annotation');

# Helper methods
can_ok($artist, 'annotations');
isa_ok($artist->annotations, 'MusicBrainz::Schema::ResultSet::Annotation');
is($artist->annotations->count, 2, 'should have 2 annotations');
is($artist->annotations->latest->id, $newer_annotation->id, 'latest no worky');

$editor_rs->delete;
$annotations_rs->delete;
$artist_rs->delete;