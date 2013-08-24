#!/usr/bin/perl
# wolfgang.ztoeg@web.de 20130824
#
use v5.14;
my $w;
while (<>) {
    my ( undef, $wb, $wbfine, undef, $red, $blu, undef, undef, $vend, @mod ) =
      split /\s+/, $_;

    next if $wb=~/Auto/;

    my $m = join " ", @mod;

    if ( $wb =~ /^\d/ ) {
        $w = "\"$wb\"";
    }
    else {
        $w = $wb;
    }

    say "{ \"$vend\", \"$m\", $w, $wbfine, { $red, 1, $blu, 0 } },";
}
