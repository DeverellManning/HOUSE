if test "$mbfl_INTERACTIVE" != 'yes'
then
declare -A mbfl_action_sets_EXISTS
declare -A mbfl_action_sets_SUBSETS
declare -A mbfl_action_sets_KEYWORDS
declare -A mbfl_action_sets_DESCRIPTIONS
declare -A mbfl_action_sets_IDENTIFIERS
declare mbfl_action_sets_SELECTED_SET=MAIN
fi
function mbfl_declare_action_set () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
if mbfl_string_is_name "$ACTION_SET"
then
if mbfl_string_is_empty "${mbfl_action_sets_EXISTS[${ACTION_SET}]}"
then mbfl_action_sets_EXISTS[${ACTION_SET}]=true
else
mbfl_message_error_printf 'action set declared twice: "%s"' "$ACTION_SET"
exit_because_invalid_action_declaration
fi
else
mbfl_message_error_printf 'invalid action set identifier: "%s"' "$ACTION_SET"
exit_because_invalid_action_declaration
fi
}
function mbfl_declare_action () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
local ACTION_KEYWORD=${2:?"missing keyword parameter to '${FUNCNAME}'"}
local ACTION_SUBSET=${3:?"missing subset parameter to '${FUNCNAME}'"}
local ACTION_IDENTIFIER=${4:?"missing identifier parameter to '${FUNCNAME}'"}
local ACTION_DESCRIPTION=${5:?"missing description parameter to '${FUNCNAME}'"}
local KEY=${ACTION_SET}-${ACTION_IDENTIFIER}
if ! mbfl_string_is_identifier "$ACTION_IDENTIFIER"
then
mbfl_message_error_printf 'internal error: invalid action identifier: "%s"' "$ACTION_IDENTIFIER"
exit_because_invalid_action_declaration
fi
if mbfl_string_is_name "$ACTION_KEYWORD"
then mbfl_action_sets_KEYWORDS[${KEY}]=${ACTION_KEYWORD}
else
mbfl_message_error_printf \
'internal error: invalid keyword for action "%s": "%s"' \
"$ACTION_IDENTIFIER" "$ACTION_KEYWORD"
exit_because_invalid_action_declaration
fi
if mbfl_actions_set_exists_or_none "$ACTION_SUBSET"
then mbfl_action_sets_SUBSETS[${KEY}]=$ACTION_SUBSET
else
mbfl_message_error_printf \
'internal error: invalid or non-existent action subset identifier for action "%s": "%s"' \
"$ACTION_IDENTIFIER" "$ACTION_SUBSET"
exit_because_invalid_action_declaration
fi
mbfl_action_sets_DESCRIPTIONS[${KEY}]=$ACTION_DESCRIPTION
mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]+=" ${ACTION_IDENTIFIER}"
return 0
}
function mbfl_actions_set_exists () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
mbfl_string_is_name "$ACTION_SET" && ${mbfl_action_sets_EXISTS[${ACTION_SET}]:-false}
}
function mbfl_actions_set_exists_or_none () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
mbfl_actions_set_exists "$ACTION_SET" || mbfl_string_equal 'NONE' "$ACTION_SET"
}
function mbfl_actions_dispatch () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
if ! mbfl_actions_set_exists "$ACTION_SET"
then
mbfl_message_error_printf 'invalid action identifier: "%s"' "$ACTION_SET"
return 1
fi
if (( ARG1ST == ARGC1 ))
then return 0
fi
local IDENTIFIER=${ARGV1[$ARG1ST]}
local KEY=${ACTION_SET}-${IDENTIFIER}
local ACTION_SUBSET=${mbfl_action_sets_SUBSETS[${KEY}]}
local ACTION_KEYWORD=${mbfl_action_sets_KEYWORDS[${KEY}]}
if mbfl_string_is_empty "$ACTION_KEYWORD"
then
return 0
else
let ++ARG1ST
mbfl_main_set_before_parsing_options script_before_parsing_options_${ACTION_KEYWORD}
mbfl_main_set_after_parsing_options  script_after_parsing_options_${ACTION_KEYWORD}
mbfl_main_set_main script_action_${ACTION_KEYWORD}
mbfl_action_sets_SELECTED_SET=$ACTION_SUBSET
if mbfl_string_not_equal 'NONE' "$ACTION_SUBSET"
then
mbfl_actions_dispatch "$ACTION_SUBSET"
else
return 0
fi
fi
}
function mbfl_actions_fake_action_set () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
if mbfl_actions_set_exists "$ACTION_SET"
then
mbfl_action_sets_SELECTED_SET=$ACTION_SET
return 0
else return 1
fi
}
function mbfl_actions_print_usage_screen () {
local ACTION_SET=$mbfl_action_sets_SELECTED_SET
if { mbfl_string_is_not_empty "$ACTION_SET" && mbfl_string_not_equal 'NONE' "$ACTION_SET"; }
then
printf 'Action commands:\n\n'
local ACTION_IDENTIFIER KEY
for ACTION_IDENTIFIER in ${mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]}
do
KEY=${ACTION_SET}-${ACTION_IDENTIFIER}
printf '\t%s [options] [arguments]\n\t\t%s\n\n' \
"$ACTION_IDENTIFIER" "${mbfl_action_sets_DESCRIPTIONS[${KEY}]}"
done
fi
return 0
}
