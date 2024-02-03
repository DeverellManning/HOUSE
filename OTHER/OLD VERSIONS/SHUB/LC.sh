#!/bin/sh

#echo $1

name=`echo $1|sed -e 's/\..*//'`
type=`echo $1|sed -e 's/.*\.//'`

#echo $type

if [ "$1" = "Name.txt" ];then exit; fi
if [ "$1" = "name.txt" ];then exit; fi
if [ "$name" = "tick" ];then
exit
fi
if [ "$name" = "Veiw" ];then exit; fi
if [ "$name" = "veiw" ];then exit; fi
if [ "$name" = "VeiwDown" ];then
exit
fi
if [ "$name" = "VeiwUp" ];then
exit
fi
if [ "$name" = "dir" ];then
exit
fi

#  IF /I "%%~nG"=="tick" (SET and=1)
#  IF /I "%%~nG"=="dir" (SET and=1)
  
if [ "$type" = "door" ];then
echo "∏ $name";
else
echo "+ $name";
fi



