#!/bin/bash

if [[ ${_target:-null} != null ]]; then
	echo "You close the $(inam "$_target")."
	#. ./$_where/$_target/close.sh
	_target=
fi
