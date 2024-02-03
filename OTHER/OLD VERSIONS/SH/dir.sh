#!/bin/sh

if [ -e "$_where/Dir.door" ]; then
	goto direx
else
	GOTO ntex
fi

:direx
SET o1=%1
SET in=
IF /i [%1]==["N"] (SET in=n)
IF /i [%1]==["S"] (SET in=s)
IF /i [%1]==["E"] (SET in=e)
IF /i [%1]==["W"] (SET in=w)
IF /i [%1]==["North"] (SET in=n)
IF /i [%1]==["South"] (SET in=s)
IF /i [%1]==["East"] (SET in=e)
IF /i [%1]==["West"] (SET in=w)


FOR /F "delims=," %%G IN (%_where%\Dir.door) DO (CALL :some "%%G")
exit /b

:some

SET part1=%1
SET part1=%part1:~1,2%
SET part2=%1
SET part2=%part2:~3%
SET part2=%part2:~-0,-1%

::echo:%in% %part1% %part2%

IF /I "%in%+"=="%part1%" (GOTO :Found)

if "%1"=="" (goto :emDIR)

GOTO :eof


:FOUND
ECHO:%part2%

IF EXIST %part2%/Name.txt (goto :GODIR) ELSE (ECHO:Unsafe Door in DIR.door)

exit /b


:GODIR
SET /p part2name=<%part2%\Name.txt
ECHO:Walking %o1%, you come to %part2name%
set _where=%part2%
CALL ./PRGM/CMD/look.cmd ""
exit /b


NoDir () {
	echo "No DIR.door file found."
	return
}

BadDir () {
	echo "Incorrectly Written DIR.door file."
	return
}

EmptyDir () {
	echo "Empty DIR.door file."
	return
}
