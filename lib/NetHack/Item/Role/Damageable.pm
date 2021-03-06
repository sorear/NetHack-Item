package NetHack::Item::Role::Damageable;
use Moose::Role;
use List::Util qw(max);

has [qw/burnt corroded rotted rusty/]=> (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

sub damaged {
    my $self = shift;

    return max($self->burnt, $self->corroded, $self->rotted, $self->rusty);
}

has proofed => (
    traits    => [qw/Bool IncorporatesUndef/],
    is        => 'rw',
    isa       => 'Bool',
    handles   => {
        proof   => 'set',
        unproof => 'unset',
    },
);

for my $damage (qw/burnt corroded rotted rusty/) {
    with 'NetHack::Item::Role::IncorporatesStats' => {
        attribute => $damage,
    };
}

with 'NetHack::Item::Role::IncorporatesStats' => {
    attribute    => 'proofed',
    defined_stat => 1,
};

sub remove_damage {
    my $self = shift;
    $self->$_(0) for qw/burnt corroded rotted rusty/;
}

sub greatest_erosion {
    my $self = shift;

    return max map { $self->$_ } qw/burnt corroded rotted rusty/;
}

no Moose::Role;

1;

