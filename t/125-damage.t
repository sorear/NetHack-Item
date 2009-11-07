#!/usr/bin/env perl
use lib 't/lib';
use Test::NetHack::Items (
    "a - a +1 elven cloak" => {
        damaged => 0,
        ac      => 2,
    },
    "b - a burnt +1 elven cloak" => {
        damaged => 1,
        ac      => 1,
    },
    "c - a rotted +1 elven cloak" => {
        damaged => 1,
        ac      => 1,
    },
    "d - a burnt rotted +1 elven cloak" => {
        damaged => 1,
        ac      => 1,
    },
    "e - a burnt rotted +0 elven cloak" => {
        damaged => 1,
        ac      => 0,
    },
    "f - a burnt very rotted +0 elven cloak" => {
        damaged => 2,
        ac      => 0,
    },
    "g - a thoroughly rusty iron skull cap" => {
        damaged => 3,
        ac      => 0,
    },
    "h - a thoroughly rusty corroded dwarvish iron helm" => {
        damaged => 3,
        ac      => 0,
    },
    "i - a very burnt +3 small shield" => {
        damaged => 2,
        ac      => 3,
    },
    "j - a very corroded +1 mace" => {
        damaged => 2,
    },
    "k - a dwarvish mithril-coat" => {
        damaged => 0,
        ac      => 6,
    },
    "l - a +1 dwarvish mithril-coat" => {
        damaged => 0,
        ac      => 7,
    },
);
