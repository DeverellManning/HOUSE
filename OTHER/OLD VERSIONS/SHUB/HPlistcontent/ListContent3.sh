#!/bin/sh

ans=

NameOf () {
	#ans=$( echo $1 | tr "/" "\n" | tac| head -n 1 | tr "." "\n" | head -n 1 )
    echo $( echo $1 | tr "/" "\n" | tac| head -n 1 | tr "." "\n" | head -n 1 )
}

EmitFolder () {
    if [ -e "$1Container.txt" ]; then
		echo "∏ $( NameOf $1 )\n";
    else
		echo "+ ` echo $1 | tr "/" "\n" | tac| head -n 1 | tr "." "\n" | head -n 1 ` \n";
    fi
}

#find "$_where/"  -maxdepth 1 -type f -printf "$(basename %f)\n"
#return
# Directories:


#echo $unFL

unFL=`find "$_where"/*.* -maxdepth 0 -exec echo '{}' \; `

#dir -d -1 ./*/

#echo $unFL | xargs -n 1 exec basename | echo -

#return

unFL=$( find "$_where"/* -maxdepth 0 -printf '"%p" ')

echo $unFL

NF=0
find "$_where"/* -maxdepth 0 -exec export NF=$(( $NF + 1 ))

for FILE in `seq 1 $NF`; do

echo "+ $FILE"
NameOf $FILE
echo "- $ans\n"
continue;

	#NameOf $FILE
	#if [ -e "$FContainer.txt" ]; then
	#echo "∏ $ans\n";
    #else
      #echo "+ $ans\n";
    #fi
done

# Files:


for F in $_where/*; do
 # IF /I "%%~nG"=="Name" (SET and=1)
 # IF /I "%%~nG"=="veiw" (SET and=1)
  #IF /I "%%~nG"=="veiwUp" (SET and=1)
  #IF /I "%%~nG"=="veiwDown" (SET and=1)
  #IF /I "%%~nG"=="tick" (SET and=1)
  #IF /I "%%~nG"=="dir" (SET and=1)

echo - $F
continue
    #if "%%~xG"==".door" (echo:⌂ %%~nG
    #) ELSE (
    #  echo:- %%~nG)
done

dir | 
return

:skipLoop
  echo continue this loop > nul

Setlocal DisableDelayedExpansion
exit /b

:ContentOfError
ECHO:%_where%\%~1\Container.txt is either not a container(Folder with Container.txt), or does not exist.
exit /b
