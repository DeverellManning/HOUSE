#!/bin/sh

test="$_p1 $_p2"
test=`echo $test | sed -e 's/ *$//g'`
echo "You open the $test."

if [ -e "$_where/$test/Container.txt" ]; then
	_target=$test
	echo "In the $_target, there are:"
	./PRGM/SHUB/ListContent.sh "$_where/$_target"
else
	echo "$test is NOT a container"
fi

echo "target is $_target"
