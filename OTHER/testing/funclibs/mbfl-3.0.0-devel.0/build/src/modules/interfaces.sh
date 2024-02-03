declare mbfl_p_at_queue_letter='a'
function mbfl_at_enable () {
mbfl_declare_program at
mbfl_declare_program atq
mbfl_declare_program atrm
mbfl_declare_program sort
}
function mbfl_at_validate_queue_letter () {
local QUEUE=${1:?"missing queue letter parameter to '${FUNCNAME}'"}
if ((1 == ${#QUEUE}))
then mbfl_string_is_alpha_char "$QUEUE"
else return 1
fi
}
function mbfl_at_validate_selected_queue () {
if ! mbfl_at_check_queue_letter "$QUEUE"
then
mbfl_message_error_printf 'bad "at" queue identifier "%s"' "$QUEUE"
return 1
fi
}
function mbfl_at_select_queue () {
local QUEUE=${1:?"missing queue letter parameter to '${FUNCNAME}'"}
if ! mbfl_at_validate_queue_letter "$QUEUE"
then
mbfl_message_error_printf 'bad "at" queue identifier "%s"' "$QUEUE"
return 1
fi
mbfl_p_at_queue_letter=${QUEUE}
}
function mbfl_at_schedule () {
local SCRIPT=${1:?"missing script parameter to '${FUNCNAME}'"}
local TIME=${2:?"missing time parameter to '${FUNCNAME}'"}
local AT QUEUE=${mbfl_p_at_queue_letter}
mbfl_program_found_var AT at || exit $?
printf '%s' "$SCRIPT" | {
mbfl_program_redirect_stderr_to_stdout
if ! mbfl_program_exec "$AT" -q $QUEUE $TIME
then
mbfl_message_error_printf 'scheduling command execution "%s" at time "%s"' "$SCRIPT" "$TIME"
return 1
fi
} | {
local REPLY
if ! { read; read; }
then
mbfl_message_error 'reading output of "at"'
mbfl_message_error_printf 'while scheduling command execution "%s" at time "%s"' "$SCRIPT" "$TIME"
return 1
fi
set -- $REPLY
printf '%d' "$2"
}
}
function mbfl_at_queue_print_identifiers () {
local QUEUE=${mbfl_p_at_queue_letter}
mbfl_p_at_program_atq "$QUEUE" | while IFS= read -r LINE
do
set -- $LINE
printf '%d ' "$1"
done
}
function mbfl_at_queue_print_queues () {
local ATQ SORT line
ATQ=$(mbfl_program_found atq)   || exit $?
SORT=$(mbfl_program_found sort) || exit $?
{ mbfl_program_exec "$ATQ" | while IFS= read -r line
do
set -- $line
printf '%c\n' "$4"
done } | mbfl_program_exec "$SORT" -u
}
function mbfl_at_queue_print_jobs () {
local QUEUE=${mbfl_p_at_queue_letter}
mbfl_p_at_program_atq "$QUEUE"
}
function mbfl_at_print_queue () {
local QUEUE=$mbfl_p_at_queue_letter
printf '%c' "$QUEUE"
}
function mbfl_at_drop () {
local ATRM
local ID=${1:?"missing script identifier parameter to '${FUNCNAME}'"}
ATRM=$(mbfl_program_found atrm) || exit $?
mbfl_program_exec "$ATRM" "$ID"
}
function mbfl_at_queue_clean () {
local item QUEUE=${mbfl_p_at_queue_letter}
for item in $(mbfl_at_queue_print_identifiers "$QUEUE")
do mbfl_at_drop "$item"
done
}
function mbfl_p_at_program_atq () {
local ATQ
local QUEUE=${1:?"missing job queue parameter to '${FUNCNAME}'"}
ATQ=$(mbfl_program_found atq) || exit $?
mbfl_program_exec "$ATQ" -q "$QUEUE"
}
