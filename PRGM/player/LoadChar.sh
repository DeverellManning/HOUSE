#!/bin/bash

echo "Press any key to load your character."
pause
echo "Loading Character Data:"
sleep 1

echo "User: $_username "
echo "Player Path:'$ppath' Folder Name: $pname"

_name=$(cat "$ppath/Name.txt")
_sname=$_name
echo "Name: $_name, Short Name: $_sname"

_gender=$(cat "$ppath/Gender")
echo "Gender: $_gender"

#Health
_health=`cat "$ppath/Health"`
_maxhealth=$(cat $ppath/stats/MaxHealth)
_healspeed=$(cat $ppath/stats/HealSpeed)
echo "health:$_health"

#Energy
_energy=`cat "$ppath/Energy"`
_maxenergy=$(cat $ppath/stats/MaxEnergy)
echo "energy:$_energy"

#Water
_water=$(cat $ppath/Water)
_maxwater=$(cat $ppath/stats/MaxWater)

_energybuffer=0
_healthbuffer=0
_waterbuffer=0


_coins=`cat "$ppath/Wallet/Coins"`
echo "Coins:$_coins"

_where=`cat "$ppath/Where"`
_lastwhere=$_where
echo "Where:$_where"

_hand=$(< "$ppath/Hands")
echo "Hands:$_hand"

_yip=`cat "$ppath/Species"`
_species=`cat "$ppath/Species"`
echo "Yip:$_yip"

#Load Looks
_look_hair_l=$(qprop hair-length@Looks "$ppath/looks/looks.prop")

#Load Words (Verbs, Body part names, etc)
. "./PRGM/player/species/defaultvars.sh"
. "./PRGM/player/species/$_species/swords.sh"
[[ -e "$ppath/looks/my_swords.sh" ]] && . "$ppath/looks/my_swords.sh"

#Load

#Global Vars:
# (Now loaded by Master Proccess)

echo "Done. Press any key."
pause

