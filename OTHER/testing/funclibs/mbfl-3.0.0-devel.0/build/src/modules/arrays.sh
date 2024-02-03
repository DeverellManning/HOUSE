function mbfl_array_is_empty () {
local mbfl_a_variable_mbfl_ARRAY_VARREF=${1:?"missing array variable name parameter to '${FUNCNAME}'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
if ((0 == ${#mbfl_ARRAY_VARREF[@]}))
then return 0
else return 1
fi
}
function mbfl_array_is_not_empty () {
local mbfl_a_variable_mbfl_ARRAY_VARREF=${1:?"missing array variable name parameter to '${FUNCNAME}'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
if ((0 != ${#mbfl_ARRAY_VARREF[@]}))
then return 0
else return 1
fi
}
function mbfl_array_length_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_a_variable_mbfl_ARRAY_VARREF=${2:?"missing array variable name parameter to '${FUNCNAME}'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
mbfl_RESULT_VARREF=${#mbfl_ARRAY_VARREF[@]}
}
function mbfl_array_length () {
local mbfl_a_variable_mbfl_ARRAY_VARREF=${1:?"missing array variable name parameter to '${FUNCNAME}'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
echo ${#mbfl_ARRAY_VARREF[@]}
}
