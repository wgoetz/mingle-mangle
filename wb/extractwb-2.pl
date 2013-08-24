#!/usr/bin/perl
#
use v5.14;

my %Fakenr = (
    "Incandescent"         => -900,
    "CoolWhiteFluorescent" => -800,
    "DirectSunlight"       => -700,
    "Flash"                => -600,
    "Cloudy"               => -500,
    "Shade"                => -400,
);

my $k;
my @NEF = qx!ls *.nef!;
chomp @NEF;

foreach my $i (@NEF) {
    my ($wb,$wbf,$wblev,$mod) =
      qx!exiftool -s -S -WhiteBalance -WhiteBalanceFineTune -WB_RBLevels -Model $i!;
      chomp  ($wb,$wbf,$wblev,$mod);

    next if $wb =~ /Auto/;
    $wb =~ s/Cool WHT FL/CoolWhiteFluorescent/;
    $wb =~ s/Sunny/DirectSunlight/;

    $Fakenr{ $wb } = $k if ($k) = $wb =~ /^(\d+)K$/;

    say "$Fakenr{$wb} $wb $wbf $wblev $mod";
}
