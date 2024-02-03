

while [ true ]
do
	butlermessage="$(cat "./DYNAMIC/Servants/Butler/message.txt")"
	if [ "${butlermessage:-null}" != null ]; then
	tput cuu1; tput il1; echo -ne "$butlermessage"; tput cud1; echo -ne "> "
	echo "">"./DYNAMIC/Servants/Butler/message.txt"
	fi
	sleep 1
done
