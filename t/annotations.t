use strict;
use warnings;

use Data::UUID;
use Test::More tests => 29;

BEGIN { use_ok('MusicBrainz::Schema'); }
my $schema = MusicBrainz::Schema->connect('DBI:Pg:dbname=musicbrainz_db_test', 'musicbrainz_user');

# Integrity
my $annotations_rs = $schema->resultset('Annotation');
my $artist_rs = $schema->resultset('Artist');
my $label_rs = $schema->resultset('Label');
my $release_rs = $schema->resultset('Release');
my $track_rs = $schema->resultset('Track');
my $editor_rs = $schema->resultset('Editor');

clean_up();

my $artist = $artist_rs->create({
    name => 'Foo',
    sortname => 'Foo',
    page => 0,
    gid => lc Data::UUID->new->create_str,
});

my $release = $artist->create_related('releases', {
    name => 'Test Release',
    gid => lc Data::UUID->new->create_str,
    page => 0,
});

my $label = $label_rs->create({
    name => 'Test label',
    sortname => 'Test Label',
    gid => lc Data::UUID->new->create_str,
    page => 0,
});

my $editor = $editor_rs->create({
    name => 'Test Editor',
    password => 'foo',
});

my $track = $track_rs->create({
    name => 'Test Track',
    gid => lc Data::UUID->new->create_str,
    artist => $artist->id,
});

my $mod_counter = 0;

annotate($artist, 'artist', 1);
annotate($release, 'release', 2);
annotate($label, 'label', 3);
annotate($track, 'track', 4);

clean_up();

sub annotate {
    my ($object, $type, $t) = @_;

    my $create = "create_${type}_annotation";
    can_ok($annotations_rs, $create);
    my $annotation = $annotations_rs->$create({
        $type => $object,
        text => 'My annotation',
        editor => $editor,
        moderation => $mod_counter++
    });
    is($annotation->type, $t, "not a $type annotation");

    my $newer_annotation = $annotations_rs->$create({
        $type => $object,
        text => 'My annotation',
        editor => $editor,
        moderation => $mod_counter++
    });
    is($newer_annotation->type, $t, "not a $type annotation");

    # Helper methods
    can_ok($object, 'annotations');
    isa_ok($object->annotations, 'MusicBrainz::Schema::ResultSet::Annotation');
    is($object->annotations->count, 2, "$type should have 2 annotations");
    is($object->annotations->latest->id, $newer_annotation->id, "$type latest is incorrect");
}

sub clean_up {
    $editor_rs->delete;
    $annotations_rs->delete;
    $label_rs->delete;
    $track_rs->delete;
    $release_rs->delete;
    $artist_rs->delete;
}