function mbfl_p_file_backwards_looking_at_double_dot () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local -i INDEX=${2:?"missing pathname index parameter to '${FUNCNAME}'"}
if ((0 < INDEX))
then
local -r ch=${PATHNAME:$((INDEX - 1)):1}
# For the case of standalone double-dot "..":
if   ((1 == INDEX)) && test "$ch" = '.'
then return 0
# For the case of double-dot as last component "/path/to/..":
elif ((1 < INDEX))  && test \( "$ch" = '.' \) -a \( "${PATHNAME:$((INDEX - 2)):1}" = '/' \)
then return 0
else return 1
fi
else return 1
fi
}
function mbfl_p_file_looking_at_component_beginning () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local -i INDEX=${2:?"missing pathname index parameter to '${FUNCNAME}'"}
test 0 -eq $INDEX -o "${PATHNAME:$((INDEX - 1)):1}" = '/'
}
function mbfl_cd () {
local DIRECTORY=${1:?"missing directory parameter to '${FUNCNAME}'"}
shift 1
mbfl_file_normalise_var DIRECTORY "$DIRECTORY"
mbfl_message_verbose "entering directory: '${DIRECTORY}'\n"
mbfl_change_directory "$DIRECTORY" "$@"
}
function mbfl_change_directory () {
local DIRECTORY=${1:?"missing directory parameter to '${FUNCNAME}'"}
shift 1
cd "$@" "$DIRECTORY" &>/dev/null
}
function mbfl_file_extension_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local -i mbfl_I
local mbfl_result
for ((mbfl_I=${#mbfl_PATHNAME}; $mbfl_I > 0; --mbfl_I))
do
if test "${mbfl_PATHNAME:$mbfl_I:1}" = '/'
then break
else
if mbfl_string_is_equal_unquoted_char "$mbfl_PATHNAME" $mbfl_I .
then
if test "${mbfl_PATHNAME:$((mbfl_I - 1)):1}" = '/'
then
# There is no extension.   So we break because there
# is no point in continuing.
break
else
# Found an extension.  Store it and break.
mbfl_result=${mbfl_PATHNAME:$((mbfl_I + 1))}
break
fi
fi
fi
done
mbfl_RESULT_VARREF=$mbfl_result
return 0
}
function mbfl_file_extension () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_extension_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_dirname_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME="${2:-}"
local -i mbfl_I
local mbfl_result=.
for ((mbfl_I=${#mbfl_PATHNAME}; mbfl_I >= 0; --mbfl_I))
do
if test "${mbfl_PATHNAME:${mbfl_I}:1}" = '/'
then
# Skip consecutive slashes.
while test \( ${mbfl_I} -gt 0 \) -a \( "${mbfl_PATHNAME:${mbfl_I}:1}" = '/' \)
do let --mbfl_I
done
mbfl_result=${mbfl_PATHNAME:0:$((mbfl_I + 1))}
break
fi
done
mbfl_RESULT_VARREF=$mbfl_result
return 0
}
function mbfl_file_dirname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_dirname_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_rootname_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local -i mbfl_I=${#mbfl_PATHNAME}
local mbfl_ch mbfl_result
if test \( "$mbfl_PATHNAME" = '/' \) -o \( "$mbfl_PATHNAME" = '.' \) -o \( "$mbfl_PATHNAME" = '..' \)
then mbfl_result=$mbfl_PATHNAME
else
# Skip the trailing slashes.
while ((0 < mbfl_I)) && test "${mbfl_PATHNAME:$((mbfl_I - 1)):1}" = '/'
do let --mbfl_I
done
mbfl_PATHNAME=${mbfl_PATHNAME:0:$mbfl_I}
if ((1 == mbfl_I))
then mbfl_result=$mbfl_PATHNAME
else
for ((mbfl_I=${#mbfl_PATHNAME}; $mbfl_I >= 0; --mbfl_I))
do
mbfl_ch=${mbfl_PATHNAME:$mbfl_I:1}
if test "$mbfl_ch" = '.'
then
if mbfl_p_file_backwards_looking_at_double_dot "$mbfl_PATHNAME" $mbfl_I || \
mbfl_p_file_looking_at_component_beginning "$mbfl_PATHNAME" $mbfl_I
then
# The pathname is one among:
#
#   /path/to/..
#   ..
#
# print the full pathname.
mbfl_result=$mbfl_PATHNAME
break
elif ((0 < mbfl_I))
then
mbfl_result=${mbfl_PATHNAME:0:$mbfl_I}
break
else
mbfl_result=$mbfl_PATHNAME
break
fi
elif test "$mbfl_ch" = '/'
then
mbfl_result=$mbfl_PATHNAME
break
fi
done
fi
fi
mbfl_RESULT_VARREF=$mbfl_result
return 0
}
function mbfl_file_rootname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_rootname_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_tail_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local -i mbfl_I
local result=$mbfl_PATHNAME
for ((mbfl_I=${#mbfl_PATHNAME}; $mbfl_I >= 0; --mbfl_I))
do
if test "${mbfl_PATHNAME:$mbfl_I:1}" = '/'
then
result=${mbfl_PATHNAME:$((mbfl_I + 1))}
break
fi
done
mbfl_RESULT_VARREF=$result
return 0
}
function mbfl_file_tail () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_tail_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_split () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local i=0 last_found=0 len=${#PATHNAME}
mbfl_string_skip "$PATHNAME" i '/'
last_found=$i
for ((SPLITCOUNT=0; $i < $len; ++i))
do
if test "${PATHNAME:$i:1}" = '/'
then
SPLITPATH[$SPLITCOUNT]=${PATHNAME:$last_found:$(($i-$last_found))}
let ++SPLITCOUNT
let ++i
mbfl_string_skip "$PATHNAME" i '/'
last_found=$i
fi
done
SPLITPATH[$SPLITCOUNT]=${PATHNAME:$last_found}
let ++SPLITCOUNT
return 0
}
function mbfl_file_strip_trailing_slash_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local -i mbfl_I=${#mbfl_PATHNAME}
local mbfl_result
while ((0 < mbfl_I)) && test "${mbfl_PATHNAME:$((mbfl_I - 1)):1}" = '/'
do let --mbfl_I
done
if ((0 == mbfl_I))
then mbfl_result='.'
else mbfl_result=${mbfl_PATHNAME:0:$mbfl_I}
fi
mbfl_RESULT_VARREF=$mbfl_result
}
function mbfl_file_strip_trailing_slash () {
local mbfl_PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_strip_trailing_slash_var RESULT_VARNAME "$mbfl_PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_strip_leading_slash_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local mbfl_result
if test "${mbfl_PATHNAME:0:1}" = '/'
then
local -i mbfl_I=1 mbfl_len=${#mbfl_PATHNAME}
# Skip the leading slashes.
while ((mbfl_I < mbfl_len)) && test "${mbfl_PATHNAME:$mbfl_I:1}" = '/'
do let ++mbfl_I
done
if ((mbfl_len == mbfl_I))
then mbfl_result='.'
else mbfl_result=${mbfl_PATHNAME:$mbfl_I}
fi
else mbfl_result=$mbfl_PATHNAME
fi
mbfl_RESULT_VARREF=$mbfl_result
}
function mbfl_file_strip_leading_slash () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_strip_leading_slash_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_normalise_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local mbfl_PREFIX="${3:-}"
local mbfl_result mbfl_ORGPWD=$PWD
if mbfl_file_is_absolute "$mbfl_PATHNAME"
then
mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
mbfl_RESULT_VARREF=$mbfl_result
elif mbfl_file_is_directory "$mbfl_PREFIX"
then
mbfl_PATHNAME=${mbfl_PREFIX}/${mbfl_PATHNAME}
mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
mbfl_RESULT_VARREF=$mbfl_result
elif mbfl_string_is_not_empty "$mbfl_PREFIX"
then
local mbfl_PATHNAME1 mbfl_PATHNAME2
mbfl_p_file_remove_dots_from_pathname_var mbfl_PREFIX   "$mbfl_PREFIX"
mbfl_p_file_remove_dots_from_pathname_var mbfl_PATHNAME1 "$mbfl_PATHNAME"
mbfl_file_strip_trailing_slash_var        mbfl_PATHNAME2 "$mbfl_PATHNAME1"
printf -v mbfl_RESULT_VARREF '%s/%s' "$mbfl_PREFIX" "$mbfl_PATHNAME2"
else
mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
mbfl_RESULT_VARREF=$mbfl_result
fi
cd "$mbfl_ORGPWD" >/dev/null
return 0
}
function mbfl_file_normalise () {
local mbfl_PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local mbfl_PREFIX="${2:-}"
local RESULT_VARNAME
if mbfl_file_normalise_var RESULT_VARNAME "$mbfl_PATHNAME" "$mbfl_PREFIX"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_p_file_remove_dots_from_pathname_var () {
local mbfl_a_variable_RESULT_VARREF1=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n RESULT_VARREF1=$mbfl_a_variable_RESULT_VARREF1
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local -a SPLITPATH
local -i SPLITCOUNT
local -a mbfl_output
local -i mbfl_output_counter mbfl_input_counter
mbfl_file_split "$mbfl_PATHNAME"
for ((mbfl_input_counter=0, mbfl_output_counter=0; mbfl_input_counter < SPLITCOUNT; ++mbfl_input_counter))
do
case ${SPLITPATH[$mbfl_input_counter]} in
'.')
;;
'..')
let --mbfl_output_counter
;;
*)
mbfl_output[$mbfl_output_counter]=${SPLITPATH[$mbfl_input_counter]}
let ++mbfl_output_counter
;;
esac
done
{
local -i i
mbfl_PATHNAME=${mbfl_output[0]}
for ((i=1; $i < $mbfl_output_counter; ++i))
do mbfl_PATHNAME+=/${mbfl_output[$i]}
done
}
RESULT_VARREF1=$mbfl_PATHNAME
}
function mbfl_p_file_normalise1_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF1=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF1=$mbfl_a_variable_mbfl_RESULT_VARREF1
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
if mbfl_file_is_directory "$mbfl_PATHNAME"
then mbfl_p_file_normalise2_var mbfl_RESULT_VARREF1 "$mbfl_PATHNAME"
else
local mbfl_TAILNAME mbfl_DIRNAME
mbfl_file_tail_var    mbfl_TAILNAME "$mbfl_PATHNAME"
mbfl_file_dirname_var mbfl_DIRNAME  "$mbfl_PATHNAME"
if mbfl_file_is_directory "$mbfl_DIRNAME"
then mbfl_p_file_normalise2_var mbfl_RESULT_VARREF1 "$mbfl_DIRNAME" "$mbfl_TAILNAME"
else mbfl_file_strip_trailing_slash_var mbfl_RESULT_VARREF1 "$mbfl_PATHNAME"
fi
fi
}
function mbfl_p_file_normalise2_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF2=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF2=$mbfl_a_variable_mbfl_RESULT_VARREF2
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local mbfl_TAILNAME="${3:-}"
cd "$mbfl_PATHNAME" >/dev/null
if mbfl_string_is_not_empty "$mbfl_TAILNAME"
then printf -v mbfl_RESULT_VARREF2 '%s/%s' "$PWD" "$mbfl_TAILNAME"
else mbfl_RESULT_VARREF2=$PWD
fi
cd - >/dev/null
}
function mbfl_file_enable_realpath () {
mbfl_declare_program realpath
}
function mbfl_file_realpath () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_REALPATH
mbfl_variable_alloc mbfl_a_variable_REALPATH
local  $mbfl_a_variable_REALPATH
local -n REALPATH=$mbfl_a_variable_REALPATH

mbfl_program_found_var $mbfl_a_variable_REALPATH realpath || exit $?
mbfl_program_exec "$REALPATH" "$@" -- "$PATHNAME"
}
function mbfl_file_realpath_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
shift 2
if ! mbfl_RESULT_VARREF=$(mbfl_file_realpath "$mbfl_PATHNAME" "$@")
then return $?
fi
}
function mbfl_file_subpathname_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
local mbfl_BASEDIR=${3:?"missing base directory parameter to '${FUNCNAME}'"}
if test "${mbfl_BASEDIR:$((${#mbfl_BASEDIR}-1))}" = '/'
then mbfl_BASEDIR=${mbfl_BASEDIR:0:$((${#mbfl_BASEDIR}-1))}
fi
if test "$mbfl_PATHNAME" = "$mbfl_BASEDIR"
then
mbfl_RESULT_VARREF='./'
return 0
elif test "${mbfl_PATHNAME:0:${#mbfl_BASEDIR}}" = "$mbfl_BASEDIR"
then
printf -v mbfl_RESULT_VARREF './%s' "${mbfl_PATHNAME:$((${#mbfl_BASEDIR}+1))}"
return 0
else return 1
fi
}
function mbfl_file_subpathname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local BASEDIR=${2:?"missing base directory parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_file_subpathname_var RESULT_VARNAME "$PATHNAME" "$BASEDIR"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_is_absolute () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
test "${PATHNAME:0:1}" = '/'
}
function mbfl_file_is_absolute_dirname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_is_directory "$PATHNAME" && mbfl_file_is_absolute "$PATHNAME"
}
function mbfl_file_is_absolute_filename () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_is_file "$PATHNAME" && mbfl_file_is_absolute "$PATHNAME"
}
function mbfl_file_is_relative () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
test "${PATHNAME:0:1}" != '/'
}
function mbfl_file_is_relative_dirname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_is_directory "$PATHNAME" && mbfl_file_is_relative "$PATHNAME"
}
function mbfl_file_is_relative_filename () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_is_file "$PATHNAME" && mbfl_file_is_relative "$PATHNAME"
}
function mbfl_file_find_tmpdir_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_TMPDIR="${2:-"$mbfl_option_mbfl_TMPDIR"}"
if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
then
mbfl_RESULT_VARREF=$mbfl_TMPDIR
return 0
elif mbfl_string_is_not_empty "$USER"
then
mbfl_TMPDIR=/tmp/${USER}
if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
then
mbfl_RESULT_VARREF=$mbfl_TMPDIR
return 0
else return 1
fi
else
mbfl_TMPDIR=/tmp
if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
then
mbfl_RESULT_VARREF=$mbfl_TMPDIR
return 0
else
mbfl_message_error 'cannot find usable value for "mbfl_TMPDIR"'
return 1
fi
fi
}
function mbfl_file_find_tmpdir () {
local TMPDIR="${1:-"$mbfl_option_TMPDIR"}"
local RESULT_VARNAME
if mbfl_file_find_tmpdir_var RESULT_VARNAME "$TMPDIR"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_enable_remove () {
mbfl_declare_program rm
mbfl_declare_program rmdir
}
function mbfl_exec_rm () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_RM
mbfl_variable_alloc mbfl_a_variable_RM
local  $mbfl_a_variable_RM
local -n RM=$mbfl_a_variable_RM

local FLAGS
mbfl_program_found_var $mbfl_a_variable_RM rm || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$RM" ${FLAGS} "$@" -- "$PATHNAME"
}
function mbfl_file_remove () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS='--force --recursive'
if ! mbfl_option_test
then
if ! mbfl_file_exists "$PATHNAME"
then
mbfl_message_error_printf 'pathname does not exist: "%s"' "$PATHNAME"
return 1
fi
fi
mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_file () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS='--force'
if ! mbfl_option_test
then
if ! mbfl_file_is_file "$PATHNAME"
then
mbfl_message_error_printf 'pathname is not a file: "%s"' "$PATHNAME"
return 1
fi
fi
mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_symlink () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS='--force'
if ! mbfl_option_test
then
if ! mbfl_file_is_symlink "$PATHNAME"
then
mbfl_message_error_printf 'pathname is not a symbolic link: "%s"' "$PATHNAME"
return 1
fi
fi
mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_file_or_symlink () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS='--force'
if ! mbfl_option_test
then
if      ! mbfl_file_is_file    "$PATHNAME" ||
! mbfl_file_is_symlink "$PATHNAME"
then
mbfl_message_error_printf 'pathname is neither a file nor a symbolic link: "%s"' "$PATHNAME"
return 1
fi
fi
mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_exec_rmdir () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_RMDIR
mbfl_variable_alloc mbfl_a_variable_RMDIR
local  $mbfl_a_variable_RMDIR
local -n RMDIR=$mbfl_a_variable_RMDIR

