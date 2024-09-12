#!/bin/bash

#Single Direct Clause Parser
#	$_in	-	Input String


#Check for nothing
if [[ "${_in:-null}" == "null" ]]; then
	return
fi
		
#Check for Again
aginck=$(echo "$_in" | tr "[:upper:]" "[:lower:"] | sed -e "s/[[:blank:]]//g" )
if [[ $aginck = "again" || $aginck = "repeat" || $aginck = "a" ]]; then
	echo "Again!"
	if [[ -e $pVerb ]]; then
		. "$pVerb"
		return
	fi                     
	. ./PRGM/parser/Alias.sh || . ./PRGM/parser/ItemCheck.sh || \
	echo "$_in">>"./OTHER/LOG/UnrecAction.txt"
	return
elif [[ $aginck = "more" ]]; then
	echo "More!"
	if [[ -e $pVerb ]]; then
		. "$pVerb"
		return
	fi                     
	. ./PRGM/parser/Alias.sh || . ./PRGM/parser/ItemCheck.sh || \
	echo "$_in">>"./OTHER/LOG/UnrecAction.txt"
	return
fi

#Output
export pVerb=		#Verb
export dirobj=		#Object(s) Name
export dirpath=		#Object(s) Path
export dirref=		#Object(s)'s First Refrence's Path
export pDir=		#A Direction
export pNumber=		#Number
export pQuote=		#Quoted Text
export dprep=		#Preposition

#Vocab
pArticles="a|an|the"
pPreps="^($(cat "./PRGM/parser/vocab/prepositions" | tr "\n" "|" ))$"
pSpecialNouns="me|myself|it|all|everything"
pEndings="(\.|and|then|\!|\?)"

#Functions
pgWord () {
	echo "$_in" | head -n$1 | tail -n1
}

ResolveNoun () {
	#echo "Resolving: '$1'"
	
	if [[ ${1:-null} = null ]]; then return; fi
	
	local nc
	
	nc=$(echo "$1" | sed -e "s/\<\(a\|an\|the\) //g" )		#Remove Articles
	#echo "1. $nc"
	nc=$(echo $nc | sed -e 's/ *$//g' | sed -e 's/^ *//g')	#Remove Spaces
	#echo "2. $nc"
	
	#Remove unneeded preposition:
	if [[ "$nc" =~ ^([A-Za-z]+ )+ ]]; then		#Multi Word
		ncpart=$(echo "$nc" | grep -oE "^[A-Za-z]+")		#Get First Word
		if [[ $ncpart =~ $pPreps ]]; then
			nc=$(echo "$nc" | sed -e "s/^[A-Za-z]\+ //")
			
		fi
	fi
	
	#Finding And Assigning
	dirobj="$nc"	#Noun Itself
	
	dirpath=$(findwhere "$nc")
	
	dirpath="$dirpath\n$(findtarget "$nc")"
	dirpath="$dirpath\n$(findinv "$nc")"
	
	#echo "3. '$dirobj'"
	#ponfon "nc"
	
}
_bin="$_in"
_win=$(echo "$_in" | sed -e "s/[Ii] //" | sed -e "s/\(the\|a\|an\) //")
_act=$(echo "$_win" | sed -e "s/ .*//")
_p1=$(echo "$_win"  | sed -e "s/^[^ ]* //" | sed -e "s/ .*$//")
_p2=$(echo "$_win"  | sed -e "s/^[^ ]* //" | sed -e "s/^[^ ]* //" )

if [ $_p1 = "$_p2" ]; then
_p2=
fi

if [ $_act = $_p1 ]; then
_p1=
fi

decho "-$_act-$_p1-$_p2-"

#Prepare Input
_in1=$(echo "$_in" | tr "[:upper:]" "[:lower:"] | sed -e "s/[\.!,?]/ &/g" | tr -s "[:blank:]" " " )
_in=$(echo "$_in1" | sed "s/ \+/\n/g")


pWordCount=$(echo "$_in" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
#echo $pWordCount

#echo -e "\nLOOP"

newin=
for N in $(seq 1 $pWordCount)		#Find Verb
do
	word=$(pgWord $N)
	#echo "$N-'$word'"
	
	if [[ "${word:-null}" = "null" ]]; then continue; fi #skip empty
	if [[ "${word:-null}" = "i" ]]; then continue; fi	#Skip I
	
	if [[ $word =~ $pEndings ]]; then					#Ending
		decho "The End!"
		break
	fi
	
	#Check to see if it is a verb
		tverb=$(find "./PRGM/action/" -iname "$word.sh")
		if [[ -e "$tverb" && "${pVerb:-null}" = null ]]; then
			#echo "Found a Verb!"
			pVerb="$tverb"
			continue
		else
			newin="$newin\n$word"
		fi
done
#echo -e "$newin"
_in=$(echo -e "$newin")
pWordCount=$(echo "$_in" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')

NounIn=
done=f

for N in $(seq 1 $pWordCount | tac)		#Find Noun Phrase
do
	word=$(pgWord $N)
	#echo "$N-'$word'"
	
	if [[ "${word:-null}" = "null" ]]; then continue; fi 	#skip empty
	if [[ "${word:-null}" = "i" ]]; then continue; fi		#Skip I
	
	if [[ $word =~ ^($pEndings)$ ]]; then					#Ending
		decho "The End!"
		done=f
	else
		if [[ $word =~ ^($pArticles)$ ]]; then				#Article
			decho "Article!"
			done=t
			NounIn="$word $NounIn"
			break
		elif [[ $word =~ ^$pSpecialNouns$ ]]; then			#Special Noun
			decho "Special Noun!"
			done=t
			NounIn="$word $NounIn"
			continue
		fi
		
		if [[ $done = f ]]; then
			NounIn="$word $NounIn"
		fi
	fi
done
ResolveNoun "$NounIn"

for N in $(seq 1 $pWordCount); do		#Find Preposition
	word=$(pgWord $N)
	#echo "$N-'$word'"
	
	if [[ "${word:-null}" = "null" ]]; then continue; fi #skip empty
	if [[ "${word:-null}" = "i" ]]; then continue; fi	#Skip I
	
	if [[ $word =~ ^($pEndings)$ ]]; then					#Ending
		echo "The End!"
		begn=f
	else
		if [[ $word =~ $pPreps ]]; then
			dprep="$word"
			break
		fi
	fi
done

decho "$pVerb-$dirobj-$dprep"

#Log results to parser log file.

(
echo "+Time: $ttick, Name: $_name."
echo "  String: '$_bin'"
echo "  Results from Parsing:"
echo "  Verb: $pVerb"
echo "  Direct Object: '$dirobj'"
echo "      ($dirpath)"
echo "  Direct Preposition:'$dprep'"
echo
) >> $ppath/life/.parser.log &

if [[ ${_ptest:-false} = false ]]; then
	if [[ -e $pVerb ]]; then
		. "$pVerb" || echo "$_bin">>"./OTHER/LOG/UnrecAction.txt"
		return
	fi

	#echo "Unreconized command! Checking Aliases and Items:"
	#Aliases                   #items                        
	. ./PRGM/parser/Alias.sh || . ./PRGM/parser/ItemCheck.sh || \
	echo "$_bin">>"./OTHER/LOG/UnrecAction.txt"
	_in=
else
		echo "---- ---- ----"
		echo "RESULTS:"

		echo "Verb:	$pVerb"
		echo
		echo "DirObj: '$dirobj'"
		echo -e "$dirpath"
		echo "$dirref"

		echo "$pDir"
		echo "$pNumber"
		echo "$pQuote"

		echo "DPrep:	$dprep"
		echo -e "Done!\n"
fi
