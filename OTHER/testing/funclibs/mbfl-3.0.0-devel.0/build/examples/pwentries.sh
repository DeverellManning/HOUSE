#!/usr/bin/bash
script_PROGNAME=pwentries.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='Read entries from /etc/passwd.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME}
\t${script_PROGNAME} --print-xml
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
mbfl_main_declare_exit_code 2 cannot_read_file
mbfl_main_declare_exit_code 3 cannot_print_results
mbfl_declare_option ACTION_PRINT	yes '' print        noarg 'print the entries'
mbfl_declare_option ACTION_PRINT_XML	no  '' print-xml    noarg 'print the entries as XML'
mbfl_declare_option ACTION_PRINT_JSON	no  '' print-json   noarg 'print the entries as JSON'
function main () {
mbfl_main_print_usage_screen_brief
exit_because_success
}
function script_action_print () {
if ! mbfl_system_passwd_read
then
mbfl_message_error_printf 'reading entries\n'
exit_because_cannot_read_file
fi
if mbfl_system_passwd_print_entries
then exit_success
else
mbfl_message_error_printf 'printing entries\n'
exit_because_cannot_print_results
fi
}
function script_action_print_xml () {
if ! mbfl_system_passwd_read
then
mbfl_message_error_printf 'reading entries\n'
exit_because_cannot_read_file
fi
if mbfl_system_passwd_print_entries_as_xml
then exit_success
else
mbfl_message_error_printf 'printing entries\n'
exit_because_cannot_print_results
fi
}
function script_action_print_json () {
if ! mbfl_system_passwd_read
then
mbfl_message_error_printf 'reading entries\n'
exit_because_cannot_read_file
fi
if mbfl_system_passwd_print_entries_as_json
then exit_success
else
mbfl_message_error_printf 'printing entries\n'
exit_because_cannot_print_results
fi
}
mbfl_main
