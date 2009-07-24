#!/usr/bin/env perl
use lib 't/lib';
use constant testing_method => 'greatest_erosion';
use Test::NetHack::Items (
    "a - a thoroughly corroded +1 long sword"        => 3,
    "f - a rusty pick-axe"                           => 1,
    "m - a very rusty dwarvish mattock"              => 2,
    "E - a blessed rusty corroded +1 mace"           => 1,
    "h - a very burnt rotted +0 robe (being worn)"  => 2,
    "p - a fixed crysknife (weapon in hand)"         => 0,
    "x - a rusty very corroded knife named Puddingbane" => 2,
    "z - the +7 Grayswandir (in quiver)"             => 0,
);
