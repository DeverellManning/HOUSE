#!/bin/sh

if [[ $(whoami) == deverell-manning ]]; then
	bash
else
	echo "You do not have permisssion!"
fi