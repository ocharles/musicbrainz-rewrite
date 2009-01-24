use strict;
use warnings;
use Test::More tests => 2;

BEGIN { use_ok 'Catalyst::Test', 'MusicBrainz::Server' }
SKIP: {
    skip 'set TEST_CATALYST to enable this test', 1 unless $ENV{TEST_CATALYST};
    ok( request('/')->is_success, 'Request should succeed' );
}
