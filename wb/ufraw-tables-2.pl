#!/usr/bin/perl
#
use v5.14;
my $w;
while (<>) {
    my ( undef, $wb, $wbf, undef, $v1, $v2, undef, undef, $mak, @mod ) =
      split /\s+/, $_;

    my $m = join " ", @mod;

    if ( $wb =~ /^\d/ ) {
        $w = "\"$wb\"";
    }
    else {
        $w = $wb;
    }

    say "{ \"$mak\", \"$m\", $w, $wbf, { $v1, 1, $v2, 0 } },";
}
