#!/usr/bin/perl
#
use v5.14;
my $w;
while(<>){
	my @L=split /\s+/,$_;

	if ($L[1]=~/^\d/){ 
		$w="\"$L[1]\"";
	}else{
		$w=$L[1];
	}

	say "{ \"NIKON\", \"D800E\", $w, $L[2], { $L[4], 1, $L[5], 0 } },";   
}
