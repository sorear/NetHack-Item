#!/usr/bin/env perl
use lib 't/lib';
use Test::NetHack::Items (
    "n - a dwarvish mithril-coat" => {
        ac => 6,
        mc => 3,
    },
    "n - a +1 dwarvish mithril-coat" => {
        ac => 7,
        mc => 3,
    },
    "m - a cornuthaum" => {
        ac => 0,
        mc => 2,
    },
    "l - a mummy wrapping" => {
        ac => 0,
        mc => 1,
    },
);

