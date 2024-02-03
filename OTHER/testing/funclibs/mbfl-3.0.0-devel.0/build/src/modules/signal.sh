test "$mbfl_INTERACTIVE" = yes || {
declare -a mbfl_signal_HANDLERS
i=0
{ while kill -l $i ; do let ++i; done; } &>/dev/null
declare -i mbfl_signal_MAX_SIGNUM=$i
}
function mbfl_signal_map_signame_to_signum () {
local SIGSPEC=${1:?"missing signal name parameter to '${FUNCNAME}'"}
local i name
for ((i=0; $i < $mbfl_signal_MAX_SIGNUM; ++i))
do
test "SIG$(kill -l $i)" = "$SIGSPEC" && {
echo $i
return 0
}
done
return 1
}
function mbfl_signal_attach () {
local SIGSPEC=${1:?"missing signal name parameter to '${FUNCNAME}'"}
local HANDLER=${2:?"missing function name parameter to '${FUNCNAME}'"}
local signum
signum=$(mbfl_signal_map_signame_to_signum "$SIGSPEC") || return 1
if test -z ${mbfl_signal_HANDLERS[$signum]}
then mbfl_signal_HANDLERS[$signum]=$HANDLER
else mbfl_signal_HANDLERS[$signum]=${mbfl_signal_HANDLERS[$signum]}:$HANDLER
fi
mbfl_message_debug "attached '$HANDLER' to signal $SIGSPEC"
trap -- "mbfl_signal_invoke_handlers $signum" $signum
}
function mbfl_signal_invoke_handlers () {
local SIGNUM=${1:?"missing signal number parameter to '${FUNCNAME}'"}
local handler ORGIFS=$IFS
mbfl_message_debug "received signal 'SIG$(kill -l $SIGNUM)'"
IFS=:
for handler in ${mbfl_signal_HANDLERS[$SIGNUM]}
do
IFS=$ORGIFS
mbfl_message_debug "registered handler: $handler"
test -n "$handler" && eval $handler
done
IFS=$ORGIFS
return 0
}
