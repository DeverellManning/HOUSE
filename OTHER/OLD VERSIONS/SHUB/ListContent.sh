#!/bin/sh


dl=0	#Number of Files in dbpics.txt

getLine () {
	cat $1 | head -n$2 | tail -n1
}

# ./PRGM/SHUB/LC.sh

ls -x1QX --color=never "$1"| xargs -n 1 ./PRGM/SHUB/LC.sh
