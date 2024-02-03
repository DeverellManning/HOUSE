#echo "$Item"

[[ $(_lineCount "$(ls -1 "$Item")") -gt 2 ]] && echo "In the $(inam "$Item"), there are:" || echo "In the $(inam "$Item"), there is:"
	./PRGM/output/ListContent.sh "$Item"
