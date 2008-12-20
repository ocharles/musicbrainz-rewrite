package MusicBrainz::Server::Controller::Search;

use strict;
use warnings;

use base 'Catalyst::Controller';

sub external : Local
{
    my ($self, $c) = @_;

    my $query = $c->req->query_params->{query};
    my $type  = $c->req->query_params->{type};

    my ($code, $results, $paginator) = $c->model('Search')->external($query, $type);

    if ($code eq 200)
    {
        $c->stash->{results}   = $results;
        $c->stash->{paginator} = $paginator;
    }
    else
    {
        $c->stash->{template} = "search/error$code.tt";
    }
}

1;
