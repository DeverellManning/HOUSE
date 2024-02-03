declare mbfl_message_PROGNAME=$script_PROGNAME
declare mbfl_message_CHANNEL=2
function mbfl_message_set_progname () {
mbfl_message_PROGNAME=${1:?$FUNCNAME error: missing program name argument}
}
function mbfl_message_set_channel () {
local CHANNEL=${1:?$FUNCNAME error: missing channel argument}
if mbfl_string_is_digit "$CHANNEL"
then mbfl_message_CHANNEL=$CHANNEL
else
mbfl_message_error_printf 'invalid message channel, expected digits: "%s"' "$CHANNEL"
return 1
fi
}
function mbfl_message_p_print () {
printf "${2:?$1 error: missing template argument}" >&$mbfl_message_CHANNEL
}
function mbfl_message_p_print_prefix () {
mbfl_message_p_print $1 "$mbfl_message_PROGNAME: $2"
}
function mbfl_message_string () {
local STRING="${1:-string}"
mbfl_message_p_print $FUNCNAME "$1"
return 0
}
function mbfl_message_verbose () {
if mbfl_option_verbose
then mbfl_message_p_print_prefix $FUNCNAME "$1"
fi
return 0
}
function mbfl_message_verbose_end () {
if mbfl_option_verbose
then mbfl_message_p_print $FUNCNAME "$1\n"
fi
return 0
}
function mbfl_message_error () {
mbfl_message_p_print_prefix $FUNCNAME "error: $1\n"
return 0
}
function mbfl_message_warning () {
mbfl_message_p_print_prefix $FUNCNAME "warning: $1\n"
return 0
}
function mbfl_message_debug () {
mbfl_option_debug && mbfl_message_p_print_prefix $FUNCNAME "debug: $1\n"
return 0
}
function mbfl_message_verbose_printf () {
if mbfl_option_verbose
then
{
printf '%s: ' "$mbfl_message_PROGNAME"
printf "$@"
} >&$mbfl_message_CHANNEL
fi
return 0
}
function mbfl_message_error_printf () {
{
printf '%s: error: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
return 0
}
function mbfl_message_warning_printf () {
{
printf '%s: warning: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
return 0
}
function mbfl_message_debug_printf () {
if mbfl_option_debug
then
{
printf '%s: debug: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
fi
return 0
}
