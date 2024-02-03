ItemIn=$(echo "$_p1 $_p2" | sed -e 's/ *$//g')



Item=$(findtarget "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findwhere "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findinv "$ItemIn")
[[ ${Item:-null} = null ]] && { echo "There is no $ItemIn."; return;}
Item=$(echo "$Item" | head -n 1)

if [ "${Item:-null}" = null ]; then return; fi

. "./PRGM/transaction/LookAt.sh";
