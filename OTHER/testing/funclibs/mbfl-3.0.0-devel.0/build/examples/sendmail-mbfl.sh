#!/usr/bin/bash
script_PROGNAME=sendmail-mbfl.sh
script_VERSION=2.0
script_COPYRIGHT_YEARS='2009, 2010, 2015, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=liberal
script_USAGE="usage: ${script_PROGNAME} [options] ..."
script_DESCRIPTION='Send an email message.'
script_EXAMPLES="Usage examples:
\n\
\techo 'From: marco@localhost
\tTo: root@localhost
\tSubject: ciao
\n\
\tHow do you do?
\t' | ${script_PROGNAME} \\
\t\t--envelope-from=marco@localhost --envelope-to=root@localhost"
declare script_option_AUTHINFO_FILE=~/.mbfl-authinfo
declare script_option_HOSTINFO_FILE=~/.mbfl-hostinfo
declare script_option_SMTP_HOSTNAME=localhost
declare script_option_SMTP_PORT
declare script_option_SESSION_TYPE
declare script_option_AUTH_TYPE=none
declare script_option_EMAIL_FROM_ADDRESS
declare -a script_option_RECIPIENTS
declare script_option_AUTH_USER
declare script_option_AUTH_PASSWORD
declare script_option_CONNECTOR=gnutls
declare script_option_READ_TIMEOUT=5
declare LOCAL_HOSTNAME
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
mbfl_declare_option EMAIL_FROM_ADDRESS	''   F envelope-from witharg 'select envelope MAIL FROM address'
mbfl_declare_option EMAIL_TO_ADDRESS	''   T envelope-to   witharg 'select envelope RCPT TO address'
mbfl_declare_option EMAIL_MESSAGE_SOURCE -   M message       witharg 'select the source of the email message'
mbfl_declare_option EMAIL_TEST_MESSAGE	no  '' test-message  noarg   'send a test message'
mbfl_declare_option HOSTINFO_FILE	"$script_option_HOSTINFO_FILE" '' host-info witharg 'select the hostinfo file'
mbfl_declare_option SMTP_HOSTNAME	"$script_option_SMTP_HOSTNAME" '' host witharg 'select the SMTP server hostname'
mbfl_declare_option SMTP_PORT		"$script_option_SMTP_PORT"      p port witharg 'select the SMTP server port'
mbfl_declare_option SESSION_PLAIN	yes '' plain        noarg 'establish a plain connection (non-encrypted)'
mbfl_declare_option SESSION_TLS		no  '' tls          noarg 'establish a TLS bridge immediately'
mbfl_declare_option SESSION_STARTTLS	no  '' starttls     noarg 'establish a TLS bridge using STARTTLS'
mbfl_declare_option GNUTLS_CONNECTOR	no  '' gnutls  noarg 'use gnutls-cli for TLS'
mbfl_declare_option OPENSSL_CONNECTOR	no  '' openssl noarg 'use openssl for TLS'
mbfl_declare_option AUTHINFO_FILE	"$script_option_AUTHINFO_FILE" '' auth-info witharg 'select the authinfo file'
mbfl_declare_option AUTH_USER		''  '' username witharg 'select the authorisation user'
mbfl_declare_option AUTH_NONE		yes '' auth-none  noarg 'do not do authorisation'
mbfl_declare_option AUTH_PLAIN		no  '' auth-plain noarg 'select the plain authorisation type'
mbfl_declare_option AUTH_LOGIN		no  '' auth-login noarg 'select the login authorisation type'
mbfl_declare_option READ_TIMEOUT	"$script_option_READ_TIMEOUT" '' timeout witharg 'select the connection timeout in seconds'
mbfl_file_enable_remove
mbfl_times_and_dates_enable
mbfl_declare_program base64
mbfl_declare_program gnutls-cli
mbfl_declare_program grep
mbfl_declare_program hostname
mbfl_declare_program mkfifo
mbfl_declare_program openssl
mbfl_main_declare_exit_code 2 invalid_option
mbfl_main_declare_exit_code 3 invalid_message_source
mbfl_main_declare_exit_code 4 unreadable_host_file
mbfl_main_declare_exit_code 5 invalid_host_file
mbfl_main_declare_exit_code 6 unknown_host
mbfl_main_declare_exit_code 7 unreadable_auth_file
mbfl_main_declare_exit_code 8 invalid_auth_file
mbfl_main_declare_exit_code 9 unknown_auth_user
mbfl_main_declare_exit_code 10 failed_connection
mbfl_main_declare_exit_code 11 wrong_server_answer
mbfl_main_declare_exit_code 12 read_timeout_expired
mbfl_main_declare_exit_code 13 error_reading_from_server
mbfl_main_declare_exit_code 14 error_writing_to_server
function script_option_update_authinfo_file () {
if ! mbfl_file_is_readable "$script_option_AUTHINFO_FILE"
then exit_because_invalid_option
fi
}
function script_option_update_smtp_host () {
if ! mbfl_string_is_network_hostname "$script_option_SMTP_HOSTNAME"
then
mbfl_message_error_printf 'invalid value as SMTP server hostname: "%s"' "$script_option_SMTP_HOSTNAME"
exit_because_invalid_option
fi
}
function script_option_update_smtp_port () {
if ! mbfl_string_is_network_port "$script_option_SMTP_PORT"
then
mbfl_message_error_printf 'invalid value as SMTP server port number: "%s"' "$script_option_SMTP_PORT"
exit_because_invalid_option
fi
}
function script_option_update_hostinfo_file () {
if ! mbfl_file_is_readable "$script_option_HOSTINFO_FILE"
then exit_because_invalid_option
fi
}
function script_option_update_session_plain () {
script_option_SESSION_TYPE=plain
}
function script_option_update_session_tls () {
script_option_SESSION_TYPE=tls
}
function script_option_update_session_starttls () {
script_option_SESSION_TYPE=starttls
}
function script_option_update_auth_none () {
script_option_AUTH_TYPE=none
}
function script_option_update_auth_plain () {
script_option_AUTH_TYPE=plain
}
function script_option_update_auth_login () {
script_option_AUTH_TYPE=login
}
function script_option_update_email_from_address () {
if ! mbfl_string_is_email_address "$script_option_EMAIL_FROM_ADDRESS"
then exit_because_invalid_option
fi
}
function script_option_update_email_to_address () {
if mbfl_string_is_email_address "$script_option_EMAIL_TO_ADDRESS"
then script_option_RECIPIENTS[${#script_option_RECIPIENTS[@]}]=$script_option_EMAIL_TO_ADDRESS
else exit_because_invalid_option
fi
}
function script_option_update_gnutls_connector () {
script_option_CONNECTOR=gnutls
}
function script_option_update_openssl_connector () {
script_option_CONNECTOR=openssl
}
function script_option_update_read_timeout () {
if ! mbfl_string_is_digit "$script_option_READ_TIMEOUT"
then
mbfl_message_error_printf 'invalid value as timeout: %s' "$script_option_READ_TIMEOUT"
exit_because_invalid_option
fi
}
function main () {
local mbfl_a_variable_INFD
mbfl_variable_alloc mbfl_a_variable_INFD
local -i $mbfl_a_variable_INFD
local -n INFD=$mbfl_a_variable_INFD
INFD=3
local mbfl_a_variable_OUFD
mbfl_variable_alloc mbfl_a_variable_OUFD
local -i $mbfl_a_variable_OUFD
local -n OUFD=$mbfl_a_variable_OUFD
OUFD=4
local mbfl_a_variable_INFIFO
mbfl_variable_alloc mbfl_a_variable_INFIFO
local  $mbfl_a_variable_INFIFO
local -n INFIFO=$mbfl_a_variable_INFIFO

local mbfl_a_variable_OUFIFO
mbfl_variable_alloc mbfl_a_variable_OUFIFO
local  $mbfl_a_variable_OUFIFO
local -n OUFIFO=$mbfl_a_variable_OUFIFO

local mbfl_a_variable_CONNECTOR_PID
mbfl_variable_alloc mbfl_a_variable_CONNECTOR_PID
local -i $mbfl_a_variable_CONNECTOR_PID
local -n CONNECTOR_PID=$mbfl_a_variable_CONNECTOR_PID
CONNECTOR_PID=0
validate_and_normalise_configuration
mbfl_message_verbose_printf 'connecting to \"%s:%d\"\n' "$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
mbfl_message_verbose_printf 'session type: %s, authentication %s\n' "$script_option_SESSION_TYPE" "$script_option_AUTH_TYPE"
case $script_option_SESSION_TYPE in
plain)
connect_establish_plain_connection mbfl_varname(INFD) mbfl_varname(OUFD) \
"$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
mbfl_message_verbose 'connection established, exchange greetings\n'
esmtp_exchange_greetings helo
;;
tls)
connect_make_fifos_for_connector
case $script_option_CONNECTOR in
gnutls)
connect_using_gnutls mbfl_varname(INFD) mbfl_varname(OUFD) \
mbfl_varname(CONNECTOR_PID) \
"$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
;;
openssl)
connect_using_openssl mbfl_varname(INFD) mbfl_varname(OUFD) \
mbfl_varname(CONNECTOR_PID) \
"$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
;;
esac
mbfl_message_verbose 'connection established, exchange greetings\n'
esmtp_exchange_greetings ehlo
;;
starttls)
connect_make_fifos_for_connector
case $script_option_CONNECTOR in
gnutls)
connect_using_gnutls_starttls mbfl_varname(INFD) mbfl_varname(OUFD) \
mbfl_varname(CONNECTOR_PID) \
"$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
;;
openssl)
connect_using_openssl_starttls mbfl_varname(INFD) mbfl_varname(OUFD) \
mbfl_varname(CONNECTOR_PID) \
"$script_option_SMTP_HOSTNAME" "$script_option_SMTP_PORT"
;;
esac
mbfl_message_verbose 'connection established, exchange greetings\n'
esmtp_exchange_greetings ehlo
;;
esac
mbfl_message_verbose 'greetings exchanged, perform authentication\n'
esmtp_authentication "$script_option_AUTH_TYPE" "$script_option_AUTH_USER" "$script_option_AUTH_PASSWORD"
mbfl_message_verbose 'authentication performed, send message\n'
esmtp_send_message
esmtp_quit
wait_for_connector_process $CONNECTOR_PID
exit_because_success
}
function validate_and_normalise_configuration () {
if ! mbfl_string_is_email_address "$script_option_EMAIL_FROM_ADDRESS"
then
mbfl_message_error 'invalid string as MAIL FROM envelope address: "%s"' "$script_option_EMAIL_FROM_ADDRESS"
exit_because_invalid_option
fi
if mbfl_array_is_empty script_option_RECIPIENTS
then
mbfl_message_error 'no recipients where selected'
exit_because_invalid_option
fi
{
local -i i
for ((i=0; i < ${#script_option_RECIPIENTS[@]}; ++i))
do
if ! mbfl_string_is_email_address "${script_option_RECIPIENTS[$i]}"
then
mbfl_message_error 'invalid string as RCPT TO envelope address: "%s"' "${script_option_RECIPIENTS[$i]}"
exit_because_invalid_option
fi
done
}
if ! mbfl_string_is_yes "$script_option_EMAIL_TEST_MESSAGE"
then
if mbfl_string_is_empty "$script_option_EMAIL_MESSAGE_SOURCE"
then
mbfl_message_error 'missing selection of mail message source'
exit_because_invalid_option
fi
if mbfl_string_not_equal "$script_option_EMAIL_MESSAGE_SOURCE" '-'
then
if ! mbfl_file_is_file "$script_option_EMAIL_MESSAGE_SOURCE"
then
mbfl_message_error 'selected message file does not exist: "%s"' "$script_option_EMAIL_MESSAGE_SOURCE"
exit_because_invalid_option
fi
if ! mbfl_file_is_readable "$script_option_EMAIL_MESSAGE_SOURCE"
then
mbfl_message_error_printf 'selected message file is not readable: "%s"' "$script_option_EMAIL_MESSAGE_SOURCE"
exit_because_invalid_option
fi
fi
fi
if mbfl_string_is_empty "$script_option_SMTP_HOSTNAME"
then
mbfl_message_error 'internal failure: missing selection for SMTP hostname'
exit_because_invalid_option
fi
if { mbfl_string_is_empty     "$script_option_SMTP_PORT"    || \
mbfl_string_is_empty "$script_option_SESSION_TYPE" || \
mbfl_string_is_empty "$script_option_AUTH_TYPE"; }
then
# Some value is missing, so  read the hostinfo file.  Select the
# entry from the  file matching $script_option_SMTP_HOSTNAME and
# store the corresponding values in the variables "hostinfo_*".
#
{
local hostinfo_SMTP_PORT hostinfo_SESSION_TYPE hostinfo_AUTH_TYPE
hostinfo_read "$script_option_HOSTINFO_FILE" "$script_option_SMTP_HOSTNAME" \
hostinfo_SMTP_PORT hostinfo_SESSION_TYPE hostinfo_AUTH_TYPE
# Update the script options that are not already set.
#
if mbfl_string_is_empty "$script_option_SMTP_PORT"
then script_option_SMTP_PORT=$hostinfo_SMTP_PORT
fi
if mbfl_string_is_empty "$script_option_SESSION_TYPE"
then script_option_SESSION_TYPE=$hostinfo_SESSION_TYPE
fi
if mbfl_string_is_empty "$script_option_AUTH_TYPE"
then script_option_AUTH_TYPE=$hostinfo_AUTH_TYPE
fi
}
fi
if mbfl_string_not_equal "$script_option_AUTH_TYPE" 'none'
then
if ! mbfl_string_is_email_address "$script_option_AUTH_USER"
then
mbfl_message_error_printf 'invalid value for username: "%s"' "$script_option_AUTH_USER"
exit_because_invalid_option
fi
# Fine, read the authinfo file.   Select the entry from the file
# matching            $script_option_SMTP_HOSTNAME           and
# $script_option_AUTH_USER then  store the  corresponding values
# in the variables "authinfo_*".
{
local authinfo_AUTH_USER authinfo_AUTH_PASSWORD
authinfo_read "$script_option_AUTHINFO_FILE" "$script_option_SMTP_HOSTNAME" "$script_option_AUTH_USER" \
authinfo_AUTH_USER authinfo_AUTH_PASSWORD
# Override  the values  with  those read  from the  authinfo
# file.
script_option_AUTH_USER=$authinfo_AUTH_USER
script_option_AUTH_PASSWORD=$authinfo_AUTH_PASSWORD
}
fi
}
function connect_establish_plain_connection () {
local mbfl_a_variable_INFD_RV=${1:?"missing input file descriptor reference variable parameter to '${FUNCNAME}'"}
local -n INFD_RV=$mbfl_a_variable_INFD_RV
local mbfl_a_variable_OUFD_RV=${2:?"missing output file descriptor reference variable parameter to '${FUNCNAME}'"}
local -n OUFD_RV=$mbfl_a_variable_OUFD_RV
local SMTP_HOSTNAME=${3:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local -i SMTP_PORT=${4:?"missing SMTP port parameter to '${FUNCNAME}'"}
local DEVICE
printf -v DEVICE '/dev/tcp/%s/%d' "$SMTP_HOSTNAME" "$SMTP_PORT"
INFD_RV=3
OUFD_RV=$INFD_RV
if eval "exec ${INFD_RV}<>\"\${DEVICE}\""
then recv 220
else
mbfl_message_error_printf 'failed establishing connection to %s:%d' "$SMTP_HOSTNAME" $SMTP_PORT
exit_because_failed_connection
fi
}
function connect_using_gnutls () {
local INFD_RV=${1:?"missing input file descriptor reference variable parameter to '${FUNCNAME}'"}
local OUFD_RV=${2:?"missing output file descriptor reference variable parameter to '${FUNCNAME}'"}
local mbfl_a_variable_CONNECTOR_PID_RV=${3:?"missing connector PID reference variable parameter to '${FUNCNAME}'"}
local -n CONNECTOR_PID_RV=$mbfl_a_variable_CONNECTOR_PID_RV
local SMTP_HOSTNAME=${4:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local -i SMTP_PORT=${5:?"missing SMTP port parameter to '${FUNCNAME}'"}
local GNUTLS GNUTLS_FLAGS="--debug 0 --port ${SMTP_PORT}"
mbfl_program_found_var GNUTLS gnutls-cli || exit $?
mbfl_message_verbose_printf 'connecting with gnutls, immediate encrypted bridge\n'
mbfl_program_redirect_stderr_to_stdout
if mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOSTNAME"
then
CONNECTOR_PID_RV=$mbfl_program_BGPID
mbfl_message_debug_printf 'pid of gnutls: %d' $CONNECTOR_PID_RV
connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
recv_until_string 220
else
mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
exit_because_failed_connection
fi
}
function connect_using_gnutls_starttls () {
local INFD_RV=${1:?"missing input file descriptor reference variable parameter to '${FUNCNAME}'"}
local OUFD_RV=${2:?"missing output file descriptor reference variable parameter to '${FUNCNAME}'"}
local mbfl_a_variable_CONNECTOR_PID_RV=${3:?"missing connector PID reference variable parameter to '${FUNCNAME}'"}
local -n CONNECTOR_PID_RV=$mbfl_a_variable_CONNECTOR_PID_RV
local SMTP_HOSTNAME=${4:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local -i SMTP_PORT=${5:?"missing SMTP port parameter to '${FUNCNAME}'"}
local GNUTLS GNUTLS_FLAGS="--debug 0 --starttls --port ${SMTP_PORT}"
mbfl_program_found_var GNUTLS gnutls-cli || exit $?
mbfl_message_verbose_printf 'connecting with gnutls, delayed encrypted bridge\n'
mbfl_program_redirect_stderr_to_stdout
if mbfl_program_execbg $OUFIFO $INFIFO "$GNUTLS" $GNUTLS_FLAGS "$SMTP_HOSTNAME"
then
CONNECTOR_PID_RV=$mbfl_program_BGPID
mbfl_message_debug_printf 'pid of gnutls: %d' $CONNECTOR_PID_RV
connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
recv_until_string 220
esmtp_exchange_greetings ehlo
send STARTTLS
recv 220
kill -SIGALRM $CONNECTOR_PID_RV
esmtp_exchange_greetings ehlo
else
mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
exit_because_failed_connection
fi
}
function connect_using_openssl () {
local INFD_RV=${1:?"missing input file descriptor reference variable parameter to '${FUNCNAME}'"}
local OUFD_RV=${2:?"missing output file descriptor reference variable parameter to '${FUNCNAME}'"}
local mbfl_a_variable_CONNECTOR_PID_RV=${3:?"missing connector PID reference variable parameter to '${FUNCNAME}'"}
local -n CONNECTOR_PID_RV=$mbfl_a_variable_CONNECTOR_PID_RV
local SMTP_HOSTNAME=${4:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local -i SMTP_PORT=${5:?"missing SMTP port parameter to '${FUNCNAME}'"}
local OPENSSL OPENSSL_FLAGS="s_client -quiet -connect ${SMTP_HOSTNAME}:${SMTP_PORT}"
mbfl_program_found_var OPENSSL openssl || exit $?
mbfl_message_verbose_printf 'connecting with openssl, immediate encrypted bridge\n'
mbfl_program_redirect_stderr_to_stdout
if mbfl_program_execbg $OUFIFO $INFIFO "$OPENSSL" $OPENSSL_FLAGS
then
CONNECTOR_PID_RV=$mbfl_program_BGPID
mbfl_message_debug 'pid of openssl: %d' $CONNECTOR_PID_RV
connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
recv_until_string 220
else
mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
exit_because_failed_connection
fi
}
function connect_using_openssl_starttls () {
local INFD_RV=${1:?"missing input file descriptor reference variable parameter to '${FUNCNAME}'"}
local OUFD_RV=${2:?"missing output file descriptor reference variable parameter to '${FUNCNAME}'"}
local mbfl_a_variable_CONNECTOR_PID_RV=${3:?"missing connector PID reference variable parameter to '${FUNCNAME}'"}
local -n CONNECTOR_PID_RV=$mbfl_a_variable_CONNECTOR_PID_RV
local SMTP_HOSTNAME=${4:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local -i SMTP_PORT=${5:?"missing SMTP port parameter to '${FUNCNAME}'"}
local OPENSSL OPENSSL_FLAGS="s_client -quiet -starttls smtp -connect ${SMTP_HOSTNAME}:${SMTP_PORT}"
mbfl_program_found_var OPENSSL openssl || exit $?
mbfl_message_verbose_printf 'connecting with openssl, delayed encrypted bridge\n'
mbfl_program_redirect_stderr_to_stdout
if mbfl_program_execbg $OUFIFO $INFIFO "$OPENSSL" $OPENSSL_FLAGS
then
CONNECTOR_PID_RV=$mbfl_program_BGPID
mbfl_message_debug 'pid of openssl: %d' $CONNECTOR_PID_RV
connect_open_file_descriptors_to_fifos $INFD_RV $OUFD_RV
trap "terminate_and_wait_for_connector_process $CONNECTOR_PID_RV" EXIT
recv_until_string 250
else
mbfl_message_error_printf 'failed connection to \"%s:%s\"' "$SMTP_HOSTNAME" "$SMTP_PORT"
exit_because_failed_connection
fi
}
function wait_for_connector_process () {
local -i CONNECTOR_PID="${1:-}"
if ((0 < CONNECTOR_PID))
then
# Remove       the       EXIT        trap       that       calls
# "terminate_and_wait_for_connector_process()".
trap '' EXIT
mbfl_message_debug_printf 'waiting for connector process (pid %d)' $CONNECTOR_PID
wait $CONNECTOR_PID
mbfl_message_debug_printf 'gathered connector process'
fi
}
function terminate_and_wait_for_connector_process () {
local -i CONNECTOR_PID="${1:-}"
if ((0 < CONNECTOR_PID))
then
mbfl_message_debug_printf 'forcing termination of connector process (pid %d)' $CONNECTOR_PID
kill -SIGTERM $CONNECTOR_PID &>/dev/null
mbfl_message_debug_printf 'waiting for connector process (pid %d)' $CONNECTOR_PID
wait $CONNECTOR_PID &>/dev/null
mbfl_message_debug_printf 'gathered connector process'
fi
}
function connect_make_fifos_for_connector () {
local MKFIFO
if ! mbfl_file_find_tmpdir_var TMPDIR
then
mbfl_message_error 'unable to determine pathname of temporary directory'
exit_failure
fi
INFIFO=${TMPDIR}/connector-to-script.${RANDOM}.$$
OUFIFO=${TMPDIR}/script-to-connector.${RANDOM}.$$
mbfl_program_found_var MKFIFO mkfifo || exit $?
mbfl_message_debug 'creating FIFOs for connector subprocess'
trap connect_cleanup_fifos EXIT
if ! mbfl_program_exec "$MKFIFO" --mode=0600 "$INFIFO" "$OUFIFO"
then
mbfl_message_error 'unable to create FIFOs'
exit_failure
fi
return 0
}
function connect_open_file_descriptors_to_fifos () {
local mbfl_a_variable_INFD=${1:?"missing input-from-connector file descriptor reference variable parameter to '${FUNCNAME}'"}
local -n INFD=$mbfl_a_variable_INFD
local mbfl_a_variable_OUFD=${2:?"missing output-from-connector file descriptor reference variable parameter to '${FUNCNAME}'"}
local -n OUFD=$mbfl_a_variable_OUFD
eval "exec ${INFD}<>\"\${INFIFO}\" ${OUFD}>\"\${OUFIFO}\""
trap "" EXIT
connect_cleanup_fifos
return 0
}
function connect_cleanup_fifos () {
mbfl_file_remove "$INFIFO" &>/dev/null || true
mbfl_file_remove "$OUFIFO" &>/dev/null || true
}
function read_from_server () {
local INFD=${1:?"missing input file descriptor parameter to '${FUNCNAME}'"}
local READ_TIMEOUT=${2:?"missing read timeout parameter to '${FUNCNAME}'"}
local -i EXIT_CODE
IFS= read -rs -t $READ_TIMEOUT -u $INFD REPLY
EXIT_CODE=$?
mbfl_string_strip_carriage_return_var REPLY "$REPLY"
mbfl_message_debug_printf 'recv: %s' "$REPLY"
if ((0 == EXIT_CODE))
then return 0
elif ((128 < EXIT_CODE))
then
mbfl_message_error 'read timeout exceeded'
exit_because_read_timeout_expired
else
mbfl_message_error 'error reading from server'
exit_because_error_reading_from_server
fi
}
function try_to_cleanly_close_the_connection_after_wrong_answer () {
local INFD=${1:?"missing input file descriptor parameter to '${FUNCNAME}'"}
local script_option_READ_TIMEOUT=${2:?"missing read timeout parameter to '${FUNCNAME}'"}
if send %s QUIT
then read_from_server $INFD $script_option_READ_TIMEOUT
fi
exit_because_wrong_server_answer
}
function recv () {
local EXPECTED_CODE=${1:?"missing expected code parameter to '${FUNCNAME}'"}
local REPLY
read_from_server $INFD $script_option_READ_TIMEOUT
if mbfl_string_equal "${REPLY:0:3}" "$EXPECTED_CODE"
then return 0
else try_to_cleanly_close_the_connection_after_wrong_answer $INFD $script_option_READ_TIMEOUT
fi
}
function recv_string () {
local EXPECTED_STRING=${1:?"missing expected string parameter to '${FUNCNAME}'"}
local -ri EXPECTED_STRING_LEN=${#EXPECTED_STRING}
local REPLY
read_from_server $INFD $script_option_READ_TIMEOUT
if mbfl_string_equal "${REPLY:0:${EXPECTED_STRING_LEN}}" "$EXPECTED_STRING"
then return 0
else try_to_cleanly_close_the_connection_after_wrong_answer $INFD $script_option_READ_TIMEOUT
fi
}
function recv_until_string () {
local EXPECTED_STRING=${1:?"missing expected string parameter to '${FUNCNAME}'"}
local -ri EXPECTED_STRING_LEN=${#EXPECTED_STRING}
local REPLY
while true
do
read_from_server $INFD $script_option_READ_TIMEOUT
if mbfl_string_equal "${REPLY:0:${EXPECTED_STRING_LEN}}" "$EXPECTED_STRING"
then return 0
fi
done
}
function write_to_server () {
local OUFD=${1:?"missing output file descriptor parameter to '${FUNCNAME}'"}
local LINE="${2:-}"
if printf '%s\r\n' "$LINE" >&"$OUFD"
then
mbfl_message_debug_printf 'sent (%d bytes): %s' ${#LINE} "$LINE"
return 0
else
mbfl_message_error 'writing to the server'
exit_because_error_writing_to_server
fi
}
function write_to_server_no_log () {
local OUFD=${1:?"missing output file descriptor parameter to '${FUNCNAME}'"}
local LINE="${2:-}"
if printf '%s\r\n' "$LINE" >&"$OUFD"
then return 0
else
mbfl_message_error 'writing to the server'
exit_because_error_writing_to_server
fi
}
function send () {
local TEMPLATE=${1:?"missing template parameter to '${FUNCNAME}'"}
shift
local LINE
printf -v LINE "$TEMPLATE" "$@"
write_to_server $OUFD "$LINE"
}
function send_no_log () {
local TEMPLATE=${1:?"missing template parameter to '${FUNCNAME}'"}
shift
local LINE
printf -v LINE "$TEMPLATE" "$@"
write_to_server_no_log $OUFD "$LINE"
}
function read_and_send_message () {
local -i EXIT_CODE
{
local LINE
if mbfl_string_is_yes "$script_option_EMAIL_TEST_MESSAGE"
then
if ! print_email_test_message
then
mbfl_message_error 'unable to compose test message'
exit_because_invalid_message_source
fi
mbfl_message_verbose 'sending test message\n'
else
if mbfl_string_equal "$script_option_EMAIL_MESSAGE_SOURCE" '-'
then
mbfl_message_verbose 'reading message from stdin\n'
exec 5<&0
else
mbfl_message_verbose 'reading message from file\n'
exec 5<"$script_option_EMAIL_MESSAGE_SOURCE"
fi
while IFS= read -rs LINE <&5
do
# Take care of quoting any intial dot characters.
if mbfl_string_equal "${LINE:0:1}" = '.'
then printf '.%s\n' "$LINE"
else printf  '%s\n' "$LINE"
fi
done
exec 5<&-
fi
} | {
local LINE
local -i LINES_COUNT=0 BYTES_COUNT=0
while IFS= read -rs LINE
do
write_to_server_no_log $OUFD "$LINE"
let ++LINES_COUNT
# The bytes  count for a line  is the line length  plus 2 to
# account for the carriage return and line feed.
BYTES_COUNT+=$((${#LINE} + 2))
done
mbfl_message_debug_printf 'sent message (%d lines, %d bytes)' $LINES_COUNT $BYTES_COUNT
return 0
}
EXIT_CODE=$?
if ((0 == $EXIT_CODE))
then return 0
else exit $EXIT_CODE
fi
}
function print_email_test_message () {
local TO_ADDRESS DATE MESSAGE_ID MESSAGE
local -i i
acquire_local_hostname
TO_ADDRESS=" <${script_option_RECIPIENTS[$i]}>"
for ((i=1; i < ${#script_option_RECIPIENTS[@]}; ++i))
do TO_ADDRESS+=", <${script_option_RECIPIENTS[$i]}>"
done
if ! DATE=$(mbfl_date_email_timestamp)
then
mbfl_message_error 'unable to determine date in RFC-2822 format for test message'
exit_failure
fi
printf -v MESSAGE_ID '%d-%d-%d@%s' "$RANDOM" "$RANDOM" "$RANDOM" "$LOCAL_HOSTNAME"
MESSAGE="Sender: ${script_option_EMAIL_FROM_ADDRESS}
From: <${script_option_EMAIL_FROM_ADDRESS}>
To: ${TO_ADDRESS}
Subject: test message from ${script_PROGNAME}
Message-ID: <${MESSAGE_ID}>
Date: ${DATE}
\n\
This is a test message from the ${script_PROGNAME} script.
Configuration:
\tSMTP hostname:\t\t\t${script_option_SMTP_HOSTNAME}
\tSMTP port:\t\t\t${script_option_SMTP_PORT}
\tsession type:\t\t\t${script_option_SESSION_TYPE}
\tscript option gnutls-cli:\t${script_option_GNUTLS_CONNECTOR}
\tscript option openssl:\t\t${script_option_OPENSSL_CONNECTOR}
\tselected connector:\t\t${script_option_CONNECTOR}
\tauth file:\t\t\t'${script_option_AUTHINFO_FILE}'
\tauth user:\t\t\t'${script_option_AUTH_USER}'
\tauth method plain:\t\t${script_option_AUTH_PLAIN}
\tauth method login:\t\t${script_option_AUTH_LOGIN}
--\x20
The ${script_PROGNAME} script
Copyright ${script_COPYRIGHT_YEARS} $script_AUTHOR
"
printf "$MESSAGE"
}
function esmtp_exchange_greetings () {
local TYPE=${1:?"missing type of greetings parameter to '${FUNCNAME}'"}
acquire_local_hostname
mbfl_message_verbose 'esmtp: exchanging greetings with server\n'
case $TYPE in
helo) send 'HELO %s' "$LOCAL_HOSTNAME" ;;
ehlo) send 'EHLO %s' "$LOCAL_HOSTNAME" ;;
esac
recv_until_string '250 '
}
function esmtp_authentication () {
local AUTH_TYPE=${1:?"missing authorisation type parameter to '${FUNCNAME}'"}
case $AUTH_TYPE in
none)
:
;;
plain)
local LOGIN_NAME=${2:?"missing login name parameter to '${FUNCNAME}'"}
local PASSWORD=${3:?"missing login password parameter to '${FUNCNAME}'"}
local AUTH_PREFIX='AUTH PLAIN ' ENCODED_STRING
mbfl_message_verbose 'performing AUTH PLAIN authentication\n'
if ! ENCODED_STRING=$(printf '\x00%s\x00%s' "$LOGIN_NAME" "$PASSWORD" | pipe_base64)
then
mbfl_message_error 'unable to encode string for authentication'
exit_failure
fi
mbfl_message_debug_printf 'sent (%d bytes): %s<encoded string>' $(( ${#AUTH_PREFIX} + ${#ENCODED_STRING} )) "$AUTH_PREFIX"
send_no_log '%s%s' "$AUTH_PREFIX" "$ENCODED_STRING"
recv 235
;;
login)
local LOGIN_NAME=${2:?"missing login name parameter to '${FUNCNAME}'"}
local PASSWORD=${3:?"missing login password parameter to '${FUNCNAME}'"}
local ENCODED_USER_STRING ENCODED_PASS_STRING
mbfl_message_verbose 'performing AUTH LOGIN authentication\n'
if ! ENCODED_USER_STRING=$(echo -n "$LOGIN_NAME" | pipe_base64)
then
mbfl_message_error 'unable to encode string for authentication'
exit_failure
fi
if ! ENCODED_PASS_STRING=$(echo -n "$PASSWORD"   | pipe_base64)
then
mbfl_message_error 'unable to encode string for authentication'
exit_failure
fi
send 'AUTH LOGIN'
recv 334
mbfl_message_debug_printf 'sent (%d bytes): <encoded string>' ${#ENCODED_USER_STRING}
send_no_log "$ENCODED_USER_STRING"
recv 334
mbfl_message_debug_printf 'sent (%d bytes): <encoded string>' ${#ENCODED_PASS_STRING}
send_no_log "$ENCODED_PASS_STRING"
recv 235
;;
*)
mbfl_message_error_printf 'internal error: invalid AUTH TYPE: "%s"' "$AUTH_TYPE"
exit_because_failure
;;
esac
return 0
}
function esmtp_send_message () {
local -i i
mbfl_message_verbose 'esmtp: sending message\n'
send 'MAIL FROM:<%s>' "$script_option_EMAIL_FROM_ADDRESS"
recv 250
for ((i=0; i < ${#script_option_RECIPIENTS[@]}; ++i))
do
send 'RCPT TO:<%s>' "${script_option_RECIPIENTS[$i]}"
recv 250
done
send %s DATA
recv 354
read_and_send_message
send %s .
recv 250
return 0
}
function esmtp_quit () {
mbfl_message_verbose 'esmtp: end dialogue\n'
send %s QUIT
recv 221
return 0
}
function authinfo_read () {
local OPTION_AUTHINFO_FILE=${1:?"missing autihinfo file pathname parameter to '${FUNCNAME}'"}
local OPTION_SMTP_HOSTNAME=${2:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local OPTION_AUTH_USER=${3:?"missing SMTP login username parameter to '${FUNCNAME}'"}
local mbfl_a_variable_AUTHINFO_AUTH_USER=${4:?"missing authinfo username variable reference parameter to '${FUNCNAME}'"}
local -n AUTHINFO_AUTH_USER=$mbfl_a_variable_AUTHINFO_AUTH_USER
local mbfl_a_variable_AUTHINFO_AUTH_PASSWORD=${5:?"missing authinfo password variable reference parameter to '${FUNCNAME}'"}
local -n AUTHINFO_AUTH_PASSWORD=$mbfl_a_variable_AUTHINFO_AUTH_PASSWORD
local -r ENTRY_REX='^machine[ \t]+([a-zA-Z0-9_.\-]+)[ \t]+login[ \t]+([a-zA-Z0-9_.@\-]+)[ \t]+password[ \t]+([[:graph:]]+)[ \t]*$'
local ENTRY_LINE FOUND=false
mbfl_message_debug_printf 'reading authinfo file: %s' "$OPTION_AUTHINFO_FILE"
while IFS= read ENTRY_LINE
do
if [[ $ENTRY_LINE =~ $ENTRY_REX ]]
then
if mbfl_string_equal "$OPTION_SMTP_HOSTNAME" "${BASH_REMATCH[1]}"
then
# Save the values from the line regex matching.
AUTHINFO_AUTH_USER=${BASH_REMATCH[2]}
AUTHINFO_AUTH_PASSWORD=${BASH_REMATCH[3]}
{
local USERNAME_REX="^.*${OPTION_AUTH_USER}.*$"
if [[ ${BASH_REMATCH[2]} =~ $USERNAME_REX ]]
then
FOUND=true
break
fi
}
fi
fi
done <"$OPTION_AUTHINFO_FILE"
if ! $FOUND
then
mbfl_message_error_printf 'unknown authorisation information for \"%s@%s\"' \
"$OPTION_AUTH_USER" "$OPTION_SMTP_HOSTNAME"
exit_because_unknown_auth_user
fi
}
function hostinfo_read () {
local OPTION_HOSTINFO_FILE=${1:?"missing hostinfo file pathname parameter to '${FUNCNAME}'"}
local OPTION_SMTP_HOSTNAME=${2:?"missing SMTP hostname parameter to '${FUNCNAME}'"}
local mbfl_a_variable_HOSTINFO_SMTP_PORT=${3:?"missing hostinfo SMTP port variable reference parameter to '${FUNCNAME}'"}
local -n HOSTINFO_SMTP_PORT=$mbfl_a_variable_HOSTINFO_SMTP_PORT
local mbfl_a_variable_HOSTINFO_SESSION_TYPE=${4:?"missing hostinfo session type variable reference parameter to '${FUNCNAME}'"}
local -n HOSTINFO_SESSION_TYPE=$mbfl_a_variable_HOSTINFO_SESSION_TYPE
local mbfl_a_variable_HOSTINFO_AUTH_TYPE=${5:?"missing hostinfo auth type variable reference parameter to '${FUNCNAME}'"}
local -n HOSTINFO_AUTH_TYPE=$mbfl_a_variable_HOSTINFO_AUTH_TYPE
local ENTRY_LINE
local -r ENTRY_REX='^machine[ \t]+([a-zA-Z0-9_.\-]+)[ \t]+service[ \t]+smtp[ \t]+port[ \t]+([0-9]+)[ \t]+session[ \t]+(plain|tls|starttls)[ \t]+auth[ \t]+(login|plain|none)[ \t]*$'
local FOUND=false
mbfl_message_debug_printf 'reading hostinfo file: %s' "$OPTION_HOSTINFO_FILE"
while IFS= read ENTRY_LINE
do
if [[ $ENTRY_LINE =~ $ENTRY_REX ]]
then
if mbfl_string_equal "$OPTION_SMTP_HOSTNAME" "${BASH_REMATCH[1]}" && mbfl_string_is_network_port "${BASH_REMATCH[2]}"
then
HOSTINFO_SMTP_PORT=${BASH_REMATCH[2]}
HOSTINFO_SESSION_TYPE=${BASH_REMATCH[3]}
HOSTINFO_AUTH_TYPE=${BASH_REMATCH[3]}
FOUND=true
break
fi
fi
done <"$OPTION_HOSTINFO_FILE"
if ! $FOUND
then
mbfl_message_error_printf 'unknown hostinfo information for \"%s\"' "$OPTION_SMTP_HOSTNAME"
exit_because_unknown_host
fi
}
function acquire_local_hostname () {
if mbfl_string_is_empty "$LOCAL_HOSTNAME"
then
if ! LOCAL_HOSTNAME=$(program_hostname --fqdn)
then
mbfl_message_error 'unable to acquire local hostname'
exit_failure
fi
fi
}
function program_hostname () {
local HOSTNAME_PROGRAM
mbfl_program_found_var HOSTNAME_PROGRAM hostname || exit $?
mbfl_program_exec "$HOSTNAME_PROGRAM" "$@"
}
function pipe_base64 () {
local BASE64
mbfl_program_found_var BASE64 base64 || exit $?
mbfl_program_exec "$BASE64"
}
mbfl_main