local FLAGS
mbfl_program_found_var $mbfl_a_variable_RMDIR rmdir || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$RMDIR" $FLAGS "$@" "$PATHNAME"
}
function mbfl_file_remove_directory () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local REMOVE_SILENTLY="${2:-no}"
local FLAGS
if mbfl_file_is_directory "$PATHNAME"
then
if test "$REMOVE_SILENTLY" = 'yes'
then FLAGS+=' --ignore-fail-on-non-empty'
fi
mbfl_exec_rmdir "$PATHNAME" ${FLAGS}
else
mbfl_message_error "pathname is not a directory '${PATHNAME}'"
return 1
fi
}
function mbfl_file_remove_directory_silently () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_remove_directory "$PATHNAME" yes
}
function mbfl_file_enable_copy () {
mbfl_declare_program cp
}
function mbfl_exec_cp () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_CP
mbfl_variable_alloc mbfl_a_variable_CP
local  $mbfl_a_variable_CP
local -n CP=$mbfl_a_variable_CP

local FLAGS
mbfl_program_found_var $mbfl_a_variable_CP cp || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$CP" ${FLAGS} "$@" -- "$SOURCE" "$TARGET"
}
function mbfl_exec_cp_to_dir () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_CP
mbfl_variable_alloc mbfl_a_variable_CP
local  $mbfl_a_variable_CP
local -n CP=$mbfl_a_variable_CP

