#!/usr/bin/perl
#
use v5.14;

my %Fakenr=(
"Incandescent" => -900,
"CoolWhiteFluorescent" => -800,
"DirectSunlight" => -700,
"Flash" => -600,
"Cloudy" => -500,
"Shade" => -400,
);

my $k;
my @NEF=qx!ls *.nef!;
chomp @NEF;

foreach my $i (@NEF){
	my @DAT=qx!exiftool -s -S -WhiteBalance -WhiteBalanceFineTune -WB_RBLevels $i!;
	chomp @DAT;

	next if $DAT[0]=~/Auto/;
	$DAT[0]=~s/Cool WHT FL/CoolWhiteFluorescent/;
	$DAT[0]=~s/Sunny/DirectSunlight/;

	$Fakenr{$DAT[0]}=$k if ($k)=$DAT[0]=~/^(\d+)K$/;		

	say "$Fakenr{$DAT[0]} $DAT[0] $DAT[1] $DAT[2]"; 
}
