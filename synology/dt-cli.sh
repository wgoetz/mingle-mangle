#!/bin/bash
# wolfgang.ztoeg@web.de
#

dt_cli="/opt/darktable/bin/darktable-cli"

IFS="," read xmp out <<< $1

tout="/tmp/${out##*/}"
raw=${xmp%/*}/$(exiftool -s -S -f -DerivedFrom "$xmp")

[ -f "$raw" ] || { echo "NOT FOUND: $raw" ; exit 1; }

echo -n "$out "

d="${out%/*}/@eaDir"
e="$d/${out##*/}"
x="$e/SYNOPHOTO_THUMB_XL.jpg"
b="$e/SYNOPHOTO_THUMB_B.jpg"
m="$e/SYNOPHOTO_THUMB_M.jpg"
s="$e/SYNOPHOTO_THUMB_S.jpg"


aHist=$(exiftool -s -S -f -History_params "$xmp")
bHist=$(exiftool -s -S -f -History_params "$out")

if [ "$aHist" = "$bHist" ];then
	touch "$out" "$x" "$b" "$m" "$s"
	echo "touched due to no picture content change"
else
	[ -f "$tout" ] && rm -v "$tout"
	outfmt=$(identify -format "--width %W --height %H" "$out")
	cat "$raw" > /dev/null
	mtime=$(/usr/bin/stat --format="%y" "$xmp")

	flock /var/lock/dt-cli.lock /usr/bin/time -a -o /tmp/dt-cli.time -f "%E %C"\
		$dt_cli "$raw" "$tout" $outfmt\
    		--core -d opencl 2>/dev/null|grep summary|tr -d \\n

	/usr/bin/touch --date="$mtime" "$xmp"
	if [ -s "$tout" ];then
	       	mv  "$tout" "$out"
		convert -resize 1280x1280 "$out" "$x"; echo -n " X"
		convert -resize 640x640   "$x" "$b"; echo -n " B"
		convert -resize 320x320   "$b" "$m"; echo -n " M"
		convert -resize 120x120   "$m" "$s"; echo -n " S"
		echo
	fi
fi
