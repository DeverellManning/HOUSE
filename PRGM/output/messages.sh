while [[ true ]]; do
	#Getting Ready
	lt=$t
	t=$(< ./WORLD/time)
	#if [[ $t != $lt ]]; then . "./PRGM/output/message-tick.sh"; fi
	. ./PRGM/output/message-tick.sh
	sleep 0.1
done
