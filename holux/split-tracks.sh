#!/bin/sh
# this is for holux->tracks
#
gpxsplit(){
	gpsbabel -t -i gpx -f foo.gpx \
	-x track,name="$@" \
	-o gpx  -F "pertrack-$@.gpx"
}


if [ ! -f foo.bin ]; then
	mtkbabel -s 38400 -f foo -w -t
fi

gpsbabel -t -i m241-bin -f foo.bin -o gpx -F foo.gpx

grep -A1 "<trk>" foo.gpx|grep name|cut -b9-|awk -F\< '{print $1}'|\
while read li ; do
	gpxsplit "$li"
done
