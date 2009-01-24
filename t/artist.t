use strict;
use warnings;

use Data::UUID;
use MusicBrainz::Utils qw/ valid_uuid /;
use Test::More tests => 14;
use Test::Exception;

BEGIN { use_ok('MusicBrainz::Schema'); }

my $schema = MusicBrainz::Schema->connect('DBI:Pg:dbname=musicbrainz_db_test', 'musicbrainz_user');
my $annotation_rs = $schema->resultset('Annotation');
my $alias_rs      = $schema->resultset('Alias::Artist');
my $release_rs    = $schema->resultset('Release');
my $artist_rs     = $schema->resultset('Artist');

$schema->txn_begin;

# Create test data
my ($source, $target) = create_artists();

# Do the merge
can_ok($source, 'merge_into');
lives_ok { $source->merge_into($target) } 'could not merge';

# Check artists
is($artist_rs->count, 1, 'still have 2 aritsts');
ok(!defined $artist_rs->find($source->id), 'source still exists');
ok(defined $artist_rs->find($target->id), 'couldnt find target');

# Check aliases
is($alias_rs->count, 2, 'should have 2 aliases');
is($target->aliases->count, 2, 'should have 2 aliases');

# Check releases
is($target->releases->count, 2, 'should have 2 releases');

# Clean up
$schema->txn_rollback;

sub cleanup {
    $alias_rs->delete;
    $annotation_rs->delete;
    $release_rs->delete;
    $artist_rs->delete;
}

sub create_artists {
    my $source = create_artist('Source Artist');
    my $target = create_artist('Dest Artist');

    is($artist_rs->count, 2, 'confused about artist count');

    return ($source, $target);
}

sub create_artist {
    my $name = shift;

    my $artist = $artist_rs->create({
        name     => $name,
        sortname => $name,
        page     => 0,
    });

    isnt($artist->gid, '', 'no mbid');
    ok(valid_uuid($artist->gid), 'invalid mbid');

    $artist->create_related('releases', {
        name     => 'Test Release',
        gid      => lc Data::UUID->new->create_str,
        page     => 0,
    });

    $artist->create_related('aliases', { name => "$name alias" });

    return $artist
}