function mbfl_times_and_dates_enable () {
mbfl_declare_program date
}
function mbfl_exec_date () {
local DATE
mbfl_program_found_var DATE date || exit $?
mbfl_program_exec "$DATE" "$@"
}
function mbfl_exec_date_format () {
local FORMAT=${1:?"missing date format parameter to '${FUNCNAME}'"}
shift
mbfl_exec_date "$FORMAT" "$@"
}
function mbfl_date_current_year () {
mbfl_exec_date_format '+%Y'
}
function mbfl_date_current_month () {
mbfl_exec_date_format '+%m'
}
function mbfl_date_current_day () {
mbfl_exec_date_format '+%d'
}
function mbfl_date_current_hour () {
mbfl_exec_date_format '+%H'
}
function mbfl_date_current_minute () {
mbfl_exec_date_format '+%M'
}
function mbfl_date_current_second () {
mbfl_exec_date_format '+%S'
}
function mbfl_date_current_date () {
mbfl_exec_date_format '+%F'
}
function mbfl_date_current_time () {
mbfl_exec_date_format '+%T'
}
function mbfl_date_email_timestamp () {
mbfl_exec_date --rfc-2822
}
function mbfl_date_iso_timestamp () {
mbfl_exec_date --iso-8601=ns
}
