declare -a mbfl_split_PATH
function mbfl_program_split_path () {
if ((0 == ${#mbfl_split_PATH[@]}))
then
local -a SPLITFIELD
local -i SPLITCOUNT i
mbfl_string_split "$PATH" :
for ((i=0; i < SPLITCOUNT; ++i))
do mbfl_split_PATH[$i]=${SPLITFIELD[$i]}
done
return 0
else return 1
fi
}
function mbfl_program_find_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PROGRAM=${2:?"missing program parameter to '${FUNCNAME}'"}
local mbfl_DUMMY
if mbfl_file_is_absolute "$mbfl_PROGRAM"
then
mbfl_RESULT_VARREF="$mbfl_PROGRAM"
return 0
elif mbfl_string_first_var mbfl_DUMMY "$mbfl_PROGRAM" '/'
then
# The $mbfl_PROGRAM it not an absolute pathname, but it is a relative
# pathname with at least one slash in it.
mbfl_RESULT_VARREF="$mbfl_PROGRAM"
return 0
else
mbfl_program_split_path
local mbfl_PATHNAME
local -i mbfl_I mbfl_NUMBER_OF_COMPONENTS=${#mbfl_split_PATH[@]}
for ((mbfl_I=0; mbfl_I < mbfl_NUMBER_OF_COMPONENTS; ++mbfl_I))
do
printf -v mbfl_PATHNAME '%s/%s' "${mbfl_split_PATH[${mbfl_I}]}" "$mbfl_PROGRAM"
if mbfl_file_is_file "$mbfl_PATHNAME"
then
mbfl_RESULT_VARREF="$mbfl_PATHNAME"
return 0
fi
done
fi
return 1
}
function mbfl_program_find () {
local PROGRAM=${1:?"missing program parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_program_find_var RESULT_VARNAME "$PROGRAM"
then echo "$RESULT_VARNAME"
else return $?
fi
}
if test "$mbfl_INTERACTIVE" != 'yes'
then declare -A mbfl_program_PATHNAMES
fi
function mbfl_declare_program () {
local PROGRAM=${1:?"missing program parameter to '${FUNCNAME}'"}
local PROGRAM_PATHNAME
mbfl_program_find_var PROGRAM_PATHNAME "$PROGRAM"
if mbfl_string_is_not_empty "$PROGRAM_PATHNAME"
then mbfl_file_normalise_var PROGRAM_PATHNAME "$PROGRAM_PATHNAME"
fi
mbfl_program_PATHNAMES["$PROGRAM"]=$PROGRAM_PATHNAME
return 0
}
function mbfl_program_validate_declared () {
local retval PROGRAM PROGRAM_PATHNAME
for PROGRAM in "${!mbfl_program_PATHNAMES[@]}"
do
PROGRAM_PATHNAME=${mbfl_program_PATHNAMES["$PROGRAM"]}
# NOTE We  do *not* want  to test  for the executability  of the
# program here!  This is because we  also want to find a program
# that  is  executable only  by  some  other user,  for  example
# "/sbin/ifconfig" is executable only by root (or it should be).
if mbfl_file_is_file "$PROGRAM_PATHNAME"
then mbfl_message_verbose_printf 'found "%s": "%s"\n' "$PROGRAM" "$PROGRAM_PATHNAME"
else
mbfl_message_verbose_printf '*** not found "%s", path: "%s"\n' "$PROGRAM" "$PROGRAM_PATHNAME"
retval=1
fi
done
return $retval
}
function mbfl_program_found_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PROGRAM=${2:?"missing program name parameter to '${FUNCNAME}'"}
local -r mbfl_PROGRAM_PATHNAME=${mbfl_program_PATHNAMES["$mbfl_PROGRAM"]}
if mbfl_file_is_file "$mbfl_PROGRAM_PATHNAME"
then
mbfl_RESULT_VARREF=$mbfl_PROGRAM_PATHNAME
return 0
else
mbfl_message_error_printf 'invalid pathname for program "%s": "%s"' "$mbfl_PROGRAM" "$mbfl_PROGRAM_PATHNAME"
exit_because_program_not_found
fi
}
function mbfl_program_found () {
local PROGRAM=${1:?"missing program name parameter to '${FUNCNAME}'"}
local RESULT_VARNAME EXIT_STATUS
mbfl_program_found_var RESULT_VARNAME "$PROGRAM"
EXIT_STATUS=$?
if ((0 == EXIT_STATUS))
then
echo "$RESULT_VARNAME"
return 0
else return $EXIT_STATUS
fi
}
function mbfl_program_main_validate_programs () {
mbfl_program_validate_declared || exit_because_program_not_found
}
declare mbfl_program_SUDO_USER=nosudo
declare mbfl_program_SUDO_OPTIONS
declare -r mbfl_program_SUDO=/usr/bin/sudo
declare -r mbfl_program_WHOAMI=/usr/bin/whoami
declare mbfl_program_STDERR_TO_STDOUT=false
declare mbfl_program_BASH=$BASH
declare mbfl_program_BGPID
function mbfl_program_enable_sudo () {
local SUDO=/usr/bin/sudo
if ! test -x "$SUDO"
then mbfl_message_warning_printf 'executable sudo not found: "%s"\n' "$SUDO"
fi
local WHOAMI=/usr/bin/whoami
if ! test -x "$WHOAMI"
then mbfl_message_warning_printf 'executable whoami not found: "%s"\n' "$WHOAMI"
fi
}
function mbfl_program_declare_sudo_user () {
local PERSONA=${1:?"missing sudo user name parameter to '${FUNCNAME}'"}
if mbfl_string_is_username "$PERSONA"
then mbfl_program_SUDO_USER=$PERSONA
else
mbfl_message_error_printf 'attempt to select invalid "sudo" user: "%s"' "$PERSONA"
exit_because_invalid_sudo_username
fi
}
function mbfl_program_reset_sudo_user () {
mbfl_program_SUDO_USER=nosudo
}
function mbfl_program_sudo_user () {
printf '%s\n' "$mbfl_program_SUDO_USER"
}
function mbfl_program_requested_sudo () {
test "$mbfl_program_SUDO_USER" != nosudo
}
function mbfl_program_declare_sudo_options () {
mbfl_program_SUDO_OPTIONS="$*"
}
function mbfl_program_reset_sudo_options () {
mbfl_program_SUDO_OPTIONS=
}
function mbfl_program_redirect_stderr_to_stdout () {
mbfl_program_STDERR_TO_STDOUT=true
}
function mbfl_program_exec () {
local INCHAN=0 OUCHAN=1
local REPLACE=false BACKGROUND=false
mbfl_p_program_exec $INCHAN $OUCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_execbg () {
local INCHAN=${1:?"missing numeric input channel parameter to '${FUNCNAME}'"}
local OUCHAN=${2:?"missing numeric output channel parameter to '${FUNCNAME}'"}
shift 2
local REPLACE=false BACKGROUND=true
mbfl_p_program_exec "$INCHAN" "$OUCHAN" $REPLACE $BACKGROUND "$@"
}
function mbfl_program_replace () {
local INCHAN=0 OUCHAN=1
local REPLACE=true BACKGROUND=false
mbfl_p_program_exec $INCHAN $OUCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_p_program_exec () {
local INCHAN=${1:?"missing input channel parameter to '${FUNCNAME}'"}
local OUCHAN=${2:?"missing output channel parameter to '${FUNCNAME}'"}
local REPLACE=${3:?"missing replace argument parameter to '${FUNCNAME}'"}
local BACKGROUND=${4:?"missing background argument parameter to '${FUNCNAME}'"}
shift 4
local PERSONA=$mbfl_program_SUDO_USER
local USE_SUDO=false
local SUDO=/usr/bin/sudo
local WHOAMI=/usr/bin/whoami
local USERNAME
local SUDO_OPTIONS=$mbfl_program_SUDO_OPTIONS
local STDERR_TO_STDOUT=$mbfl_program_STDERR_TO_STDOUT
mbfl_program_SUDO_USER=nosudo
mbfl_program_SUDO_OPTIONS=
mbfl_program_STDERR_TO_STDOUT=false
if test "$PERSONA" != nosudo
then
if ! test -x "$SUDO"
then
mbfl_message_error_printf 'executable sudo not found: "%s"' "$SUDO"
exit_because_program_not_found
fi
if ! test -x "$WHOAMI"
then
mbfl_message_error_printf 'executable whoami not found: "%s"' "$WHOAMI"
exit_because_program_not_found
fi
if ! USERNAME=$("$WHOAMI")
then
mbfl_message_error 'unable to determine current user name'
exit_because_failure
fi
if test "$PERSONA" != "$USERNAME"
then USE_SUDO=true
fi
fi
if { mbfl_option_test || mbfl_option_show_program; }
then mbfl_p_program_log_1 "$@"
fi
if ! mbfl_option_test
then
# NOTE We might  be tempted to use "command" as  value of "EXEC"
# when we are not replacing  the current process.  We must avoid
# it,  because  "command" causes  an  additional  process to  be
# spawned and this botches  the value of "mbfl_program_BGPID" we
# want to collect when running the process in background.
if $REPLACE
then EXEC=exec
else EXEC=
fi
if $STDERR_TO_STDOUT
then
# Stderr-to-stdout.
if mbfl_string_is_digit "$OUCHAN"
then
# Stderr-to-stdout, digit ouchan.
if mbfl_string_is_digit "$INCHAN"
then
# Stderr-to-stdout, digit ouchan, digit inchan.
if $BACKGROUND
then
# Stderr-to-stdout, digit ouchan, digit inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&1 &
else $EXEC                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&1 &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stdout, digit ouchan, digit inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&1
else $EXEC                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&1
fi
fi
else
# Stderr-to-stdout, digit ouchan, string inchan.
if $BACKGROUND
then
# Stderr-to-stdout, digit ouchan, string inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&1 &
else $EXEC                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&1 &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stdout, digit ouchan, string inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&1
else $EXEC                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&1
fi
fi
fi
else
# Stderr-to-stdout, string ouchan.
if mbfl_string_is_digit "$INCHAN"
then
# Stderr-to-stdout, string ouchan, digit inchan.
if $BACKGROUND
then
# Stderr-to-stdout, string ouchan, digit inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&1 &
else $EXEC                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&1 &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stdout, string ouchan, digit inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&1
else $EXEC                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&1
fi
fi
else
# Stderr-to-stdout, string ouchan, string inchan.
if $BACKGROUND
then
# Stderr-to-stdout, string ouchan, string inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&1 &
else $EXEC                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&1 &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stdout, string ouchan, string inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&1
else $EXEC                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&1
fi
fi
fi
fi
else
# Stderr-to-stderr.
if mbfl_string_is_digit "$OUCHAN"
then
# Stderr-to-stderr, digit ouchan.
if mbfl_string_is_digit "$INCHAN"
then
# Stderr-to-stderr, digit ouchan, digit inchan.
if $BACKGROUND
then
# Stderr-to-stderr, digit ouchan, digit inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" &
else $EXEC                                     "$@" <&"$INCHAN" >&"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stderr, digit ouchan, digit inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN"
else $EXEC                                     "$@" <&"$INCHAN" >&"$OUCHAN"
fi
fi
else
# Stderr-to-stderr, digit ouchan, string inchan.
if $BACKGROUND
then
# Stderr-to-stderr, digit ouchan, string inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" &
else $EXEC                                     "$@" <"$INCHAN" >&"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stderr, digit ouchan, string inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN"
else $EXEC                                     "$@" <"$INCHAN" >&"$OUCHAN"
fi
fi
fi
else
# Stderr-to-stderr, string ouchan.
if mbfl_string_is_digit "$INCHAN"
then
# Stderr-to-stderr, string ouchan, digit inchan.
if $BACKGROUND
then
# Stderr-to-stderr, string ouchan, digit inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" &
else $EXEC                                     "$@" <&"$INCHAN" >"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stderr, string ouchan, digit inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN"
else $EXEC                                     "$@" <&"$INCHAN" >"$OUCHAN"
fi
fi
else
# Stderr-to-stderr, string ouchan, string inchan.
if $BACKGROUND
then
# Stderr-to-stderr, string ouchan, string inchan, background.
local -i EXIT_CODE
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" &
else $EXEC                                     "$@" <"$INCHAN" >"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
return $EXIT_CODE
else
# Stderr-to-stderr, string ouchan, string inchan, foreground.
if $USE_SUDO
then $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN"
else $EXEC                                     "$@" <"$INCHAN" >"$OUCHAN"
fi
fi
fi
fi
fi
fi
}
function mbfl_p_program_log_1 () {
{
mbfl_p_program_log_2 "$@"
if $BACKGROUND
then echo ' &'
else echo
fi
} >&2
}
function mbfl_p_program_log_2 () {
mbfl_p_program_log_3 "$@"
if $STDERR_TO_STDOUT
then echo -n ' 2>&1'
fi
}
function mbfl_p_program_log_3 () {
mbfl_p_program_log_4 "$@"
if mbfl_string_is_digit "$OUCHAN"
then echo -n " >&$OUCHAN"
else echo -n " >'$OUCHAN'"
fi
}
function mbfl_p_program_log_4 () {
mbfl_p_program_log_5 "$@"
if mbfl_string_is_digit "$INCHAN"
then echo -n " <&$INCHAN"
else echo -n " <'$INCHAN'"
fi
}
function mbfl_p_program_log_5 () {
local EXEC
if $REPLACE
then EXEC=exec
else EXEC=command
fi
if $USE_SUDO
then echo -n $EXEC "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@"
else echo -n $EXEC                                     "$@"
fi
}
function mbfl_program_bash_command () {
local COMMAND=${1:?"missing command parameter to '${FUNCNAME}'"}
mbfl_program_exec "$mbfl_program_BASH" -c "$COMMAND"
}
function mbfl_program_bash () {
mbfl_program_exec "$mbfl_program_BASH" "$@"
}
