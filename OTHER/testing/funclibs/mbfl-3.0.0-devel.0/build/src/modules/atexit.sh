declare -a mbfl_atexit_HANDLERS
declare -i mbfl_atexit_NEXT=0
function mbfl_atexit_enable () {
trap mbfl_atexit_run EXIT
}
function mbfl_atexit_disable () {
trap '' EXIT
}
function mbfl_atexit_register () {
local mbfl_HANDLER=${1:?"missing handler script parameter to '${FUNCNAME}'"}
local mbfl_IDVAR="${2:-}"
if mbfl_string_is_not_empty "$mbfl_IDVAR"
then local -n mbfl_ID_VARREF=$mbfl_IDVAR
else local mbfl_ID_VARREF
fi
mbfl_atexit_HANDLERS[$mbfl_atexit_NEXT]=$mbfl_HANDLER
mbfl_ID_VARREF=$mbfl_atexit_NEXT
let ++mbfl_atexit_NEXT
}
function mbfl_atexit_forget () {
local -i ID=${1:?"missing handler id parameter to '${FUNCNAME}'"}
mbfl_atexit_HANDLERS[$ID]=
}
function mbfl_atexit_run () {
local HANDLER
local -i i
for ((i=${#mbfl_atexit_HANDLERS[@]}-1; i >= 0; --i))
do
HANDLER=${mbfl_atexit_HANDLERS[$i]}
if mbfl_string_is_not_empty "$HANDLER"
then
# Remove the handler.
mbfl_atexit_HANDLERS[$i]=
# Run it.
"$HANDLER"
fi
done
}
function mbfl_atexit_clear () {
mbfl_atexit_HANDLERS=()
mbfl_atexit_NEXT=0
}
