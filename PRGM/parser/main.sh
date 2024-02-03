#!/bin/bash


pgWord () {
	echo "$_in" | head -n$1 | tail -n1
}

ResolveNoun () {
	echo "Resolving: '$1'"
	
	if [[ ${1:-null} = null ]]; then return; fi
	
	local nc
	ugh=$(echo 's/\<('$pArticles')\>//g')
	ugh=$(echo "$ugh" | sed "s/|/\\\|/g")
	#echo "$ugh"
	nc=$(echo $1 | sed -e "$(echo "$ugh")")
	#echo "$nc"
	nc=$(echo $nc | sed -e 's/ *$//g' | sed -e 's/^ *//g')	#Remove Spaces
	#echo "$nc"
	
	if [[ $mode = DirectPrep || $mode = DirectNoun ]]; then
		dirobj="$nc"
		dirpath=$(find "$_where" -maxdepth 1 -iregex ".*/$nc.*\..*$")
		dirpath="$dirpath\n$(find "$_where" -maxdepth 1 -iregex ".*/$nc.*$")"
		
	elif [[ $mode =~ Indirect.* ]]; then
		true
	fi
	
	echo "'$dirobj'"
	#ponfon "nc"
	
}

#Vocab
pArticles="a|an|the"
pPreps="^($(cat "./PRGM/parser/vocab/prepositions" | tr "\n" "|" ))$"
pSpecialNouns="me|myself|it|all|everything"
pEndings="\.|and|then|!|?"

#echo $pPreps

#Reset
mode=Verb
#mode2=
NounIn=

#Modes:
#Verb			Looking for Verb
#DirectPrep		Looking for Preposition
#DirectNoun		Reading Noun				Until Prep
#IndirectPrep	Looking for Preposition
#IndirectNoun	Reading Noun				Until End


#echo "PARSER"

_in1=$(echo "$_in" | tr "[:upper:]" "[:lower:"] | sed -e "s/[\.!,?]/ &/g" | tr -s "[:blank:]" " " )
_in=$(echo "$_in1" | sed "s/ \+/\n/g")
#echo "$_in1"

if [[ $_in = again ]]; then
	echo "Again!"
	return
fi

#Output
export pVerb=
export dirobj=
export dirpath=
export indobj=
export indpath=
export dirref=
export indref=

export pTime=
export pDir=
export pNumber=
export pQuote=

export dprep=
export iprep=


#Word Collection
GetPrep () {
	if [[ $mode = DirectPrep ]]; then
		dprep="$word"
	elif [[ $mode = IndirectPrep ]]; then
		iprep="$word"
	fi
}


pWordCount=$(echo "$_in" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
#echo $pWordCount

#echo -e "\nLOOP"

for N in $(seq 1 $pWordCount)
do
	word=$(pgWord $N)
	#echo "$N-'$word'	m'$mode'"
	
	if [[ "${word:-null}" = "null" ]]; then continue; fi #skip empty
	if [[ "${word:-null}" = "i" ]]; then continue; fi	#Skip I
	
	if [[ $word =~ $pEndings ]]; then					#Ending
		echo "The End!"
		break
	fi
	
	if [[ $mode = Verb ]]; then							#Finding Verb
		#Check to see if it is a verb
		tverb=$(find "./PRGM/action/" -iname "$word.sh")
		if [[ -e "$tverb" && "${pVerb:-null}" = null ]]; then
			#echo "Found a Verb!"
			pVerb="$tverb"
			mode="DirectPrep"
		fi
		continue
	fi
	
	if [[ $mode = DirectPrep ]]; then					#Find Direct Preposition
		if [[ $word =~ $pPreps ]]; then
			GetPrep
			NounIn=
			mode="DirectNoun"
			continue
		fi
		NounIn=
		mode="DirectNoun"
	fi
	
	if [[ $mode = DirectNoun ]]; then
		NounIn="$NounIn $word"
		#echo $NounIn
		if [[ $word =~ $pPreps ]]; then
			mode=DirectNoun
			ResolveNoun "$NounIn"
			#mode="IndirectPrep"
		fi
	fi
	
	if [[ $mode = IndirectPrep ]]; then		
		if [[ $word =~ $pPreps ]]; then
			GetPrep
		fi
		NounIn=
		#mode="IndirectNoun"
	fi
	
	if [[ $mode = IndirectNoun ]]; then
		NounIn="$NounIn $word"
		#echo $NounIn
	fi
	continue
	
	
	#elif [[ $mode2 != "verb" ]]; then			#Findiding Direct/Indirect Clauses
		#if [[ $word =~ $pArticles ]]; then			#Article
			#echo "Article!"
			#mode="noun"
			#NounIn="$word"
			#continue
		#elif [[ $word =~ $pSpecialNouns ]]; then	#Special Noun
			#echo "Special Noun!"
			#mode="noun"
			#NounIn="$word"
			#continue
		#fi
		
		
		#if [[ $word =~ $pPreps ]]; then				#Preposition
			#echo "Preposition!"
			##mode="noun"
			#GetPrep
			#continue
		#fi
	#else									#Finding Verb

	#fi
	
done

if [[ ${dirobj:-null} = null ]]; then
	if [[ ${dprep:-null} != null ]]; then
		ResolveNoun "$dprep"
		dprep=
		mode=
	fi
fi
			
if [[ $mode = DirectNoun || $mode = IndirectNoun ]]; then
	ResolveNoun "$NounIn"
fi


#echo -e "Really Done.\n"
echo "Verb:	$pVerb"
echo "DirObj: '$dirobj'"
echo -e "$dirpath"
echo "IndObj: '$indobj'"
echo -e "$indpath"
#export dirref=
#export indref=

#export pTime=
#export pDir=
#export pNumber=
#export pQuote=

echo "DPrep:	$dprep"
echo "IPrep:	$iprep"


sleep .5
if [[ -e $pVerb ]]; then
	. "$pVerb"
	return
fi

   #echo "Unreconized command! Checking Aliases and Items:"
   #Aliases                   #items                        
   . ./PRGM/parser/Alias.sh || . ./PRGM/parser/ItemCheck.sh || \
   echo "$_in">>"./OTHER/UnrecAction.txt"

_in=
