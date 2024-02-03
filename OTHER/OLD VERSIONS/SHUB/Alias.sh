#!/bin/sh

case $_act in
"l")
. ./PRGM/SH/look.sh
return 0;;

"inv")
. ./PRGM/SH/inventory.sh
return 0;;

esac
return 1
