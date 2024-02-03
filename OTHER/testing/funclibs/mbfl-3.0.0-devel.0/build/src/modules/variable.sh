function mbfl_variable_find_in_array () {
local ELEMENT=${1:?"missing element parameter parameter to '${FUNCNAME}'"}
local -i i ARRAY_DIM=${#mbfl_FIELDS[*]}
for ((i=0; i < ARRAY_DIM; ++i))
do
if mbfl_string_equal "${mbfl_FIELDS[$i]}" "$ELEMENT"
then
printf '%d\n' $i
return 0
fi
done
return 1
}
function mbfl_variable_element_is_in_array () {
local pos
pos=$(mbfl_variable_find_in_array "$@")
}
function mbfl_variable_colon_variable_to_array () {
local COLON_VARIABLE=${1:?"missing colon variable parameter to '${FUNCNAME}'"}
local ORGIFS=$IFS
IFS=: mbfl_FIELDS=(${!COLON_VARIABLE})
IFS=$ORGIFS
return 0
}
function mbfl_variable_array_to_colon_variable () {
local COLON_VARIABLE=${1:?"missing colon variable parameter to '${FUNCNAME}'"}
local -i i dimension=${#mbfl_FIELDS[*]}
if test $dimension = 0
then eval $COLON_VARIABLE=
else
eval ${COLON_VARIABLE}=\'"${mbfl_FIELDS[0]}"\'
for ((i=1; $i < $dimension; ++i))
do eval $COLON_VARIABLE=\'"${!COLON_VARIABLE}:${mbfl_FIELDS[$i]}"\'
done
fi
return 0
}
function mbfl_variable_colon_variable_drop_duplicate () {
local COLON_VARIABLE=${1:?"missing colon variable parameter to '${FUNCNAME}'"}
local item
local -a mbfl_FIELDS FIELDS
local -i dimension count i
mbfl_variable_colon_variable_to_array "$COLON_VARIABLE"
dimension=${#mbfl_FIELDS[*]}
FIELDS=("${mbfl_FIELDS[@]}")
mbfl_FIELDS=()
for ((i=0, count=0; i < dimension; ++i))
do
item=${FIELDS[$i]}
if mbfl_variable_element_is_in_array "$item"
then continue
fi
mbfl_FIELDS[$count]=$item
let ++count
done
mbfl_variable_array_to_colon_variable $COLON_VARIABLE
return 0
}
function mbfl_variable_alloc () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '${FUNCNAME}'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_NAME
while true
do
mbfl_NAME=mbfl_u_variable_${RANDOM}
local -n mbfl_REF=$mbfl_NAME
if ((0 == ${#mbfl_REF} && 0 == ${#mbfl_REF[@]}))
then break
fi
done
mbfl_RESULT_VARREF=$mbfl_NAME
return 0
}
