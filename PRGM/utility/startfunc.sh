#!/bin/bash
_serror () {
	echo "ERROR: $1 (Line ${BASH_LINENO[0]}, start.sh)"
	read -t 20 -N 1
	exit
}

#Echo if debug mode (Debug is True)
decho () {
	$_debug && echo "$1"; sleep 0.2
}

_check_internet () {
	#check for internet connection, return 0 on success, 1 otherwise
    wget --tries=3 --timeout=5 http://www.google.com -O /tmp/index.google > /dev/null 2>&1
    if [ -s /tmp/index.google ]; then
        rm -rf /tmp/index.google
        return 0
    else
        rm -rf /tmp/index.google
        return 1
    fi
}


_check_config() {
	true
}