local FLAGS
mbfl_program_found_var $mbfl_a_variable_CP cp || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$CP" ${FLAGS} "$@" --target-directory="${TARGET}/" -- "$SOURCE"
}
function mbfl_file_copy () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
if ! mbfl_option_test
then
if ! mbfl_file_is_readable "$SOURCE"
then
mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
return 1
fi
fi
if mbfl_file_exists "$TARGET"
then
if mbfl_file_is_directory "$TARGET"
then mbfl_message_error_printf 'target of copy exists and it is a directory "%s"' "$TARGET"
else mbfl_message_error_printf 'target file of copy already exists "%s"' "$TARGET"
fi
return 1
else mbfl_exec_cp "$SOURCE" "$TARGET" "$@"
fi
}
function mbfl_file_copy_to_directory () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
if ! mbfl_option_test
then
if      ! mbfl_file_is_readable  "$SOURCE" print_error || \
! mbfl_file_exists       "$TARGET" print_error || \
! mbfl_file_is_directory "$TARGET" print_error
then
mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
return 1
fi
fi
mbfl_exec_cp_to_dir "$SOURCE" "$TARGET" "$@"
}
function mbfl_file_enable_move () {
mbfl_declare_program mv
}
function mbfl_exec_mv () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_MV
mbfl_variable_alloc mbfl_a_variable_MV
local  $mbfl_a_variable_MV
local -n MV=$mbfl_a_variable_MV

