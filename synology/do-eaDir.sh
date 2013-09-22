#!/bin/bash
# wolfgang.ztoeg@web.de 20130915

syno_hostname="diskstation"
syno_mount="diskstation"


declare -A Findex

mkdir="mkdir"
convert="convert"
ssh="ssh"

[ -d "/$syno_mount/photo" ] || { echo no mount ;exit 1; }

while read f;do
	e="${f%/*}/@eaDir/${f##*/}"
	x="$e/SYNOPHOTO_THUMB_XL.jpg"
	b="$e/SYNOPHOTO_THUMB_B.jpg"
	m="$e/SYNOPHOTO_THUMB_M.jpg"
	s="$e/SYNOPHOTO_THUMB_S.jpg"
	[ -d "$e" ] || { $mkdir -vp "$e"; Findex[$f]=1; }
	[ -f "$x" ] || $convert -resize 1280x1280 "$f" "$x"
	[ -f "$b" ] || $convert -resize 640x640   "$x" "$b"
	[ -f "$m" ] || $convert -resize 320x320   "$b" "$m"
	[ -f "$s" ] || $convert -resize 120x120   "$m" "$s"
done < <(find /$syno_mount/photo -path "*/@eaDir" -prune -o -type f -print)


for f in "${!Findex[@]}";do
	$ssh admin@$syno_hostname "synoindex -a ${f/$syno_mount/volume1}"
	echo -n .
done
