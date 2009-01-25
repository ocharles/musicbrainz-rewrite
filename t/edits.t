use strict;
use warnings;
use Test::More tests => 7;

BEGIN {
    use_ok('MusicBrainz::Schema');
    use_ok('MusicBrainz::Edit::Artist');
}

my $schema = MusicBrainz::Schema->connect('DBI:Pg:dbname=musicbrainz_db_test', 'musicbrainz_user');

$schema->txn_begin;

my $artist = $schema->resultset('Artist')->create({
    name     => 'Test artist',
    sortname => 'Test artist',
    page     => 0,
});
my $editor = $schema->resultset('Editor')->create({
    name => 'Fake Editor',
    password => 'whatever',
});

my $edit = MusicBrainz::Edit::Artist->new({
    artist    => $artist,
    editor    => $editor,
    schema    => $schema,

    name      => 'Test Artist',
    sortname  => 'Artist, Test',
});

ok(!$edit->edit->in_storage, 'edit should *not* be in the database yet!');

my $edit_db = $edit->insert;
ok(defined $edit_db);
isa_ok($edit_db, 'MusicBrainz::Schema::Virtual::Edit');

$edit->approve;

is($artist->name, 'Test Artist');
is($artist->sortname, 'Artist, Test');

$schema->txn_rollback;