local FLAGS
mbfl_program_found_var $mbfl_a_variable_MV mv || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$MV" ${FLAGS} "$@" -- "$SOURCE" "$TARGET"
}
function mbfl_exec_mv_to_dir () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_MV
mbfl_variable_alloc mbfl_a_variable_MV
local  $mbfl_a_variable_MV
local -n MV=$mbfl_a_variable_MV

local FLAGS
mbfl_program_found_var $mbfl_a_variable_MV mv || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$MV" ${FLAGS} "$@" --target-directory="${TARGET}/" -- "$SOURCE"
}
function mbfl_file_move () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
if ! mbfl_option_test
then
if ! mbfl_file_pathname_is_readable "$SOURCE" print_error
then
mbfl_message_error_printf 'moving "%s"' "$SOURCE"
return 1
fi
fi
mbfl_exec_mv "$SOURCE" "$TARGET" "$@"
}
function mbfl_file_move_to_directory () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
if ! mbfl_option_test
then
if      ! mbfl_file_pathname_is_readable "$SOURCE" print_error || \
! mbfl_file_exists               "$TARGET" print_error || \
! mbfl_file_is_directory         "$TARGET" print_error
then
mbfl_message_error_printf 'moving file "%s"' "$SOURCE"
return 1
fi
fi
mbfl_exec_mv_to_dir "$SOURCE" "$TARGET" "$@"
}
function mbfl_file_enable_make_directory () {
mbfl_declare_program mkdir
}
function mbfl_file_make_directory () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local PERMISSIONS="${2:-0775}"
local mbfl_a_variable_MKDIR
mbfl_variable_alloc mbfl_a_variable_MKDIR
local  $mbfl_a_variable_MKDIR
local -n MKDIR=$mbfl_a_variable_MKDIR

