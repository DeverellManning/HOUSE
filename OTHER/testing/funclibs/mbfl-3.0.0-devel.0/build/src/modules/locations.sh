declare -A mbfl_location_HANDLERS
declare -i mbfl_location_COUNTER=0
declare mbfl_location_ATEXIT_ID
function mbfl_location_enter () {
let ++mbfl_location_COUNTER
mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]=0
}
function mbfl_location_leave () {
if ((0 < mbfl_location_COUNTER))
then
local -i i HANDLERS_COUNT=${mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]}
local HANDLER HANDLER_KEY
for ((i=HANDLERS_COUNT; 0 < i; --i))
do
HANDLER_KEY=${mbfl_location_COUNTER}:${i}
HANDLER=${mbfl_location_HANDLERS[${HANDLER_KEY}]}
#echo --$FUNCNAME--handler_key--${HANDLER_KEY}-- >&2
if mbfl_string_is_not_empty $HANDLER
then eval $HANDLER
fi
unset -v mbfl_location_HANDLERS[${HANDLER_KEY}]
done
unset -v mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]
let --mbfl_location_COUNTER
fi
}
function mbfl_location_run_all () {
while ((0 < mbfl_location_COUNTER))
do mbfl_location_leave
done
}
function mbfl_location_enable_cleanup_atexit () {
mbfl_atexit_register mbfl_location_run_all mbfl_location_ATEXIT_ID
}
function mbfl_location_disable_cleanup_atexit () {
mbfl_atexit_forget $mbfl_location_ATEXIT_ID
}
function mbfl_location_handler () {
if ((0 < mbfl_location_COUNTER))
then
local HANDLER=${1:?"missing location handler parameter to '${FUNCNAME}'"}
local COUNT_KEY=${mbfl_location_COUNTER}:count
let ++mbfl_location_HANDLERS[${COUNT_KEY}]
local HANDLER_KEY=${mbfl_location_COUNTER}:${mbfl_location_HANDLERS[${COUNT_KEY}]}
mbfl_location_HANDLERS[${HANDLER_KEY}]=${HANDLER}
#echo --$FUNCNAME--count-key--${mbfl_location_HANDLERS[${COUNT_KEY}]}--handler-key--${HANDLER_KEY} >&2
else
mbfl_message_error 'attempt to register a location handler outside any location'
exit_because_no_location
fi
}
