#!/usr/bin/bash
script_PROGNAME=template-actions.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2013, 2014, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
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
mbfl_atexit_enable
mbfl_location_enable_cleanup_atexit
mbfl_declare_action_set ONE_GREEN
mbfl_declare_action ONE_GREEN	ONE_GREEN_SOLID		NONE	solid		'Do main action one green solid.'
mbfl_declare_action ONE_GREEN	ONE_GREEN_LIQUID	NONE	liquid		'Do main action one green liquid.'
mbfl_declare_action ONE_GREEN	ONE_GREEN_GAS		NONE	gas		'Do main action one green gas.'
mbfl_declare_action_set ONE_WHITE
mbfl_declare_action ONE_WHITE	ONE_WHITE_SOLID		NONE	solid		'Do main action one white solid.'
mbfl_declare_action ONE_WHITE	ONE_WHITE_LIQUID	NONE	liquid		'Do main action one white liquid.'
mbfl_declare_action ONE_WHITE	ONE_WHITE_GAS		NONE	gas		'Do main action one white gas.'
mbfl_declare_action_set ONE_RED
mbfl_declare_action ONE_RED	ONE_RED_SOLID		NONE	solid		'Do main action one red solid.'
mbfl_declare_action ONE_RED	ONE_RED_LIQUID		NONE	liquid		'Do main action one red liquid.'
mbfl_declare_action ONE_RED	ONE_RED_GAS		NONE	gas		'Do main action one red gas.'
mbfl_declare_action_set TWO_GREEN
mbfl_declare_action TWO_GREEN	TWO_GREEN_SOLID		NONE	solid		'Do main action two green solid.'
mbfl_declare_action TWO_GREEN	TWO_GREEN_LIQUID	NONE	liquid		'Do main action two green liquid.'
mbfl_declare_action TWO_GREEN	TWO_GREEN_GAS		NONE	gas		'Do main action two green gas.'
mbfl_declare_action_set TWO_WHITE
mbfl_declare_action TWO_WHITE	TWO_WHITE_SOLID		NONE	solid		'Do main action two white solid.'
mbfl_declare_action TWO_WHITE	TWO_WHITE_LIQUID	NONE	liquid		'Do main action two white liquid.'
mbfl_declare_action TWO_WHITE	TWO_WHITE_GAS		NONE	gas		'Do main action two white gas.'
mbfl_declare_action_set TWO_RED
mbfl_declare_action TWO_RED	TWO_RED_SOLID		NONE	solid		'Do main action two red solid.'
mbfl_declare_action TWO_RED	TWO_RED_LIQUID		NONE	liquid		'Do main action two red liquid.'
mbfl_declare_action TWO_RED	TWO_RED_GAS		NONE	gas		'Do main action two red gas.'
mbfl_declare_action_set THREE_GREEN
mbfl_declare_action THREE_GREEN	THREE_GREEN_SOLID	NONE	solid		'Do main action three green solid.'
mbfl_declare_action THREE_GREEN	THREE_GREEN_LIQUID	NONE	liquid		'Do main action three green liquid.'
mbfl_declare_action THREE_GREEN	THREE_GREEN_GAS		NONE	gas		'Do main action three green gas.'
mbfl_declare_action_set THREE_WHITE
mbfl_declare_action THREE_WHITE	THREE_WHITE_SOLID	NONE	solid		'Do main action three white solid.'
mbfl_declare_action THREE_WHITE	THREE_WHITE_LIQUID	NONE	liquid		'Do main action three white liquid.'
mbfl_declare_action THREE_WHITE	THREE_WHITE_GAS		NONE	gas		'Do main action three white gas.'
mbfl_declare_action_set THREE_RED
mbfl_declare_action THREE_RED	THREE_RED_SOLID		NONE	solid		'Do main action three red solid.'
mbfl_declare_action THREE_RED	THREE_RED_LIQUID	NONE	liquid		'Do main action three red liquid.'
mbfl_declare_action THREE_RED	THREE_RED_GAS		NONE	gas		'Do main action three red gas.'
mbfl_declare_action_set ONE
mbfl_declare_action ONE		ONE_GREEN	ONE_GREEN	green		'Do main action one green.'
mbfl_declare_action ONE		ONE_WHITE	ONE_WHITE	white		'Do main action one white.'
mbfl_declare_action ONE		ONE_RED		ONE_RED		red		'Do main action one red.'
mbfl_declare_action_set TWO
mbfl_declare_action TWO		TWO_GREEN	TWO_GREEN	green		'Do main action two green.'
mbfl_declare_action TWO		TWO_WHITE	TWO_WHITE	white		'Do main action two white.'
mbfl_declare_action TWO		TWO_RED		TWO_RED		red		'Do main action two red.'
mbfl_declare_action_set THREE
mbfl_declare_action THREE	THREE_GREEN	THREE_GREEN	green		'Do main action three green.'
mbfl_declare_action THREE	THREE_WHITE	THREE_WHITE	white		'Do main action three white.'
mbfl_declare_action THREE	THREE_RED	THREE_RED	red		'Do main action three red.'
mbfl_declare_action_set MAIN
mbfl_declare_action MAIN	ONE		ONE		one		'Do main action one.'
mbfl_declare_action MAIN	TWO		TWO		two		'Do main action two.'
mbfl_declare_action MAIN	THREE		THREE		three		'Do main action three.'
function script_before_parsing_options () {
script_USAGE="usage: ${script_PROGNAME} [action] [options]"
script_DESCRIPTION='This is an example script showing action arguments.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} --x-opt"
mbfl_declare_option X no x x-opt noarg   'Selects option x.'
mbfl_declare_option Y '' y y-opt witharg 'Selects option y.'
mbfl_declare_option Z '' z z-opt witharg 'Selects option z.'
}
function main () {
printf "action main: X='%s' Y='%s' Z='%s' ARGC=%s ARGV='%s'\n" \
"$script_option_X" "$script_option_Y" "$script_option_Z" "$ARGC" "${ARGV[*]}"
}
function script_before_parsing_options_ONE () {
script_USAGE="usage: ${script_PROGNAME} one [action] [options]"
script_DESCRIPTION='Example action tree: one.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green solid"
}
function script_action_ONE () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_TWO () {
script_USAGE="usage: ${script_PROGNAME} two [action] [options]"
script_DESCRIPTION='Example action tree: two.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green solid"
}
function script_action_TWO () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_THREE () {
script_USAGE="usage: ${script_PROGNAME} three [action] [options]"
script_DESCRIPTION='Example action tree: three.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green solid"
}
function script_action_THREE () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_ONE_GREEN () {
script_USAGE="usage: ${script_PROGNAME} one green [action] [options]"
script_DESCRIPTION='Example action tree: one green.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green solid"
}
function script_action_ONE_GREEN () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_ONE_WHITE () {
script_USAGE="usage: ${script_PROGNAME} one white [action] [options]"
script_DESCRIPTION='Example action tree: one white.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white solid"
}
function script_action_ONE_WHITE () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_ONE_RED () {
script_USAGE="usage: ${script_PROGNAME} one red [action] [options]"
script_DESCRIPTION='Example action tree: one red.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red solid"
}
function script_action_ONE_RED () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_TWO_GREEN () {
script_USAGE="usage: ${script_PROGNAME} two green [action] [options]"
script_DESCRIPTION='Example action tree: two green.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green solid"
}
function script_action_TWO_GREEN () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_TWO_WHITE () {
script_USAGE="usage: ${script_PROGNAME} two white [action] [options]"
script_DESCRIPTION='Example action tree: two white.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white solid"
}
function script_action_TWO_WHITE () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_TWO_RED () {
script_USAGE="usage: ${script_PROGNAME} two red [action] [options]"
script_DESCRIPTION='Example action tree: two red.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red solid"
}
function script_action_TWO_RED () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_THREE_GREEN () {
script_USAGE="usage: ${script_PROGNAME} three green [action] [options]"
script_DESCRIPTION='Example action tree: three green.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green solid"
}
function script_action_THREE_GREEN () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_THREE_WHITE () {
script_USAGE="usage: ${script_PROGNAME} three white [action] [options]"
script_DESCRIPTION='Example action tree: three white.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white solid"
}
function script_action_THREE_WHITE () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_THREE_RED () {
script_USAGE="usage: ${script_PROGNAME} three red [action] [options]"
script_DESCRIPTION='Example action tree: three red.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red solid"
}
function script_action_THREE_RED () {
mbfl_main_print_usage_screen_brief
}
function script_before_parsing_options_ONE_GREEN_SOLID () {
script_USAGE="usage: ${script_PROGNAME} one green solid [options]"
script_DESCRIPTION='Example action: one green solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green solid --a-opt"
mbfl_declare_option A no a a-opt noarg   'Selects option a.'
mbfl_declare_option B '' b b-opt witharg 'Selects option b.'
mbfl_declare_option C '' c c-opt witharg 'Selects option c.'
}
function script_action_ONE_GREEN_SOLID () {
printf "action one green solid: A='%s' B='%s' C='%s' ARGC=%s ARGV='%s'\n" \
"$script_option_A" "$script_option_B" "$script_option_C" "$ARGC" "${ARGV[*]}"
}
function script_before_parsing_options_ONE_GREEN_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} one green liquid [options]"
script_DESCRIPTION='Example action: one green liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green liquid --d-opt"
mbfl_declare_option D no d d-opt noarg   'Selects option d.'
mbfl_declare_option E '' e e-opt witharg 'Selects option e.'
mbfl_declare_option F '' f f-opt witharg 'Selects option f.'
}
function script_action_ONE_GREEN_LIQUID () {
printf "action one green liquid: D='%s' E='%s' F='%s' ARGC=%s ARGV='%s'\n" \
"$script_option_D" "$script_option_E" "$script_option_F" "$ARGC" "${ARGV[*]}"
}
function script_before_parsing_options_ONE_GREEN_GAS () {
script_USAGE="usage: ${script_PROGNAME} one green gas [options]"
script_DESCRIPTION='Example action: one green gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one green gas --d-opt"
mbfl_declare_option G no g g-opt noarg   'Selects option d.'
mbfl_declare_option H '' h h-opt witharg 'Selects option e.'
mbfl_declare_option I '' i i-opt witharg 'Selects option f.'
}
function script_action_ONE_GREEN_GAS () {
printf "action one green gas: G='%s' H='%s' I='%s' ARGC=%s ARGV='%s'\n" \
"$script_option_G" "$script_option_H" "$script_option_I" "$ARGC" "${ARGV[*]}"
}
function script_before_parsing_options_ONE_WHITE_SOLID () {
script_USAGE="usage: ${script_PROGNAME} one white solid [options]"
script_DESCRIPTION='Example action: one white solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white solid"
}
function script_action_ONE_WHITE_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_ONE_WHITE_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} one white liquid [options]"
script_DESCRIPTION='Example action: one white liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white liquid"
}
function script_action_ONE_WHITE_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_ONE_WHITE_GAS () {
script_USAGE="usage: ${script_PROGNAME} one white gas [options]"
script_DESCRIPTION='Example action: one white gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one white gas"
}
function script_action_ONE_WHITE_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_ONE_RED_SOLID () {
script_USAGE="usage: ${script_PROGNAME} one red solid [options]"
script_DESCRIPTION='Example action: one red solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red solid"
}
function script_action_ONE_RED_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_ONE_RED_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} one red liquid [options]"
script_DESCRIPTION='Example action: one red liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red liquid"
}
function script_action_ONE_RED_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_ONE_RED_GAS () {
script_USAGE="usage: ${script_PROGNAME} one red gas [options]"
script_DESCRIPTION='Example action: one red gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} one red gas"
}
function script_action_ONE_RED_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_GREEN_SOLID () {
script_USAGE="usage: ${script_PROGNAME} two green solid [options]"
script_DESCRIPTION='Example action: two green solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green solid --a-opt"
}
function script_action_TWO_GREEN_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_GREEN_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} two green liquid [options]"
script_DESCRIPTION='Example action: two green liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green liquid --d-opt"
}
function script_action_TWO_GREEN_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_GREEN_GAS () {
script_USAGE="usage: ${script_PROGNAME} two green gas [options]"
script_DESCRIPTION='Example action: two green gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two green gas --d-opt"
}
function script_action_TWO_GREEN_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_WHITE_SOLID () {
script_USAGE="usage: ${script_PROGNAME} two white solid [options]"
script_DESCRIPTION='Example action: two white solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white solid"
}
function script_action_TWO_WHITE_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_WHITE_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} two white liquid [options]"
script_DESCRIPTION='Example action: two white liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white liquid"
}
function script_action_TWO_WHITE_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_WHITE_GAS () {
script_USAGE="usage: ${script_PROGNAME} two white gas [options]"
script_DESCRIPTION='Example action: two white gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two white gas"
}
function script_action_TWO_WHITE_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_RED_SOLID () {
script_USAGE="usage: ${script_PROGNAME} two red solid [options]"
script_DESCRIPTION='Example action: two red solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red solid"
}
function script_action_TWO_RED_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_RED_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} two red liquid [options]"
script_DESCRIPTION='Example action: two red liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red liquid"
}
function script_action_TWO_RED_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_TWO_RED_GAS () {
script_USAGE="usage: ${script_PROGNAME} two red gas [options]"
script_DESCRIPTION='Example action: two red gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} two red gas"
}
function script_action_TWO_RED_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_GREEN_SOLID () {
script_USAGE="usage: ${script_PROGNAME} three green solid [options]"
script_DESCRIPTION='Example action: three green solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green solid --a-opt"
}
function script_action_THREE_GREEN_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_GREEN_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} three green liquid [options]"
script_DESCRIPTION='Example action: three green liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green liquid --d-opt"
}
function script_action_THREE_GREEN_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_GREEN_GAS () {
script_USAGE="usage: ${script_PROGNAME} three green gas [options]"
script_DESCRIPTION='Example action: three green gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three green gas --d-opt"
}
function script_action_THREE_GREEN_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_WHITE_SOLID () {
script_USAGE="usage: ${script_PROGNAME} three white solid [options]"
script_DESCRIPTION='Example action: three white solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white solid"
}
function script_action_THREE_WHITE_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_WHITE_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} three white liquid [options]"
script_DESCRIPTION='Example action: three white liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white liquid"
}
function script_action_THREE_WHITE_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_WHITE_GAS () {
script_USAGE="usage: ${script_PROGNAME} three white gas [options]"
script_DESCRIPTION='Example action: three white gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three white gas"
}
function script_action_THREE_WHITE_GAS () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_RED_SOLID () {
script_USAGE="usage: ${script_PROGNAME} three red solid [options]"
script_DESCRIPTION='Example action: three red solid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red solid"
}
function script_action_THREE_RED_SOLID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_RED_LIQUID () {
script_USAGE="usage: ${script_PROGNAME} three red liquid [options]"
script_DESCRIPTION='Example action: three red liquid.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red liquid"
}
function script_action_THREE_RED_LIQUID () {
printf "action ${FUNCNAME}\n"
}
function script_before_parsing_options_THREE_RED_GAS () {
script_USAGE="usage: ${script_PROGNAME} three red gas [options]"
script_DESCRIPTION='Example action: three red gas.'
script_EXAMPLES="Usage examples:
\n\
\t${script_PROGNAME} three red gas"
}
function script_action_THREE_RED_GAS () {
printf "action ${FUNCNAME}\n"
}
mbfl_main
