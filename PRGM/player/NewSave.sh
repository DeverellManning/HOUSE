#!/bin/bash

#Layout
ppath="./WORLD/CHARACTERS/PLAYERS/$idir"
mkdir "./WORLD/CHARACTERS/PLAYERS/$idir"

mkdir "$ppath/ablities"
mkdir "$ppath/life"
mkdir "$ppath/looks"
mkdir "$ppath/personality"
mkdir "$ppath/stats"
mkdir "$ppath/Wallet"


#Inventory, Clothes
mkdir "$ppath/Inventory"
mkdir "$ppath/Clothes"
mkdir "$ppath/Clothes/Hat"
mkdir "$ppath/Clothes/Pants"
mkdir "$ppath/Clothes/Shirt"
mkdir "$ppath/Clothes/Shoes"


touch "$ppath/Hands"
touch "$ppath/Target"
touch "$ppath/mesg"
touch "$ppath/transfer"

echo "$iname">"$ppath/Name.txt"
echo "$igender">"$ppath/Gender"
echo "$ispec">"$ppath/Species"
echo "$start">"$ppath/Where"


#./ablities:
echo $cha >"$ppath/ablities/Charisma"
echo $dex >"$ppath/ablities/Dexterity"
echo $int >"$ppath/ablities/Inteligence"
echo $str >"$ppath/ablities/Strength"
echo $wis >"$ppath/ablities/Wisdom"

echo $speed >"$ppath/ablities/Speed"

#./life:
#Class
#Language
#Occupation

#./looks:
echo $ibuild>"$ppath/looks/Build"
. ./$SPath/Save.sh
#Looks.prop						- Done by SpeciesSave.sh or something


#./personality:
#ChromaName.txt
#Backstory type stuff
echo -e "$Disc">"$ppath/Disc.txt"
echo -e"$Like">"$ppath/personality/Like.txt"
echo -e "$Dislike">"$ppath/personality/Dislike.txt"


#./stats:
touch "$ppath/stats/Conditions"
touch "$ppath/stats/Air"

#Maximums
echo "$MaxEnergy">"$ppath/stats/MaxEnergy"
echo "$MaxHealth">"$ppath/stats/MaxHealth"
echo "$MaxWater">"$ppath/stats/MaxWater"
echo "$HealSpeed">"$ppath/stats/HealSpeed"

#Player starts with max values
echo "$MaxHealth">"$ppath/Health"
echo "$MaxEnergy">"$ppath/Energy"
echo "$MaxWater">"$ppath/Water"

#Build Stats
echo "$baseH">"$ppath/stats/Height"
echo "$baseW">"$ppath/stats/Weight"
echo "$iSize">"$ppath/stats/Size"

echo "98">"$ppath/stats/Temprature"



#./Wallet:
echo "30">"$ppath/Wallet/Coins"
touch "$ppath/Wallet/Journal.txt"



#Change Permissions
chmod -R ug=rwx "$ppath"
#Set Group
chown -R :house-project "$ppath"
#Add character to this user's characters file
echo "$idir">>"./SERVER/USERS/${_username}/characters"