local FLAGS
mbfl_program_found_var $mbfl_a_variable_MKDIR mkdir || exit $?
FLAGS="--parents --mode=${PERMISSIONS}"
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$MKDIR" $FLAGS -- "$PATHNAME"
}
function mbfl_file_make_if_not_directory () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local PERMISSIONS="${2:-0775}"
mbfl_file_is_directory   "$PATHNAME" || \
mbfl_file_make_directory "$PATHNAME" "$PERMISSIONS"
mbfl_program_reset_sudo_user
}
function mbfl_file_enable_symlink () {
mbfl_declare_program ln
}
function mbfl_exec_ln () {
local ORIGINAL_NAME=${1:?"missing original name parameter to '${FUNCNAME}'"}
local LINK_NAME=${2:?"missing link name parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_LN
mbfl_variable_alloc mbfl_a_variable_LN
local  $mbfl_a_variable_LN
local -n LN=$mbfl_a_variable_LN

local FLAGS
mbfl_program_found_var $mbfl_a_variable_LN ln || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$LN" ${FLAGS} "$@" -- "$ORIGINAL_NAME" "$LINK_NAME"
}
function mbfl_file_symlink () {
local ORIGINAL_NAME=${1:?"missing original name parameter to '${FUNCNAME}'"}
local SYMLINK_NAME=${2:?"missing symbolic link name parameter to '${FUNCNAME}'"}
mbfl_exec_ln "$ORIGINAL_NAME" "$SYMLINK_NAME" --symbolic
}
function mbfl_file_enable_listing () {
mbfl_declare_program ls
mbfl_declare_program readlink
}
function mbfl_file_listing () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift 1
local mbfl_a_variable_LS
mbfl_variable_alloc mbfl_a_variable_LS
local  $mbfl_a_variable_LS
local -n LS=$mbfl_a_variable_LS

mbfl_program_found_var $mbfl_a_variable_LS ls || exit $?
mbfl_program_exec "$LS" "$@" -- "$PATHNAME"
}
function mbfl_file_p_invoke_ls () {
local mbfl_a_variable_LS
mbfl_variable_alloc mbfl_a_variable_LS
local  $mbfl_a_variable_LS
local -n LS=$mbfl_a_variable_LS

mbfl_program_found_var $mbfl_a_variable_LS ls || exit $?
mbfl_file_is_directory "$PATHNAME" && LS_FLAGS+=' -d'
mbfl_program_exec "$LS" ${LS_FLAGS} "$PATHNAME"
}
function mbfl_file_long_listing () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_listing "$PATHNAME" '-l'
}
function mbfl_exec_readlink () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_READLINK
mbfl_variable_alloc mbfl_a_variable_READLINK
local  $mbfl_a_variable_READLINK
local -n READLINK=$mbfl_a_variable_READLINK

