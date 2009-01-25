package MusicBrainz::Edit;
use Moose;
use Moose::Util::TypeConstraints;

use DateTime;
use DateTime::Duration;
use Readonly;

=head1 NAME

MusicBrainz::Edit - represent edits to the database at a higher level

=head1 DESCRIPTION

L<MusicBrainz::Schema::Result::Edit> implements a Perl interface to the
C<moderation> table. However, the data in this table is serialized, and
this module provides a higher level interface to the data.

=head1 CONSTANTS

=head2 Edit Status

Possible states a moderation can be in are:

=cut

Readonly::Scalar our $STATUS_OPEN              => 1;
Readonly::Scalar our $STATUS_APPLIED           => 2;
Readonly::Scalar our $STATUS_REJECTED          => 3;
Readonly::Scalar our $STATUS_FAILED_DEPENDANCY => 4;
Readonly::Scalar our $STATUS_ERROR             => 5;
Readonly::Scalar our $STATUS_PREREQUSITE       => 6;
Readonly::Scalar our $STATUS_REJECTED_NO_VOTES => 7;
Readonly::Scalar our $STATUS_PENDING_CANCEL    => 8;
Readonly::Scalar our $STATUS_CANCELLED         => 9;

=head1 METHODS

=head2 edit

The actual moderation row. You probably won't need to access this directly,
as the following methods are automatically added, that make use of this:

=over 4

=item yes_votes

The amount of 'yes' votes this edit received

=item no_votes

The amount of 'no' votes this edit received

=item open_time

When the edit opened for voting

=item close_time

When the edit was closed

=item expire_time

When the edit would expire due to insufficient votes

=item status

The status of this edit (see L<Edit Status>).

=back

=cut

subtype 'Edit'
    => as 'Object'
    => where {
        $_->isa('MusicBrainz::Schema::Result::Edit::Open') or
        $_->isa('MusicBrainz::Schema::Result::Edit::Closed')
    };

has 'edit' => (
    isa => 'Edit',
    is  => 'ro',
    handles => {
        yes_votes   => 'yesvotes',
        no_votes    => 'novotes',
        open_time   => 'opentime',
        close_time  => 'closetime',
        expire_time => 'expirestime',
        status      => 'status',
        editor      => 'editor',
    },
    builder => '_new_edit',
    required => 1,
    lazy => 1,
);

=head2 schema

=cut

has 'schema' => (
    isa => 'MusicBrainz::Schema',
    is  => 'ro',
    required => 1,
);

=head2 approve

Approve this edit, and apply it to the database

=cut

sub approve {
    my $self = shift;

    eval { $self->on_approval };

    if ($@) {
        # Something went wrong approving the moderation
        $self->edit->status($STATUS_ERROR);
    } else {
        $self->edit->status($STATUS_APPLIED);
    }

    # Move to moderation_closed etc
    # Update expiry date
}

=head2 on_approval

The action to perform on approval of this edit.

Override in sub-classes, and perform database interfaction here

=cut

sub on_approval {
    my $self = shift;
    my $class = ref $self;
    die "$class did implement on_approval!";
}

sub new_value { die 'override' }
sub prev_value { die 'override' }

sub BUILD {
    my ($self, $params) = @_;

    unless ($self->edit->in_storage) {
        die "Cannot create Edit without editor"
            unless $params->{editor};

        die "Cannot create Edit without artist"
            unless $params->{artist};

        $self->edit->set_from_related('editor' => $params->{editor});
        $self->edit->set_from_related('artist' => $params->{artist});
    }
}

sub _new_edit {
    my ($self) = @_;

    my $edit = $self->schema->resultset('Edit::Open')->new({
        tab  => $self->table,
        col  => $self->column,
        type => $self->type,
    });
    return $edit;
}

sub _serialize {
    my ($self, $what) = @_;
    return ref $what eq 'HASH'
        ? map { $_ . "=" . $what->{$_} } keys %$what
        : $what;
}

sub insert {
    my $self = shift;

    $self->edit->newvalue($self->_serialize($self->new_value));
    $self->edit->prevvalue($self->_serialize($self->previous_value));
    $self->edit->rowid($self->row_id);
    $self->edit->status($STATUS_OPEN);
    $self->edit->expiretime(DateTime->now + DateTime::Duration->new(days => 7));

    return $self->edit->insert;
}

1;
