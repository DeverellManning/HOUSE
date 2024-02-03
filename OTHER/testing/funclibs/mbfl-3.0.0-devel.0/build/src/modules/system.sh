function mbfl_system_enable_programs () {
:
}
declare -A mbfl_system_PASSWD_ENTRIES
declare -i mbfl_system_PASSWD_COUNT=0
function mbfl_system_passwd_reset () {
mbfl_system_PASSWD_ENTRIES=()
mbfl_system_PASSWD_COUNT=0
}
function mbfl_system_passwd_read () {
if ((0 == mbfl_system_PASSWD_COUNT))
then
#             username          passwd            uid      gid      gecos dir                shell
local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([0-9]+):(.*):([a-zA-Z0-9_/\-]+):([a-zA-Z0-9_/\-]+)'
local LINE
if {
while IFS= read LINE
do
if [[ $LINE =~ $REX ]]
then
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:name"]=${BASH_REMATCH[1]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:passwd"]=${BASH_REMATCH[2]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:uid"]=${BASH_REMATCH[3]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:gid"]=${BASH_REMATCH[4]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:gecos"]=${BASH_REMATC[5]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:dir"]=${BASH_REMATCH[6]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:shell"]=${BASH_REMATCH[7]}
let ++mbfl_system_PASSWD_COUNT
else
:
fi
done </etc/passwd
}
then
if ((0 < mbfl_system_PASSWD_COUNT))
then return 0
else return 1
fi
else return 1
fi
else return 0
fi
}
function mbfl_system_passwd_print_entries () {
local -i i
for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
do
printf "name='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
printf "uid=%d "	"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
printf "gid=%d "	"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
printf "gecos='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
printf "dir='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
printf "shell='%s'\n"	"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
done
}
function mbfl_system_passwd_print_entries_as_xml () {
local -i i
for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
do
printf '<entry '
printf "name='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
printf "uid='%d' "	"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
printf "gid='%d' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
printf "gecos='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
printf "dir='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
printf "shell='%s'"	"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
printf '/>\n'
done
}
function mbfl_system_passwd_print_entries_as_json () {
local -i i
for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
do
printf '"entry": { '
printf '"name": "%s", '		"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
printf '"passwd": "%s", '	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
printf '"uid": %d, '		"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
printf '"gid": %d, '		"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
printf '"gecos": "%s", '	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
printf '"dir": "%s", '		"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
printf '"shell": "%s"'		"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
printf ' }\n'
done
}
function mbfl_system_passwd_get_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:name]}
}
function mbfl_system_passwd_get_name () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:name]}"
}
function mbfl_system_passwd_get_passwd_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:passwd]}
}
function mbfl_system_passwd_get_passwd () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:passwd]}"
}
function mbfl_system_passwd_get_uid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:uid]}
}
function mbfl_system_passwd_get_uid () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:uid]}"
}
function mbfl_system_passwd_get_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:gid]}
}
function mbfl_system_passwd_get_gid () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:gid]}"
}
function mbfl_system_passwd_get_gecos_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:gecos]}
}
function mbfl_system_passwd_get_gecos () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:gecos]}"
}
function mbfl_system_passwd_get_dir_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:dir]}
}
function mbfl_system_passwd_get_dir () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:dir]}"
}
function mbfl_system_passwd_get_shell_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:shell]}
}
function mbfl_system_passwd_get_shell () {
local -i INDEX=${1:?"missing passwd entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:shell]}"
}
function mbfl_system_passwd_find_entry_by_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_THE_NAME=${2:?"missing user name parameter to '${FUNCNAME}'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_PASSWD_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_NAME" "${mbfl_system_PASSWD_ENTRIES[${mbfl_I}:name]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_passwd_find_entry_by_name () {
local THE_NAME=${1:?"missing user name parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_system_passwd_find_entry_by_name_var RESULT_VARNAME "$THE_NAME"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_passwd_find_entry_by_uid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_THE_UID=${2:?"missing user id parameter to '${FUNCNAME}'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_PASSWD_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_UID" "${mbfl_system_PASSWD_ENTRIES[${mbfl_I}:uid]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_passwd_find_entry_by_uid () {
local THE_UID=${1:?"missing user id parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_system_passwd_find_entry_by_uid_var RESULT_VARNAME "$THE_UID"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_passwd_uid_to_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_THE_UID=${2:?"missing user id parameter to '${FUNCNAME}'"}
local -i mbfl_USER_INDEX
if mbfl_system_passwd_find_entry_by_uid_var mbfl_USER_INDEX $mbfl_THE_UID
then mbfl_system_passwd_get_name_var mbfl_RESULT_VARREF $mbfl_USER_INDEX
else return 1
fi
}
function mbfl_system_passwd_uid_to_name () {
local -i THE_UID=${1:?"missing user id parameter to '${FUNCNAME}'"}
local -i USER_INDEX
if mbfl_system_passwd_find_entry_by_uid_var USER_INDEX $THE_UID
then mbfl_system_passwd_get_name $USER_INDEX
else return 1
fi
}
function mbfl_system_passwd_name_to_uid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_THE_NAME=${2:?"missing user name parameter to '${FUNCNAME}'"}
local -i mbfl_USER_INDEX
if mbfl_system_passwd_find_entry_by_name_var mbfl_USER_INDEX "$mbfl_THE_NAME"
then mbfl_system_passwd_get_uid_var mbfl_RESULT_VARREF $mbfl_USER_INDEX
else return 1
fi
}
function mbfl_system_passwd_name_to_uid () {
local THE_NAME=${1:?"missing user name parameter to '${FUNCNAME}'"}
local -i USER_INDEX
if mbfl_system_passwd_find_entry_by_name_var USER_INDEX "$THE_NAME"
then mbfl_system_passwd_get_uid $USER_INDEX
else return 1
fi
}
function mbfl_system_numerical_user_id_to_name () {
local -i THE_UID=${1:?"missing user id parameter to '${FUNCNAME}'"}
if mbfl_system_passwd_read
then mbfl_system_passwd_uid_to_name "$THE_UID"
fi
}
function mbfl_system_user_name_to_numerical_id () {
local THE_NAME=${1:?"missing user name parameter to '${FUNCNAME}'"}
if mbfl_system_passwd_read
then mbfl_system_passwd_name_to_uid "$THE_NAME"
fi
}
declare -A mbfl_system_GROUP_ENTRIES
declare -i mbfl_system_GROUP_COUNT=0
function mbfl_system_group_reset () {
mbfl_system_GROUP_ENTRIES=()
mbfl_system_GROUP_COUNT=0
}
function mbfl_system_group_read () {
if ((0 == mbfl_system_GROUP_COUNT))
then
#             groupname         password          gid      userlist
local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([a-zA-Z0-9_/,\-]*)'
local LINE
if {
while IFS= read LINE
do
if [[ $LINE =~ $REX ]]
then
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:name"]=${BASH_REMATCH[1]}
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:passwd"]=${BASH_REMATCH[2]}
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:gid"]=${BASH_REMATCH[3]}
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users"]=${BASH_REMATCH[4]}
# Let's parse the "users" field.
if mbfl_string_is_not_empty "${mbfl_system_GROUP_ENTRIES[${mbfl_system_GROUP_COUNT}:users]}"
then
{
local SPLITFIELD
local -i SPLITCOUNT i
mbfl_string_split "${mbfl_system_GROUP_ENTRIES[${mbfl_system_GROUP_COUNT}:users]}" ','
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users:count"]=$SPLITCOUNT
for ((i=0; i < SPLITCOUNT; ++i))
do mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users:${i}"]=${SPLITFIELD[$i]}
done
}
fi
let ++mbfl_system_GROUP_COUNT
fi
done </etc/group
}
then
if ((0 < mbfl_system_GROUP_COUNT))
then return 0
else return 1
fi
else return 1
fi
else return 0
fi
}
function mbfl_system_group_print_entries () {
local -i i
for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
do
printf "name='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
printf "gid=%d "	"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
printf "users='%s'\n"	"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
done
}
function mbfl_system_group_print_entries_as_xml () {
local -i i
for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
do
printf '<entry '
printf "name='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
printf "gid='%d' "	"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
printf "users='%s'"	"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
printf '/>\n'
done
}
function mbfl_system_group_print_entries_as_json () {
local -i i
for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
do
printf '"entry": { '
printf '"name": "%s", '		"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
printf '"passwd": "%s", '	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
printf '"gid": %d, '		"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
printf '"users": "%s"'		"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
printf ' }\n'
done
}
function mbfl_system_group_get_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:name]}
}
function mbfl_system_group_get_name () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:name]}"
}
function mbfl_system_group_get_passwd_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:passwd]}
}
function mbfl_system_group_get_passwd () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:passwd]}"
}
function mbfl_system_group_get_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:gid]}
}
function mbfl_system_group_get_gid () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:gid]}"
}
function mbfl_system_group_get_users_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users]}
}
function mbfl_system_group_get_users () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users]}"
}
function mbfl_system_group_get_users_count_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users:count]}
}
function mbfl_system_group_get_users_count () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users:count]}"
}
function mbfl_system_group_get_user_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '${FUNCNAME}'"}
local -i mbfl_USER_INDEX=${3:?"missing user index parameter to '${FUNCNAME}'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users:${mbfl_USER_INDEX}]}
}
function mbfl_system_group_get_user_name () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '${FUNCNAME}'"}
local -i USER_INDEX=${2:?"missing user index parameter to '${FUNCNAME}'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users:${USER_INDEX}]}"
}
function mbfl_system_group_find_entry_by_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_THE_NAME=${2:?"missing group name parameter to '${FUNCNAME}'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_GROUP_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_NAME" "${mbfl_system_GROUP_ENTRIES[${mbfl_I}:name]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_group_find_entry_by_name () {
local THE_NAME=${1:?"missing group name parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_system_group_find_entry_by_name_var RESULT_VARNAME "$THE_NAME"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_group_find_entry_by_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_THE_GID=${2:?"missing group id parameter to '${FUNCNAME}'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_GROUP_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_GID" "${mbfl_system_GROUP_ENTRIES[${mbfl_I}:gid]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_group_find_entry_by_gid () {
local THE_GID=${1:?"missing group id parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
if mbfl_system_group_find_entry_by_gid_var RESULT_VARNAME "$THE_GID"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_group_gid_to_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_THE_GID=${2:?"missing group id parameter to '${FUNCNAME}'"}
local -i mbfl_GROUP_INDEX
if mbfl_system_group_find_entry_by_gid_var mbfl_GROUP_INDEX $mbfl_THE_GID
then mbfl_system_group_get_name_var mbfl_RESULT_VARREF $mbfl_GROUP_INDEX
else return 1
fi
}
function mbfl_system_group_gid_to_name () {
local -i THE_GID=${1:?"missing group id parameter to '${FUNCNAME}'"}
local -i GROUP_INDEX
if mbfl_system_group_find_entry_by_gid_var GROUP_INDEX $THE_GID
then mbfl_system_group_get_name $GROUP_INDEX
else return 1
fi
}
function mbfl_system_group_name_to_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_THE_NAME=${2:?"missing group name parameter to '${FUNCNAME}'"}
local -i GROUP_INDEX
if mbfl_system_group_find_entry_by_name_var GROUP_INDEX "$mbfl_THE_NAME"
then mbfl_system_group_get_gid_var mbfl_RESULT_VARREF $GROUP_INDEX
else return 1
fi
}
function mbfl_system_group_name_to_gid () {
local THE_NAME=${1:?"missing group name parameter to '${FUNCNAME}'"}
local -i GROUP_INDEX
if mbfl_system_group_find_entry_by_name_var GROUP_INDEX "$THE_NAME"
then mbfl_system_group_get_gid $GROUP_INDEX
else return 1
fi
}
function mbfl_system_numerical_group_id_to_name () {
local -i THE_GID=${1:?"missing group id parameter to '${FUNCNAME}'"}
if mbfl_system_group_read
then mbfl_system_group_gid_to_name "$THE_GID"
fi
}
function mbfl_system_group_name_to_numerical_id () {
local THE_NAME=${1:?"missing group name parameter to '${FUNCNAME}'"}
if mbfl_system_group_read
then mbfl_system_group_name_to_gid "$THE_NAME"
fi
}
declare -a mbfl_symbolic_permissions
mbfl_symbolic_permissions[0]='---'
mbfl_symbolic_permissions[1]='--x'
mbfl_symbolic_permissions[2]='-w-'
mbfl_symbolic_permissions[3]='-wx'
mbfl_symbolic_permissions[4]='r--'
mbfl_symbolic_permissions[5]='r-x'
mbfl_symbolic_permissions[6]='rw-'
mbfl_symbolic_permissions[7]='rwx'
function mbfl_system_symbolic_to_octal_permissions () {
local MODE=${1:?"missing symbolic permissions parameter to '${FUNCNAME}'"}
local -i i
for ((i=0; i < 8; ++i))
do
if mbfl_string_equal "${mbfl_symbolic_permissions[$i]}" "$MODE"
then
printf "%s\n" $i
return 0
fi
done
return 1
}
function mbfl_system_octal_to_symbolic_permissions () {
local MODE=${1:?"missing symbolic permissions parameter to '${FUNCNAME}'"}
printf '%s\n' "${mbfl_symbolic_permissions[${MODE}]}"
}