local FLAGS
mbfl_program_found_var $mbfl_a_variable_READLINK readlink || exit $?
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$READLINK" ${FLAGS} "$@" -- "$PATHNAME"
}
function mbfl_file_read_link () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_exec_readlink "$PATHNAME"
}
function mbfl_file_normalise_link () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_exec_readlink "$PATHNAME" --canonicalize --no-newline
}
function mbfl_p_file_print_error_return_result () {
local RESULT=${1:?"missing result parameter to '${FUNCNAME}'"}
if test ${RESULT} != 0 -a "$PRINT_ERROR" = 'print_error'
then mbfl_message_error "$ERROR_MESSAGE"
fi
return $RESULT
}
function mbfl_file_exists () {
local PATHNAME="${1:-}"
test -n "$PATHNAME" -a -e "$PATHNAME"
}
function mbfl_file_pathname_is_readable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
local ERROR_MESSAGE="not readable pathname '${PATHNAME}'"
test -n "$PATHNAME" -a -r "$PATHNAME"
mbfl_p_file_print_error_return_result $?
}
function mbfl_file_pathname_is_writable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
local ERROR_MESSAGE="not writable pathname '${PATHNAME}'"
test -n "$PATHNAME" -a -w "$PATHNAME"
mbfl_p_file_print_error_return_result $?
}
function mbfl_file_pathname_is_executable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
local ERROR_MESSAGE="not executable pathname '${PATHNAME}'"
test -n "$PATHNAME" -a -x "$PATHNAME"
mbfl_p_file_print_error_return_result $?
}
function mbfl_file_is_file () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
local ERROR_MESSAGE="unexistent file '${PATHNAME}'"
test -n "$PATHNAME" -a -f "$PATHNAME"
mbfl_p_file_print_error_return_result $?
}
function mbfl_file_is_readable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_writable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_executable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_directory () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
local ERROR_MESSAGE="unexistent directory '${PATHNAME}'"
test -n "$PATHNAME" -a -d "$PATHNAME"
mbfl_p_file_print_error_return_result $?
}
function mbfl_file_directory_is_readable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_is_writable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_is_executable () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_validate_writability () {
local DIRECTORY=${1:?"missing directory pathname parameter to '${FUNCNAME}'"}
local DESCRIPTION=${2:?"missing directory description parameter to '${FUNCNAME}'"}
mbfl_message_verbose "validating ${DESCRIPTION} directory '${DIRECTORY}'\n"
mbfl_file_is_directory "$DIRECTORY" print_error && mbfl_file_directory_is_writable "$DIRECTORY" print_error
local CODE=$?
if test $CODE != 0
then mbfl_message_error_printf 'unwritable %s directory: "%s"' "$DESCRIPTION" "$DIRECTORY"
fi
return $CODE
}
function mbfl_file_is_symlink () {
local PATHNAME="${1:-}"
local PRINT_ERROR="${2:-no}"
local ERROR_MESSAGE="not a symbolic link pathname '${PATHNAME}'"
test -n "$PATHNAME" -a -L "$PATHNAME"
mbfl_p_file_print_error_return_result $?
}
function mbfl_file_enable_tar () {
mbfl_declare_program tar
}
function mbfl_exec_tar () {
local mbfl_a_variable_TAR
mbfl_variable_alloc mbfl_a_variable_TAR
local  $mbfl_a_variable_TAR
local -n TAR=$mbfl_a_variable_TAR

local FLAGS
mbfl_program_found_var $mbfl_a_variable_TAR tar || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$TAR" ${FLAGS} "$@"
}
function mbfl_tar_exec () {
mbfl_exec_tar "$@"
}
function mbfl_tar_create_to_stdout () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
shift
mbfl_exec_tar --directory="$DIRECTORY" --create --file=- "$@" .
}
function mbfl_tar_extract_from_stdin () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
shift
mbfl_exec_tar --directory="$DIRECTORY" --extract --file=- "$@"
}
function mbfl_tar_extract_from_file () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
local ARCHIVE_FILENAME=${2:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_exec_tar --directory="$DIRECTORY" --extract --file="$ARCHIVE_FILENAME" "$@"
}
function mbfl_tar_create_to_file () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
local ARCHIVE_FILENAME=${2:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_exec_tar --directory="$DIRECTORY" --create --file="$ARCHIVE_FILENAME" "$@" .
}
function mbfl_tar_archive_directory_to_file () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
local ARCHIVE_FILENAME=${2:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift 2
local PARENT DIRNAME
mbfl_file_dirname_var PARENT "$DIRECTORY"
mbfl_file_tail_var DIRNAME "$DIRECTORY"
mbfl_exec_tar --directory="$PARENT" --create --file="$ARCHIVE_FILENAME" "$@" "$DIRNAME"
}
function mbfl_tar_list () {
local ARCHIVE_FILENAME=${1:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift
mbfl_exec_tar --list --file="$ARCHIVE_FILENAME" "$@"
}
function mbfl_file_enable_permissions () {
mbfl_file_enable_stat
mbfl_declare_program chmod
}
function mbfl_exec_chmod () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_CHMOD
mbfl_variable_alloc mbfl_a_variable_CHMOD
local  $mbfl_a_variable_CHMOD
local -n CHMOD=$mbfl_a_variable_CHMOD

local FLAGS
mbfl_program_found_var $mbfl_a_variable_CHMOD chmod || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$CHMOD" ${FLAGS} "$@" -- "$PATHNAME"
}
function mbfl_file_get_permissions () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_stat "$PATHNAME" --printf='0%a\n'
}
function mbfl_file_set_permissions () {
local PERMISSIONS=${1:?"missing permissions parameter to '${FUNCNAME}'"}
local PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_exec_chmod "$PATHNAME" "$PERMISSIONS"
}
function mbfl_file_get_permissions_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --format='0%a')
}
function mbfl_file_enable_owner_and_group () {
mbfl_file_enable_stat
mbfl_declare_program chown
mbfl_declare_program chgrp
}
function mbfl_exec_chown () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_CHOWN
mbfl_variable_alloc mbfl_a_variable_CHOWN
local  $mbfl_a_variable_CHOWN
local -n CHOWN=$mbfl_a_variable_CHOWN

