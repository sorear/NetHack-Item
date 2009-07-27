#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 13;
use NetHack::ItemPool;

my $pool = NetHack::ItemPool->new;

my $lucky = $pool->new_item("gray stone");
my $heavy = $pool->new_item("gray stone");
my $touch = $pool->new_item("gray stone");

ok($lucky->has_tracker, "First gray stone has a tracker");
ok($heavy->has_tracker, "Second gray stone has a tracker");
isnt($heavy->tracker, $lucky->has_tracker, "But they're not the same");

is(scalar($lucky->tracker->possibilities), 4, "There are 4 gray stones");

# let's kick them
$lucky->tracker->rule_out('loadstone');

ok(!$lucky->tracker->includes_possibility('loadstone').
    "We kicked lucky, it can't be heavy");
is(scalar($lucky->tracker->possibilities), 3, "Three options left");
is(scalar($heavy->tracker->possibilities), 4, "Heavy still has all options");

# Thump!
$heavy->tracker->identify_as('loadstone');

is($heavy->identity, 'loadstone', "heavy is a loadstone now");
is($lucky->identity, undef, "We still don't know what lucky is");
is(scalar($lucky->tracker->possibilities), 3, "Know no more about lucky");
is(scalar($touch->tracker->possibilities), 4, "No information about touch");

# While engraving, your hand slips.
$lucky->tracker->identify_as('luckstone');

is($lucky->identity, 'luckstone', "it's a luckstone now");
is(scalar($touch->tracker->possibilities), 4, "Still no info on the other one");
