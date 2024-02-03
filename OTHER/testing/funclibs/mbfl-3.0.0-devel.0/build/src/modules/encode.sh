function mbfl_encode_hex_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_INPUT=${2:?"missing input string parameter to '${FUNCNAME}'"}
local -i mbfl_I
local mbfl_OCTET mbfl_ENCODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; ++mbfl_I))
do
printf -v mbfl_OCTET         '%d' "'${mbfl_INPUT:${mbfl_I}:1}"
printf -v mbfl_ENCODED_OCTET '%02X' "$mbfl_OCTET"
mbfl_RESULT_VARREF+=$mbfl_ENCODED_OCTET
done
return 0
}
function mbfl_encode_hex () {
local INPUT=${1:?"missing input string parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
mbfl_encode_hex_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_encode_oct_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_INPUT=${2:?"missing input string parameter to '${FUNCNAME}'"}
local -i mbfl_I
local mbfl_OCTET mbfl_ENCODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; ++mbfl_I))
do
printf -v mbfl_OCTET         '%d' "'${mbfl_INPUT:${mbfl_I}:1}"
printf -v mbfl_ENCODED_OCTET '%03o' "$mbfl_OCTET"
mbfl_RESULT_VARREF+=$mbfl_ENCODED_OCTET
done
return 0
}
function mbfl_encode_oct () {
local INPUT=${1:?"missing input string parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
mbfl_encode_oct_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_decode_hex_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_INPUT=${2:?"missing input string parameter to '${FUNCNAME}'"}
local -i mbfl_I
local mbfl_DECODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; mbfl_I+=2))
do
printf -v mbfl_DECODED_OCTET "\\x${mbfl_INPUT:${mbfl_I}:2}"
mbfl_RESULT_VARREF+=$mbfl_DECODED_OCTET
done
return 0
}
function mbfl_decode_hex () {
local INPUT=${1:?"missing input string parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
mbfl_decode_hex_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_decode_oct_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_INPUT=${2:?"missing input string parameter to '${FUNCNAME}'"}
local -i mbfl_I
local mbfl_DECODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; mbfl_I+=3))
do
printf -v mbfl_DECODED_OCTET "\\${mbfl_INPUT:${mbfl_I}:3}"
mbfl_RESULT_VARREF+=$mbfl_DECODED_OCTET
done
return 0
}
function mbfl_decode_oct () {
local INPUT=${1:?"missing input string parameter to '${FUNCNAME}'"}
local RESULT_VARNAME
mbfl_decode_oct_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
