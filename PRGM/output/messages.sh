while [[ true ]]; do
	#Getting Ready
	lt=$t
	t=$(< ./WORLD/time)
	. ./PRGM/output/message-tick.sh
	sleep 0.1
done
