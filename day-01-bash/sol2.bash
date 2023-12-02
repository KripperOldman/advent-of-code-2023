#!/usr/bin/env bash

# set -x

nums=$(cat ${1:?} | sed 's/one/\01\0/g' | sed 's/two/\02\0/g' | sed 's/three/\03\0/g' | sed 's/four/\04\0/g' | sed 's/five/\05\0/g' | sed 's/six/\06\0/g' | sed 's/seven/\07\0/g' | sed 's/eight/\08\0/g' | sed 's/nine/\09\0/g' | sed 's/[^0-9]//g')
sum=0

for num in $nums; do
	first=${num:0:1}
	last=${num:${#num}-1:1}
	sum=$(($sum + "$first$last"))
done

echo $sum
