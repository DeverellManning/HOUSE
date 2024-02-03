#!/usr/bin/bash
script_PROGNAME=at.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2005, 2009, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL3
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION="Example script to test the 'at' interface."
script_EXAMPLES="Examples:
\n
\tat.sh --schedule --time='now +1 hour' --queue=A \\
\t   --command='command.sh --option'
\tat.sh --list-jobs --queue=A
\tat.sh --drop --identifier=1234
"
declare mbfl_INTERACTIVE=no
declare mbfl_LOADED=no
declare mbfl_HARDCODED=
declare mbfl_INSTALLED=$(type -p mbfl-config &>/dev/null && mbfl-config) &>/dev/null
declare item
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
if test -n "$item" -a -f "$item" -a -r "$item"
then
if source "$item" &>/dev/null
then break
else
printf '%s error: loading MBFL file "%s"\n' "$script_PROGNAME" "$item" >&2
exit 100
fi
fi
done
unset -v item
if test "$mbfl_LOADED" != yes
then
printf '%s error: incorrect evaluation of MBFL\n' "$script_PROGNAME" >&2
exit 100
fi
mbfl_declare_option ACTION_SCHEDULE    no  S   schedule        noarg   'schedules a command'
mbfl_declare_option ACTION_LIST        yes L   list            noarg   'lists scheduled job identifiers'
mbfl_declare_option ACTION_LIST_JOBS   no  J   list-jobs       noarg   'lists scheduled jobs'
mbfl_declare_option ACTION_LIST_QUEUES no  Q   list-queues     noarg   'lists queues with scheduled jobs'
mbfl_declare_option ACTION_DROP        no  D   drop            noarg   'drops a scheduled command'
mbfl_declare_option ACTION_CLEAN       no  C   clean           noarg   'cleans a queue'
mbfl_declare_option QUEUE       z                q  queue      witharg 'selects the queue'
mbfl_declare_option TIME        'now +1 minutes' t  time       witharg 'selects time'
mbfl_declare_option COMMAND     :                c  command    witharg 'selects the command'
mbfl_declare_option IDENTIFIER  ''               '' identifier witharg 'selects a job'
mbfl_at_enable
mbfl_main_declare_exit_code 3 wrong_queue_identifier
mbfl_main_declare_exit_code 4 wrong_command_line_arguments
function script_option_update_queue () {
if ! mbfl_at_select_queue "$script_option_QUEUE"
then exit_because_wrong_queue_identifier
fi
}
function script_before_parsing_options () {
mbfl_at_select_queue ${script_option_QUEUE}
}
function script_action_schedule () {
local Q=$(mbfl_at_print_queue)
local TIME=${script_option_TIME}
local ID
mbfl_message_verbose_printf 'scheduling a job in queue "%s"\n' "$Q"
if ID=$(mbfl_at_schedule "$script_option_COMMAND" "$TIME")
then exit_failure
else
mbfl_message_verbose_printf 'scheded job identifier "%s"\n' "$ID"
exit_success
fi
}
function script_action_list () {
local Q=$(mbfl_at_print_queue) item
mbfl_message_verbose_printf 'jobs in queue "%s": ' "$Q"
for item in $(mbfl_at_queue_print_identifiers)
do printf '%d ' "$item"
done
printf '\n'
}
function script_action_list_jobs () {
mbfl_at_queue_print_jobs
}
function script_action_list_queues () {
local item
mbfl_message_verbose 'queues with pending jobs: '
for item in $(mbfl_at_queue_print_queues)
do printf '%c ' "$item"
done
printf '\n'
}
function script_action_drop () {
local ID=${script_option_IDENTIFIER}
if test -n "${ID}"
then
mbfl_message_verbose_printf 'dropping job "%s"\n' "$ID"
mbfl_at_drop "$ID"
else
mbfl_message_error 'no job selected'
exit_because_wrong_command_line_arguments
fi
}
function script_action_clean () {
local Q=$(mbfl_at_print_queue)
mbfl_message_verbose_printf 'cleaning queue "${Q}"\n' "$Q"
mbfl_at_queue_clean
}
mbfl_main
