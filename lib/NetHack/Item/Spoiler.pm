#!/usr/bin/env perl
package NetHack::Item::Spoiler;
use strict;
use warnings;

use Module::Pluggable search_path => __PACKAGE__, require => 1;

use Memoize;
memoize 'name_to_type_list';
memoize 'possibilities_to_appearances';
memoize 'plurals';
memoize 'plural_of_list';
memoize 'singular_of_list';

# names, appearances, and types {{{
sub name_to_type_list {
    my $self = shift;
    my %all_types;

    for my $class ($self->plugins) {
        my ($type) = map { lc } $class =~ /.*::(.*)$/;

        my $list = $class->list;
        for (values %$list) {
            $all_types{$_->{name}} = $type;
            $all_types{$_} = $type
                for grep { defined }
                    $_->{appearance},
                    @{ $_->{appearances} || [] };
        }

        if ($class->can('extra_names')) {
            for ($class->extra_names) {
                $all_types{$_} = $type;
            }
        }
    }

    return \%all_types;
}

sub name_to_type {
    my $self = shift;
    my $name = shift;

    my $type = $self->name_to_type_list->{$name};

    # handle e.g. "potion called fruit juice"
    $type ||= $name if (__PACKAGE__."::\u\L$name")->can('list');

    return $type;
}
# }}}
# possibilities and appearances {{{
sub possibilities_to_appearances {
    my $self = shift;
    my $list = $self->list;

    my %possibilities;

    for my $stats (values %$list) {
            push @{ $possibilities{$_} }, $stats->{name}
                for grep { defined }
                         $stats->{appearance},
                         @{ $stats->{appearances} };
    }

    return \%possibilities;
}

sub possibilities_for_appearance {
    my $self = shift;
    my $appearance = shift;
    my $possibilities;

    $possibilities = [$appearance] if $self->list->{$appearance};
    $possibilities ||= $self->possibilities_to_appearances->{$appearance};
    $possibilities ||= [];

    return $possibilities;
}
# }}}
# singularize and pluralize {{{
sub plurals {
    my $self = shift;
    my $list = $self->list;
    my %plurals;

    for (values %$list) {
        $plurals{$_->{name}} = $_->{plural}
            if $_->{plural};
    }

    if ($self->can('extra_plurals')) {
        my $extra = $self->extra_plurals;
        @plurals{keys %$extra} = values %$extra;
    }

    return \%plurals;
}

sub plural_of_list {
    my $self = shift;
    my %all_plurals;

    for my $class ($self->plugins) {
        my $plurals = $class->plurals;
        @all_plurals{keys %$plurals} = values %$plurals;
    }

    return \%all_plurals;
}

sub singular_of_list {
    my $self = shift;
    return { reverse %{ $self->plural_of_list } };
}

sub pluralize {
    my $self = shift;
    my $item = shift;

    $self->plural_of_list->{$item};
}

sub singularize {
    my $self = shift;
    my $item = shift;

    $self->singular_of_list->{$item};
}
# }}}
# japanese names {{{
sub japanese_to_english {
    return {
        "wakizashi"       => "short sword",
        "ninja-to"        => "broadsword",
        "nunchaku"        => "flail",
        "naginata"        => "glaive",
        "osaku"           => "lock pick",
        "koto"            => "wooden harp",
        "shito"           => "knife",
        "tanko"           => "plate mail",
        "kabuto"          => "helmet",
        "yugake"          => "leather gloves",
        "gunyoki"         => "food ration",
        "potion of sake"  => "potion of booze",
        "potions of sake" => "potions of booze",
    };
}
# }}}

1;
