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
    my ( $wb, $wbfine, $red, $blu, $mod, $wblev ) =
qx!exiftool -s -S -f -WhiteBalance -WhiteBalanceFineTune -RedBalance -BlueBalance -Model -WB_RBLevels $i!;
    chomp( $wb, $wbfine, $red, $blu, $mod, $wblev );

    #next if $wb =~ /Auto/;
    $wb =~ s/Cool WHT FL/CoolWhiteFluorescent/;
    $wb =~ s/Sunny/DirectSunlight/;

    $Fakenr{$wb} = $k if ($k) = $wb =~ /^(\d+)K$/;

    $wbfine.=" 0" if $wbfine =~ /^[^\s]+$/xms; # no second Finetune value for D70 D200 

    $wblev = "$red $blu 1 1" if $wblev=~/\-/;  # no WB_RBLevels for D70  

    say "$Fakenr{$wb} $wb $wbfine $wblev $mod";
    if ( $mod =~ /D800/ ) { # D800 and D800E have same settings
        if ( $mod =~ /D800E/ ) {
            $mod =~ s/D800E/D800/;
        }
        else {
            $mod =~ s/D800/D800E/;
        }
        say "$Fakenr{$wb} $wb $wbfine $wblev $mod";
    }

}


__END__
exiftool -s -WhiteBalance -WhiteBalanceFineTune -WB_RBLevels -RedBalance -BlueBalance
WhiteBalance                    : 2700K
WhiteBalanceFineTune            : 0 0
WB_RBLevels                     : 1.1796875 2.48828125 1 1
RedBalance                      : 1.179688
BlueBalance                     : 2.488281

