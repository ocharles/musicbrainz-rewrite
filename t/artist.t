use strict;
use warnings;

use Data::UUID;
use Test::More tests => 11;
use Test::Exception;

BEGIN { use_ok('MusicBrainz::Schema'); }

my $schema = MusicBrainz::Schema->connect('DBI:Pg:dbname=musicbrainz_db_test', 'musicbrainz_user');
my $alias_rs = $schema->resultset('Alias::Artist');
my $release_rs = $schema->resultset('Release');
my $artist_rs = $schema->resultset('Artist');

# Integrity checks
$alias_rs->delete;
$release_rs->delete;
$artist_rs->delete;

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

sub create_artists {
    my $source = $artist_rs->create({
        name     => 'Source Artist',
        sortname => 'Artist, Source',
        gid      => lc Data::UUID->new->create_str,
        page     => 0,
    });

    my $target = $artist_rs->create({
        name     => 'Dest Artist',
        sortname => 'Artist, Dest',
        gid      => lc Data::UUID->new->create_str,
        page     => 0,
    });

    is($artist_rs->count, 2, 'confused about artist count');

    create_aliases($source, $target);
    create_releases($source);
    create_releases($source);

    return ($source, $target);
}

sub create_aliases {
    my ($source, $target) = @_;

    # Check this is moved
    $source->create_related('aliases', { name => 'Source Alias 1' });

    # Check this is retained
    $target->create_related('aliases', { name => 'Dest Alias 1' });

    is($source->aliases->count, 1, 'confused about alias count');
    is($target->aliases->count, 1, 'confused about alias count');
}

sub create_releases {
    my $artist = shift;

    $artist->create_related('releases', {
        name     => 'Test Release',
        gid      => lc Data::UUID->new->create_str,
        page     => 0,
    });
}