local FLAGS
mbfl_program_found_var $mbfl_a_variable_CHOWN chown || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$CHOWN" ${FLAGS} "$@" -- "$PATHNAME"
}
function mbfl_exec_chgrp () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_CHGRP
mbfl_variable_alloc mbfl_a_variable_CHGRP
local  $mbfl_a_variable_CHGRP
local -n CHGRP=$mbfl_a_variable_CHGRP

local FLAGS
mbfl_program_found_var $mbfl_a_variable_CHGRP chgrp || exit $?
mbfl_option_verbose_program && FLAGS+=' --verbose'
mbfl_program_exec "$CHGRP" ${FLAGS} "$@" -- "$PATHNAME"
}
function mbfl_file_set_owner () {
local OWNER=${1:?"missing owner parameter to '${FUNCNAME}'"}
local PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_exec_chown "$PATHNAME" "$OWNER" "$@"
}
function mbfl_file_set_group () {
local GROUP=${1:?"missing group parameter to '${FUNCNAME}'"}
local PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_exec_chgrp "$PATHNAME" "$GROUP" "$@"
}
function mbfl_file_append () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local FILENAME=${2:?"missing file name parameter to '${FUNCNAME}'"}
mbfl_program_bash_command "printf '%s' '${STRING}' >>'${FILENAME}'"
}
function mbfl_file_write () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local FILENAME=${2:?"missing file name parameter to '${FUNCNAME}'"}
mbfl_program_bash_command "printf '%s' '${STRING}' >'${FILENAME}'"
}
function mbfl_file_read () {
local FILENAME=${1:?"missing file name parameter to '${FUNCNAME}'"}
mbfl_program_bash_command "printf '%s' \"\$(<${FILENAME})\""
}
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
mbfl_p_file_compress_KEEP_ORIGINAL=false
mbfl_p_file_compress_TO_STDOUT=false
function mbfl_file_enable_compress () {
mbfl_declare_program gzip
mbfl_declare_program bzip2
mbfl_declare_program lzip
mbfl_declare_program xz
mbfl_file_compress_select_gzip
mbfl_file_compress_nokeep
}
function mbfl_file_compress_keep     () { mbfl_p_file_compress_KEEP_ORIGINAL=true;  }
function mbfl_file_compress_nokeep   () { mbfl_p_file_compress_KEEP_ORIGINAL=false; }
function mbfl_file_compress_stdout   () { mbfl_p_file_compress_TO_STDOUT=true;      }
function mbfl_file_compress_nostdout () { mbfl_p_file_compress_TO_STDOUT=false;     }
function mbfl_file_compress_select_gzip () {
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
}
function mbfl_file_compress_select_bzip2 () {
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_bzip2
}
function mbfl_file_compress_select_bzip () {
mbfl_file_compress_select_bzip2
}
function mbfl_file_compress_select_lzip () {
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_lzip
}
function mbfl_file_compress_select_xz () {
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_xz
}
function mbfl_file_compress () {
local FILE=${1:?"missing uncompressed source file parameter to '${FUNCNAME}'"}
shift
mbfl_p_file_compress compress "$FILE" "$@"
}
function mbfl_file_decompress () {
local FILE=${1:?"missing compressed source file parameter to '${FUNCNAME}'"}
shift
mbfl_p_file_compress decompress "$FILE" "$@"
}
function mbfl_p_file_compress () {
local MODE=${1:?"missing compression/decompression mode parameter to '${FUNCNAME}'"}
local FILE=${2:?"missing target file parameter to '${FUNCNAME}'"}
shift 2
if mbfl_file_is_file "$FILE"
then ${mbfl_p_file_compress_FUNCTION} ${MODE} "$FILE" "$@"
else
mbfl_message_error_printf 'compression target is not a file "%s"' "$FILE"
return 1
fi
}
function mbfl_p_file_compress_gzip () {
local COMPRESS=${1:?"missing compress/decompress mode parameter to '${FUNCNAME}'"}
local SOURCE=${2:?"missing source file parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_COMPRESSOR
mbfl_variable_alloc mbfl_a_variable_COMPRESSOR
local  $mbfl_a_variable_COMPRESSOR
local -n COMPRESSOR=$mbfl_a_variable_COMPRESSOR

local FLAGS='--force' DEST
mbfl_program_found_var $mbfl_a_variable_COMPRESSOR gzip || exit $?
case $COMPRESS in
compress)
printf -v DEST '%s.gz' "$SOURCE"
;;
decompress)
mbfl_file_rootname_var DEST "$SOURCE"
FLAGS+=' --decompress'
;;
*)
mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
exit_failure
;;
esac
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
if $mbfl_p_file_compress_TO_STDOUT
then
# When   writing   to   stdout:  we   ignore   the   keep/nokeep
# configuration and always keep.
FLAGS+=' --keep --stdout'
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
else
# The   output  goes   to   a  file:   honour  the   keep/nokeep
# configuration.
if $mbfl_p_file_compress_KEEP_ORIGINAL
then FLAGS+=' --keep'
fi
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
fi
}
function mbfl_p_file_compress_bzip2 () {
local COMPRESS=${1:?"missing compress/decompress mode parameter to '${FUNCNAME}'"}
local SOURCE=${2:?"missing target file parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_COMPRESSOR
mbfl_variable_alloc mbfl_a_variable_COMPRESSOR
local  $mbfl_a_variable_COMPRESSOR
local -n COMPRESSOR=$mbfl_a_variable_COMPRESSOR

local FLAGS='--force' DEST
mbfl_program_found_var $mbfl_a_variable_COMPRESSOR bzip2 || exit $?
case $COMPRESS in
compress)
printf -v DEST '%s.bz2' "$SOURCE"
FLAGS+=' --compress'
;;
decompress)
mbfl_file_rootname_var DEST "$SOURCE"
FLAGS+=' --decompress'
;;
*)
mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
exit_failure
;;
esac
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
if $mbfl_p_file_compress_TO_STDOUT
then
# When   writing   to   stdout:  we   ignore   the   keep/nokeep
# configuration and always keep.
FLAGS+=' --keep --stdout'
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
else
# The   output  goes   to   a  file:   honour  the   keep/nokeep
# configuration.
if $mbfl_p_file_compress_KEEP_ORIGINAL
then FLAGS+=' --keep'
fi
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
fi
}
function mbfl_p_file_compress_lzip () {
local COMPRESS=${1:?"missing compress/decompress mode parameter to '${FUNCNAME}'"}
local SOURCE=${2:?"missing source file parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_COMPRESSOR
mbfl_variable_alloc mbfl_a_variable_COMPRESSOR
local  $mbfl_a_variable_COMPRESSOR
local -n COMPRESSOR=$mbfl_a_variable_COMPRESSOR

local FLAGS='--force' DEST
mbfl_program_found_var $mbfl_a_variable_COMPRESSOR lzip || exit $?
case $COMPRESS in
compress)
printf -v DEST '%s.lz' "$SOURCE"
;;
decompress)
mbfl_file_rootname_var DEST "$SOURCE"
FLAGS+=' --decompress'
;;
*)
mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
exit_failure
;;
esac
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
if $mbfl_p_file_compress_TO_STDOUT
then
# When   writing   to   stdout:  we   ignore   the   keep/nokeep
# configuration and always keep.
FLAGS+=' --keep --stdout'
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
else
# The   output  goes   to   a  file:   honour  the   keep/nokeep
# configuration.
if $mbfl_p_file_compress_KEEP_ORIGINAL
then FLAGS+=' --keep'
fi
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
fi
}
function mbfl_p_file_compress_xz () {
local COMPRESS=${1:?"missing compress/decompress mode parameter to '${FUNCNAME}'"}
local SOURCE=${2:?"missing source file parameter to '${FUNCNAME}'"}
shift 2
local mbfl_a_variable_COMPRESSOR
mbfl_variable_alloc mbfl_a_variable_COMPRESSOR
local  $mbfl_a_variable_COMPRESSOR
local -n COMPRESSOR=$mbfl_a_variable_COMPRESSOR

local FLAGS='--force' DEST
mbfl_program_found_var $mbfl_a_variable_COMPRESSOR xz || exit $?
case $COMPRESS in
compress)
printf -v DEST '%s.xz' "$SOURCE"
;;
decompress)
mbfl_file_rootname_var DEST "$SOURCE"
FLAGS+=' --decompress'
;;
*)
mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
exit_failure
;;
esac
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
if $mbfl_p_file_compress_TO_STDOUT
then
# When   writing   to   stdout:  we   ignore   the   keep/nokeep
# configuration and always keep.
FLAGS+=' --keep --stdout'
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
else
# The   output  goes   to   a  file:   honour  the   keep/nokeep
# configuration.
if $mbfl_p_file_compress_KEEP_ORIGINAL
then FLAGS+=' --keep'
fi
mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
fi
}
function mbfl_file_enable_stat () {
mbfl_declare_program stat
}
function mbfl_file_stat () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
local mbfl_a_variable_STAT
mbfl_variable_alloc mbfl_a_variable_STAT
local  $mbfl_a_variable_STAT
local -n STAT=$mbfl_a_variable_STAT

local FLAGS
mbfl_program_found_var $mbfl_a_variable_STAT stat || exit $?
mbfl_program_exec "$STAT" ${FLAGS} "$@" -- "$PATHNAME"
}
function mbfl_file_stat_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" "$@")
}
function mbfl_file_get_owner () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_stat "$PATHNAME" --format='%U'
}
function mbfl_file_get_group () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_stat "$PATHNAME" --format='%G'
}
function mbfl_file_get_size () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_stat "$PATHNAME" --format='%s'
}
function mbfl_file_get_owner_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%U')
}
function mbfl_file_get_group_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%G')
}
function mbfl_file_get_size_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%s')
}
