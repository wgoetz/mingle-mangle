#!/usr/bin/perl
#
use v5.14;
my $w;
while (<>) {
    my ( undef, $wb, $wbfine, undef, $red, $blu, undef, undef, $vend, @mod ) =
      split /\s+/, $_;

    my $m = join " ", @mod;

    if ( $wb =~ /^\d/ ) {
        $w = "\"$wb\"";
    }
    else {
        $w = $wb;
    }

    say "{ \"$vend\", \"$m\", $w, $wbfine, { $red, 1, $blu, 0 } },";
}
