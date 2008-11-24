package MusicBrainz::Model::Search;

use strict;
use warnings;

use base 'Catalyst::Model';

use Data::Page;
use LWP::UserAgent;
use POSIX qw/ floor /;
use URI::Escape qw/ uri_escape /
;

__PACKAGE__->config(
    search_server => 'search.musicbrainz.org',
);

=head1 NAME

MusicBrainz::Model::Search - handle searching for entities that
cannot be found with simple database queries

=head1 DESCRIPTION

This module handles more advanced searching, such as finding data
via MusicBrainz external search servers

=head1 METHODS

=head2 external_search $query, $type, $offset?, $per_page?

Search for an entity using the external search servers.

C<$query> is the search query to search for. C<$type> is the
type of entity to search for. C<$offset> and C<$per_page>
control the offset of the data searched, and the amount of
results to return per a page.

Returns the status of the search, and if it was sucessful also
results the data on the requested page, as well an L<Data::Page>
instance about the data received.

=cut

sub external
{
    my $self = shift;
    my ($query, $type, $offset, $per_page) = @_;

    # Sane defaults
    $offset ||= 0;
    $per_page ||= 25;

    my $ua = LWP::UserAgent->new;
    $ua->env_proxy;
    $ua->timeout(2);

    my $search_url = sprintf("http://%s/ws/1/%s/?query=%s&offset=%s&max=%s",
                             $self->config->{search_server},
                             $type,
                             uri_escape($query),
                             $offset,
                             $per_page);

    my $response = $ua->get($search_url);
    if ($response->is_success)
    {
        my $results = $response->content;
        $results =~ s/\.html//g;

        my ($redirect, $total_hits);
        if ($results =~ /<!--\s+(.*?)\s+-->/s)
        {
            my $comments = $1;

            use Switch;
            foreach my $comment (split(/\n/, $comments))
            {
                my ($key, $value) = split(/=/, $comment, 2);

                switch ($key)
                {
                    case ('hits')     { $total_hits = $value; }
                    case ('redirect') { $redirect   = $value; }
                }
            }
        }

        my $page = Data::Page->new;
        $page->total_entries($total_hits);
        $page->entries_per_page($per_page);
        $page->current_page(floor($offset / $per_page) + 1);

        return ($response->code, $results, $page);
    }
    else
    {
        return $response->code;
    }
}
