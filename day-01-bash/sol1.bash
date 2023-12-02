#!/usr/bin/env bash

# set -x

nums=$(sed 's/[^0-9]//g' ${1:?})
sum=0

for num in $nums; do
	first=${num:0:1}
	last=${num:${#num}-1:1}
	sum=$(($sum + "$first$last"))
done

echo $sum
