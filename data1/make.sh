#!/usr/bin/env

f1=$(mktemp)
f2=$(mktemp) ; echo "{}" | jq > $f2

for ((yr=1999; yr<=2020; yr++))
do
	echo ">>> Processing $yr ..."
	ff=${yr}.txt
	cat $ff | while read -r line; do
		var1=$(echo $line | cut -d\| -f1 | sed -e "s/\s*//g")
		var2=$(echo $line | cut -d\| -f2 | sed -e "s/\s*//g")
		var3=$(echo $line | cut -d\| -f3 | sed -e "s/\s*//g")

		var2=${var2:-null}
		var3=${var3:-null}

		[ $yr -eq 1999 ] && unit=1
		[ $yr -ge 2000 -a $yr -le 2011 ] && unit=10000
		[ $yr -ge 2012 ] && unit=1000

		printf "{ \"$yr\" : { \"$var1\" : { \"單位\": $unit, \"預算\": $var2, \"謄餘\": $var3 } } }" | jq . > $f1
		f3=$(mktemp)
		jq --slurp '.[0] * .[1]' $f2 $f1 > $f3
		cat $f3 > $f2
		rm $f3
	done
done
cat $f2 | jq > data.json

rm $f1
rm $f2
