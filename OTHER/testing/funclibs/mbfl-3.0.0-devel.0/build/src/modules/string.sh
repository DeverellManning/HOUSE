function mbfl_string_is_quoted_char () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local -i POS=${2:?"missing position parameter to '${FUNCNAME}'"}
local -i COUNT
let --POS
for ((COUNT=0; POS >= 0; --POS))
do
if test "${STRING:${POS}:1}" = \\
then let ++COUNT
else break
fi
done
let ${COUNT}%2
}
function mbfl_string_is_equal_unquoted_char () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local -i POS=${2:?"missing position parameter to '${FUNCNAME}'"}
local CHAR=${3:?"missing known char parameter to '${FUNCNAME}'"}
if test "${STRING:${POS}:1}" != "$CHAR"
then mbfl_string_is_quoted_char "$STRING" "$POS"
fi
}
function mbfl_string_quote_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_STRING="${2:-}"
local -i mbfl_I
local mbfl_ch
mbfl_RESULT_VARREF=
for ((mbfl_I=0; mbfl_I < ${#mbfl_STRING}; ++mbfl_I))
do
mbfl_ch=${mbfl_STRING:$mbfl_I:1}
if test "$mbfl_ch" = \\
then mbfl_ch=\\\\
fi
mbfl_RESULT_VARREF+=$mbfl_ch
done
}
function mbfl_string_quote () {
local STRING="${1:-}"
local RESULT_VARNAME
if mbfl_string_quote_var RESULT_VARNAME "$STRING"
then printf '%s\n' "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_string_length () {
local STRING="${1:-}"
echo ${#STRING}
}
function mbfl_string_length_equal_to () {
local -i LENGTH=${1:?"missing length of string parameter to '${FUNCNAME}'"}
local STRING="${2:-}"
test ${#STRING} -eq $LENGTH
}
function mbfl_string_is_empty () {
local STRING="${1:-}"
test -z "$STRING"
}
function mbfl_string_is_not_empty () {
local STRING="${1:-}"
test -n "$STRING"
}
function mbfl_string_first_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_STRING=${2:?"missing string parameter to '${FUNCNAME}'"}
local mbfl_CHAR=${3:?"missing char parameter to '${FUNCNAME}'"}
local mbfl_BEGIN="${4:-0}"
local -i mbfl_I
for ((mbfl_I=mbfl_BEGIN; mbfl_I < ${#mbfl_STRING}; ++mbfl_I))
do
if test "${mbfl_STRING:$mbfl_I:1}" = "$mbfl_CHAR"
then
mbfl_RESULT_VARREF=$mbfl_I
# Found!  Return with exit status 0.
return 0
fi
done
return 1
}
function mbfl_string_first () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local CHAR=${2:?"missing char parameter to '${FUNCNAME}'"}
local BEGIN="${3:-}"
local RESULT_VARNAME
if mbfl_string_first_var RESULT_VARNAME "$STRING" "$CHAR" "$BEGIN"
then printf '%s\n' "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_string_last_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_STRING=${2:?"missing string parameter to '${FUNCNAME}'"}
local mbfl_CHAR=${3:?"missing char parameter to '${FUNCNAME}'"}
local mbfl_BEGIN="${4:-}"
local -i mbfl_I
for ((mbfl_I=${mbfl_BEGIN:-((${#mbfl_STRING}-1))}; mbfl_I >= 0; --mbfl_I))
do
if test "${mbfl_STRING:$mbfl_I:1}" = "$mbfl_CHAR"
then
# Found!  Return with exit status 0.
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_string_last () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local CHAR=${2:?"missing char parameter to '${FUNCNAME}'"}
local BEGIN="${3:-}"
local RESULT_VARNAME
if mbfl_string_last_var RESULT_VARNAME "$STRING" "$CHAR" "$BEGIN"
then printf '%s\n' "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_string_index_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_STRING=${2:?"missing string parameter to '${FUNCNAME}'"}
local mbfl_INDEX=${3:?"missing index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_STRING:${mbfl_INDEX}:1}
}
function mbfl_string_index () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local INDEX=${2:?"missing index parameter to '${FUNCNAME}'"}
printf "${STRING:$INDEX:1}\n"
}
function mbfl_string_range_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_STRING=${2:?"missing string parameter to '${FUNCNAME}'"}
local mbfl_BEGIN=${3:?"missing begin parameter to '${FUNCNAME}'"}
local mbfl_END="${4:-}"
if test -z "$mbfl_END" -o "$mbfl_END" = 'end' -o "$mbfl_END" = 'END'
then mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN}
else mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN:$mbfl_END}
fi
}
function mbfl_string_range () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local BEGIN=${2:?"missing begin parameter to '${FUNCNAME}'"}
local END="${3:-}"
local RESULT_VARNAME
if mbfl_string_range_var RESULT_VARNAME "$STRING" "$BEGIN" "$END"
then printf '%s\n' "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_string_chars () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local -i i j
local ch
for ((i=0, j=0; i < ${#STRING}; ++i, ++j))
do
ch=${STRING:$i:1}
if test "$ch" != $'\\'
then SPLITFIELD[$j]=$ch
else
let ++i
if test $i != ${#STRING}
then SPLITFIELD[$j]=${ch}${STRING:$i:1}
else SPLITFIELD[$j]=$ch
fi
fi
done
SPLITCOUNT=$j
return 0
}
function mbfl_string_split () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local SEPARATOR=${2:?"missing separator parameter to '${FUNCNAME}'"}
local -i i j k=0 first=0
SPLITFIELD=()
SPLITCOUNT=0
for ((i=0; i < ${#STRING}; ++i))
do
if (( (i + ${#SEPARATOR}) > ${#STRING}))
then break
elif mbfl_string_equal_substring "$STRING" $i "$SEPARATOR"
then
# Here $i is the index of the first char in the separator.
SPLITFIELD[$k]=${STRING:$first:$((i - first))}
let ++k
let i+=${#SEPARATOR}-1
# Place  the "first"  marker to  the beginning  of the  next
# substring; "i" will  be incremented by "for",  that is why
# we do "+1" here.
let first=i+1
fi
done
SPLITFIELD[$k]=${STRING:$first}
let ++k
SPLITCOUNT=$k
return 0
}
function mbfl_string_split_blanks () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local ACCUM CH
local -i i
SPLITFIELD=()
SPLITCOUNT=0
for ((i=0; i < ${#STRING}; ++i))
do
CH=${STRING:$i:1}
if test ' ' = "$CH" -o $'\t' = "$CH"
then
# Store the field.
SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
ACCUM=
# Consume all the adjacent blanks, if any.
for ((i=$i; i < ${#STRING}; ++i))
do
CH=${STRING:$((i+1)):1}
if test ' ' != "$CH" -a $'\t' != "$CH"
then break
fi
done
else ACCUM+=$CH
fi
done
if mbfl_string_is_not_empty "$ACCUM"
then SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
fi
SPLITCOUNT=${#SPLITFIELD[@]}
return 0
}
function mbfl_string_equal () {
local STR1="${1:-}"
local STR2="${2:-}"
test "$STR1" '=' "$STR2"
}
function mbfl_string_not_equal () {
local STR1="${1:-}"
local STR2="${2:-}"
test "$STR1" '!=' "$STR2"
}
function mbfl_string_is_yes () {
local STR="${1:-}"
test "$STR" = 'yes'
}
function mbfl_string_is_no () {
local STR="${1:-}"
test "$STR" = 'no'
}
function mbfl_string_less () {
local STR1="${1:-}"
local STR2="${2:-}"
test "$STR1" '<' "$STR2"
}
function mbfl_string_greater () {
local STR1="${1:-}"
local STR2="${2:-}"
test "$STR1" '>' "$STR2"
}
function mbfl_string_less_or_equal () {
local STR1="${1:-}"
local STR2="${2:-}"
test "$STR1" '<' "$STR2" -o "$STR1" '=' "$STR2"
}
function mbfl_string_greater_or_equal () {
local STR1="${1:-}"
local STR2="${2:-}"
test "$STR1" '>' "$STR2" -o "$STR1" '=' "$STR2"
}
function mbfl_string_equal_substring () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local POSITION=${2:?"missing position parameter to '${FUNCNAME}'"}
local PATTERN=${3:?"missing pattern parameter to '${FUNCNAME}'"}
local i
if (( (POSITION + ${#PATTERN}) > ${#STRING} ))
then return 1
fi
for ((i=0; i < "${#PATTERN}"; ++i))
do
if test "${PATTERN:$i:1}" != "${STRING:$(($POSITION+$i)):1}"
then return 1
fi
done
return 0
}
function mbfl_string_is_alpha_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
! test \( "$CHAR" \< A -o Z \< "$CHAR" \) -a \( "$CHAR" \< a -o z \< "$CHAR" \)
}
function mbfl_string_is_digit_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
! test "$CHAR" \< 0 -o 9 \< "$CHAR"
}
function mbfl_string_is_alnum_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alpha_char "$CHAR" || mbfl_string_is_digit_char "$CHAR"
}
function mbfl_string_is_name_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = _
}
function mbfl_string_is_identifier_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-'
}
function mbfl_string_is_extended_identifier_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-' -o "$CHAR" = '.'
}
function mbfl_string_is_noblank_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
test \( "$CHAR" != " " \) -a \
\( "$CHAR" != $'\n' \) -a \( "$CHAR" != $'\r' \) -a \
\( "$CHAR" != $'\t' \) -a \( "$CHAR" != $'\f' \)
}
for class in alpha digit alnum noblank ; do
alias "mbfl_string_is_${class}"="mbfl_p_string_is $class"
done
function mbfl_p_string_is () {
local CLASS=${1:?"missing class parameter to '${FUNCNAME}'"}
local STRING=$2
local -i i
if ((0 < ${#STRING}))
then
for ((i=0; i < ${#STRING}; ++i))
do
if ! "mbfl_string_is_${CLASS}_char" "${STRING:$i:1}"
then return 1
fi
done
return 0
else return 1
fi
}
function mbfl_string_is_name () {
local STRING=$1
mbfl_string_is_not_empty "$STRING" && mbfl_p_string_is name "$STRING" && { ! mbfl_string_is_digit "${STRING:0:1}"; }
}
function mbfl_string_is_identifier () {
local STRING=$1
mbfl_string_is_not_empty "$STRING" \
&&   mbfl_p_string_is identifier "$STRING"	\
&& ! mbfl_string_is_digit "${STRING:0:1}"	\
&& mbfl_string_not_equal "${STRING:0:1}" '-'
}
function mbfl_string_is_extended_identifier () {
local STRING=$1
mbfl_string_is_not_empty "$STRING" \
&&   mbfl_p_string_is extended_identifier "$STRING"	\
&& ! mbfl_string_is_digit "${STRING:0:1}"		\
&& mbfl_string_not_equal "${STRING:0:1}" '-'
}
function mbfl_string_is_username () {
local STRING=$1
mbfl_string_is_not_empty "$STRING" && \
mbfl_string_is_identifier "$STRING"
}
function mbfl_string_is_network_port () {
local STRING="${1:-}"
if mbfl_string_is_not_empty "$STRING" && mbfl_string_is_digit "$STRING" && ((0 <= STRING && STRING <= 1024))
then return 0
else return 1
fi
}
function mbfl_string_is_network_hostname () {
local STRING="${1:-}"
local -r REX="^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$"
if ((${#STRING} <= 255)) && [[ $STRING =~ $REX ]]
then return 0
fi
return 1
}
function mbfl_string_is_network_ip_address () {
local STRING="${1:-}"
local -r REX="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
if ((${#STRING} <= 255)) && [[ $STRING =~ $REX ]]
then return 0
fi
return 1
}
function mbfl_string_is_email_address () {
local ADDRESS="${1:-}"
local -r REX='^[a-zA-Z0-9_.\-]+(@[a-zA-Z0-9_.\-]+)?$'
if [[ $ADDRESS =~ $REX ]]
then return 0
else return 1
fi
}
function mbfl_string_toupper () {
echo "${1^^}"
}
function mbfl_string_tolower () {
echo "${1,,}"
}
function mbfl_string_toupper_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
mbfl_RESULT_VARREF="${2^^}"
}
function mbfl_string_tolower_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
mbfl_RESULT_VARREF="${2,,}"
}
function mbfl_string_replace () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local PATTERN=${2:?"missing pattern parameter to '${FUNCNAME}'"}
local SUBST="${3:-}"
printf '%s\n' "${STRING//$PATTERN/$SUBST}"
}
function mbfl_string_replace_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_STRING=${2:?"missing string parameter to '${FUNCNAME}'"}
local mbfl_PATTERN=${3:?"missing pattern parameter to '${FUNCNAME}'"}
local mbfl_SUBST="${4:-}"
mbfl_RESULT_VARREF=${mbfl_STRING//${mbfl_PATTERN}/${mbfl_SUBST}}
}
function mbfl_string_skip () {
local mbfl_STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local mbfl_a_variable_mbfl_POSNAME=${2:?"missing position parameter to '${FUNCNAME}'"}
local -n mbfl_POSNAME=$mbfl_a_variable_mbfl_POSNAME
local mbfl_CHAR=${3:?"missing char parameter to '${FUNCNAME}'"}
while test "${mbfl_STRING:$mbfl_POSNAME:1}" = "$mbfl_CHAR"
do let ++mbfl_POSNAME
done
}
function mbfl_sprintf () {
local VARNAME=${1:?"missing variable name parameter to '${FUNCNAME}'"}
local FORMAT=${2:?"missing format parameter to '${FUNCNAME}'"}
local OUTPUT=
shift 2
printf -v OUTPUT "$FORMAT" "$@"
eval "$VARNAME"=\'"$OUTPUT"\'
}
function mbfl_string_strip_carriage_return_var () {
local mbfl_a_variable_RESULT_NAMEREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n RESULT_NAMEREF=$mbfl_a_variable_RESULT_NAMEREF
local LINE="${2:-}"
if mbfl_string_is_not_empty "$LINE"
then
local mbfl_a_variable_CH
mbfl_variable_alloc mbfl_a_variable_CH
local  $mbfl_a_variable_CH
local -n CH=$mbfl_a_variable_CH

mbfl_string_index_var $mbfl_a_variable_CH "$LINE" $((${#LINE} - 1))
if mbfl_string_equal "$CH" $'\r'
then RESULT_NAMEREF=${LINE:0:((${#LINE} - 1))}
else RESULT_NAMEREF=$LINE
fi
fi
}
