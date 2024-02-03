function mbfl_p_check_fd () {
local FD=${1:?"missing file descriptor parameter to '${FUNCNAME}'"}
local POS=${2:?"missing positional argument index parameter to '${FUNCNAME}'"}
if mbfl_string_is_digit "$1"
then return 1
else
mbfl_message_error_printf 'file descriptor positional argument %d is not a digit: "%s"' $POS "$FD"
return 0
fi
}
function mbfl_fd_open_input () {
local FD=${1:?"missing file descriptor parameter to '${FUNCNAME}'"}
local FILE=${2:?"missing file pathname parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$FD" 1
then return 1
fi
eval "exec ${FD}<\"\${FILE}\""
}
function mbfl_fd_open_output () {
local FD=${1:?"missing file descriptor parameter to '${FUNCNAME}'"}
local FILE=${2:?"missing file pathname parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$FD" 1
then return 1
fi
eval "exec ${FD}>\"\${FILE}\""
}
function mbfl_fd_open_input_output () {
local FD=${1:?"missing file descriptor parameter to '${FUNCNAME}'"}
local FILE=${2:?"missing file pathname parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$FD" 1
then return 1
fi
eval "exec ${FD}<>\"\${FILE}\""
}
function mbfl_fd_close () {
local FD=${1:?"missing file descriptor parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$FD" 1
then return 1
fi
eval "exec ${FD}<&-"
}
function mbfl_fd_dup_input () {
local SRCFD=${1:?"missing source file descriptor parameter to '${FUNCNAME}'"}
local DSTFD=${2:?"missing dest file descriptor parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$SRCFD" 1
then return 1
fi

if mbfl_p_check_fd "$DSTFD" 2
then return 1
fi
eval "exec ${DSTFD}<&${SRCFD}"
}
function mbfl_fd_dup_output () {
local SRCFD=${1:?"missing source file descriptor parameter to '${FUNCNAME}'"}
local DSTFD=${2:?"missing dest file descriptor parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$SRCFD" 1
then return 1
fi

if mbfl_p_check_fd "$DSTFD" 2
then return 1
fi
eval "exec ${DSTFD}>&${SRCFD}"
}
function mbfl_fd_move () {
local SRCFD=${1:?"missing source file descriptor parameter to '${FUNCNAME}'"}
local DSTFD=${2:?"missing dest file descriptor parameter to '${FUNCNAME}'"}

if mbfl_p_check_fd "$SRCFD" 1
then return 1
fi

if mbfl_p_check_fd "$DSTFD" 2
then return 1
fi
eval "exec ${DSTFD}<&${SRCFD}-"
}
