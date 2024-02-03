#!/bin/bash

echo "Players connected:"

tmplay=$(< ./SERVER/players)
for i in $(seq 0 $(_lineCount "$tmplay")); do
	_getLine "$tmplay" $i
done