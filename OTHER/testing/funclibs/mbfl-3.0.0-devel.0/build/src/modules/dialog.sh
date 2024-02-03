function mbfl_dialog_enable_programs () {
mbfl_declare_program stty
}
function mbfl_dialog_yes_or_no () {
local STRING=${1:?"missing prompt string parameter to '${FUNCNAME}'"}
local PROGNAME="${2:-${script_PROGNAME}}"
local PROMPT ANS
printf -v PROMPT '%s: %s? (yes/no) ' "$PROGNAME" "$STRING"
while { IFS= read -r -e -p "$PROMPT" ANS && \
mbfl_string_not_equal "$ANS" 'yes' && \
mbfl_string_not_equal "$ANS" 'no'; }
do printf '%s: please answer yes or no.\n' "$PROGNAME"
done
mbfl_string_equal "$ANS" 'yes'
}
function mbfl_dialog_ask_password_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PROMPT=${2:?"missing prompt parameter to '${FUNCNAME}'"}
local mbfl_PASSWORD mbfl_STTY
mbfl_program_found_var mbfl_STTY stty || exit $?
printf '%s: ' "mbfl_PROMPT" >&2
"$mbfl_STTY" cbreak -echo </dev/tty >/dev/tty 2>&1
IFS= read -rs mbfl_PASSWORD
"$mbfl_STTY" -cbreak echo </dev/tty >/dev/tty 2>&1
echo >&2
mbfl_RESULT_VARREF=$mbfl_PASSWORD
}
function mbfl_dialog_ask_password () {
local PROMPT=${1:?"missing prompt parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_dialog_ask_password_var RESULT_VARNAME "$PROMPT"
then echo "$RV"
else return $?
fi
}
