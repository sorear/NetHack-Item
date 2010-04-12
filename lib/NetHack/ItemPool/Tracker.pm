package NetHack::ItemPool::Tracker;
use Moose;
use Set::Object;
with 'NetHack::ItemPool::Role::HasPool';

# A Tracker represents a set of items that NHI can prove are the same type.
# This proof can be done in three ways; by identifying them and seeing them
# with the same identity, by generic #naming one and seeing the name on the
# other, or by seeing that they have the same appearance which is not a
# generic appearance (gray stone, lamp, whistle, runed broadsword, conical
# hat, bag, horn, flute, drum, harp, Amulet of Yendor, egg, tin, more if
# blind).
#
# Since we only use sharing to propagate knowledge, it's not neccessary to
# share trackers with only one possibility, this allows some simplification
# by not actually implementing the same-identity share.
#
# When an object is created, it receives an unshared tracker with the
# information from the object; when the object's appearance, identity, or
# generic_name are set, the information goes to the tracker.  When a tracker
# sees appearance or generic_name, it contacts the Trackers meta-object in
# the pool, which returns the canonical tracker for that, and merges with it.
#
# As an optimization, if we know the appearance or name of an object when it
# is created, it is directly connected to the canonical tracker and no
# unshared tracker is generated.

use Module::Pluggable (
    search_path => __PACKAGE__,
    require     => 1,
    sub_name    => 'tracker_types',
);

has type => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has subtype => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_subtype',
);

has appearance => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has '+pool' => (
    required => 1,
    handles  => [qw/trackers/],
);

has _possibilities => (
    is       => 'ro',
    isa      => 'Set::Object',
    init_arg => 'possibilities',
    required => 1,
    handles => {
        rule_out             => 'remove',
        includes_possibility => 'includes',
    },
);

has all_possibilities => (
    is       => 'ro',
    isa      => 'Set::Object',
    required => 1,
);

sub BUILD {
    my $self = shift;

    my $class = __PACKAGE__ . '::' . ucfirst($self->type);
    Class::MOP::load_class($class);
    $class->meta->rebless_instance($self);
}

around BUILDARGS => sub {
    my $orig = shift;
    my $args = $orig->(@_);

    $args->{all_possibilities} = Set::Object->new(@{ $args->{all_possibilities} });
    $args->{possibilities} = Set::Object->new(@{ $args->{all_possibilities} });

    return $args;
};

sub possibilities {
    my @possibilities = shift->_possibilities->members;
    return @possibilities if !wantarray;
    return sort @possibilities;
}

sub identify_as {
    my $self     = shift;
    my $identity = shift;

    confess "$identity is not a possibility for " . $self->appearance
        unless $self->includes_possibility($identity);

    $self->rule_out(grep { $_ ne $identity } $self->possibilities);
}

sub rule_out_all_but {
    my $self = shift;
    my %include = map { $_ => 1 } @_;

    for ($self->possibilities) {
        $self->rule_out($_) unless $include{$_};
    }
}

around rule_out => sub {
    my $orig = shift;
    my $self = shift;

    for my $possibility (@_) {
        next if $self->all_possibilities->includes($possibility);
        confess "$possibility is not included in " . $self->appearance . "'s set of all possibilities.";
    }

    $self->$orig(@_);

    for my $possibility (@_) {
        $self->trackers->ruled_out($self => $possibility);
    }

    if ($self->possibilities == 1) {
        $self->trackers->identified($self => $self->possibilities);
    }
    elsif ($self->possibilities == 0) {
        confess "Ruled out all possibilities for " . $self->appearance . "!";
    }
};

__PACKAGE__->meta->make_immutable;
no Moose;

# need to delay this until after this class is already immutable, or else the
# subclasses get broken constructors
__PACKAGE__->tracker_types; # load all

1;

