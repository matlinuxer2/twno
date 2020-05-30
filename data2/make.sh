#!/usr/bin/env bash

f1=$(mktemp)
f2=$(mktemp) ; echo "{}" | jq > $f2

cat data.txt | \
while read -r line; do
	var1=$(echo $line | cut -d, -f1 | sed -e 's/\s//g')
	var2=$(echo $line | cut -d, -f2 | sed -e 's/\s//g')

	if [ -n "$var_prev" ] ; then 
		var3=$(python -c "print( format (($var2 - $var_prev), \".2f\") )")
	else
		var3=""
	fi
	var_prev="$var2"

	[ $var1 -lt 1999 ] && continue;

	printf "{ \"$var1\": { \"單位\": 100000000, \"公共債務\": $var2, \"舉債增加\": ${var3:-null} } }\n"  | jq . > $f1
	f3=$(mktemp)
	jq --slurp '.[0] * .[1]' $f2 $f1 > $f3
	cat $f3 > $f2
	rm $f3
done

cat $f2 | jq > data.json

rm $f1
rm $f2
