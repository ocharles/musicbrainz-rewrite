package MusicBrainz::Schema::Release;

use strict;
use warnings;

use base 'DBIx::Class';

use Readonly;

__PACKAGE__->load_components(qw/ PK::Auto Core /);
__PACKAGE__->table('album');
__PACKAGE__->add_columns(qw/
    id name gid modpending quality modpending_qual modpending_lang
    artist attributes language script
/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(artist   => 'MusicBrainz::Schema::Artist');
__PACKAGE__->belongs_to(language => 'MusicBrainz::Schema::Language', 'language');
__PACKAGE__->belongs_to(script   => 'MusicBrainz::Schema::Script', 'script');

__PACKAGE__->has_many(release_tocs => 'MusicBrainz::Schema::ReleaseCDToc', 'album');
__PACKAGE__->many_to_many(disc_ids => 'release_tocs', 'disc_id');

__PACKAGE__->has_one(meta => 'MusicBrainz::Schema::ReleaseMeta', 'id');

__PACKAGE__->has_many(release_tracks => 'MusicBrainz::Schema::ReleaseTrack', 'album');
__PACKAGE__->many_to_many(tracks => 'release_tracks', 'track');

sub sequenced_tracks
{
    my $self = shift;
    return $self->tracks({ }, {
        order_by => [ 'sequence' ],
    });
}

Readonly::Scalar our $ALBUM_ATTRIBUTE       => 1;
Readonly::Scalar our $SINGLE_ATTRIBUTE      => 2;
Readonly::Scalar our $EP_ATTRIBUTE          => 3;
Readonly::Scalar our $COMPILATION_ATTRIBUTE => 4;
Readonly::Scalar our $SOUNDTRACK_ATTRIBUTE  => 5;
Readonly::Scalar our $SPOKENWORD_ATTRIBUTE  => 6;
Readonly::Scalar our $INTERVIEW_ATTRIBUTE   => 7;
Readonly::Scalar our $AUDIOBOOK_ATTRIBUTE   => 8;
Readonly::Scalar our $LIVE_ATTRIBUTE        => 9;
Readonly::Scalar our $REMIX_ATTRIBUTE       => 10;
Readonly::Scalar our $OTHER_ATTRIBUTE       => 11;

Readonly::Scalar our $OFFICIAL_ATTRIBUTE       => 100;
Readonly::Scalar our $PROMOTION_ATTRIBUTE      => 101;
Readonly::Scalar our $BOOTLEG_ATTRIBUTE        => 102;
Readonly::Scalar our $PSEUDO_RELEASE_ATTRIBUTE => 103;

my %album_attribute_mapping = (
    0 => [ "Non-Album Track", "Non-Album Tracks", "(Special case)"],
    1 => [ "Album", "Albums", "An album release primarily consists of previously unreleased material. This includes album re-issues, with or without bonus tracks."],
    2 => [ "Single", "Singles", "A single typically has one main song and possibly a handful of additional tracks or remixes of the main track. A single is usually named after its main song."],
    3 => [ "EP", "EPs", "An EP is an Extended Play release and often contains the letters EP in the title."],
    4 => [ "Compilation", "Compilations", "A compilation is a collection of previously released tracks by one or more artists."],
    5 => [ "Soundtrack", "Soundtracks", "A soundtrack is the musical score to a movie, TV series, stage show, computer game etc."],
    6 => [ "Spokenword", "Spokenword", "Non-music spoken word releases."],
    7 => [ "Interview", "Interviews", "An interview release contains an interview with the Artist."],
    8 => [ "Audiobook", "Audiobooks", "An audiobook is a book read by a narrator without music."],
    9 => [ "Live", "Live Releases", "A release that was recorded live."],
    10 => [ "Remix", "Remixes", "A release that was (re)mixed from previously released material."],
    11 => [ "Other", "Other Releases", "Any release that does not fit any of the categories above."],

    100 => [ "Official", "Official", "Any release officially sanctioned by the artist and/or their record company. (Most releases will fit into this category.)"],
    101 => [ "Promotion", "Promotions", "A giveaway release or a release intended to promote an upcoming official release. (e.g. prerelease albums or releases included with a magazine)"],
    102 => [ "Bootleg", "Bootlegs", "An unofficial/underground release that was not sanctioned by the artist and/or the record company."],
    103 => [ "Pseudo-Release", "PseudoReleases", "A pseudo-release is a duplicate release for translation/transliteration purposes."]
);

sub release_status
{
    my $self = shift;
    my @status_attributes = grep { $_ >= 100 && $_ <= 103 } @{$self->attributes};
    return $status_attributes[0];
}

sub release_status_name
{
    my $self = shift;
    my $release_status = $self->release_status;
    return exists $album_attribute_mapping{$release_status} ? $album_attribute_mapping{$release_status}->[0] : 'Unknown';
}

1;
