#!/usr/bin/perl
# wolfgang.ztoeg@web.de 20130824
#
use v5.14;

my %Fakenr = (
    "Incandescent" => -900,    #nik
    "Tungsten"     => -900,    #can

    "SodiumVaporFluorescent"          => -830,    #nik
    "WarmWhiteFluorescent"            => -820,    #nik
    "WhiteFluorescent"                => -810,    #nik
    "CoolWhiteFluorescent"            => -800,    #nik
    "Fluorescent"                     => -800,    #can
    "WhiteFluorescent"                => -800,    #can
    "DayWhiteFluorescent"             => -790,    #nik
    "DaylightFluorescent"             => -780,    #nik
    "HighTempMercuryVaporFluorescent" => -770,    #nik

    "DirectSunlight" => -700,                     #nik
    "Daylight"       => -700,                     #can

    "Flash"  => -600,                             #nik
    "Cloudy" => -500,                             #nik,can
    "Shade"  => -400,                             #nik,can
);

my %RenameWB = (
    "Cool WHT FL" => "CoolWhiteFluorescent",
    "Sunny"       => "DirectSunlight",
);

my $k;
my @RAW = qx!find . -iname \\*.nef -or -iname \\*.cr2!;
chomp @RAW;

foreach my $i (@RAW) {
    my ( $wb, $wbfine, $red, $blu, $mod, $wblev, $wbshiftab, $wbbracket ) =
qx!exiftool -s -S -f -WhiteBalance -WhiteBalanceFineTune -RedBalance -BlueBalance -Model -WB_RBLevels -WBShiftAB -WBBracketValueAB $i!;
    chomp( $wb, $wbfine, $red, $blu, $mod, $wblev, $wbshiftab, $wbbracket );

    $wb = $RenameWB{$wb} if exists $RenameWB{$wb};

    $Fakenr{$wb} = $k if ($k) = $wb =~ /^(\d+)K$/;

    if ( $wbfine =~ /^\-$/xms ) {
        $wbfine = "$wbshiftab $wbbracket";    #canon
    }
    else {
        $wbfine .= " 0"
          if $wbfine =~ /^[^\s]+$/xms;   # no second Finetune value for D70 D200
    }

    $wblev = "$red $blu 1 1"
      if $wblev =~ /^\-$/xms;            # no WB_RBLevels for D70, Canon

    say "$Fakenr{$wb} $wb $wbfine $wblev $mod";
    if ( $mod =~ /D800/ ) {              # D800 and D800E have same settings
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

