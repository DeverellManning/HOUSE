#!/bin/sh

echo "Press Enter to start loading your data."
read var
echo "Loading Character Data:"

echo "Name: '$_act'"

_name=$_act

sleep 1

#echo "$ppath/coins.txt"

_health=`cat "$ppath/Health.txt"`
echo "health:$_health"

_coins=`cat "$ppath/coins.txt"`
echo "Coins:$_coins"

_where=`cat "$ppath/where.txt"`
echo "Where:$_where"

_yip=`cat "$ppath/Yip.txt"`
echo "Yip:$_yip"

#Global Vars:

ttick=`cat "./WORLD/Time.txt"`

