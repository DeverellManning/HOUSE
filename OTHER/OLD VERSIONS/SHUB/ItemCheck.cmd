::This program will check for doors and items
::at the location of %_where%
::If found, it will attempt to use the item,
::aka going through a door, or typing an 
::items discription.

SET "_ITEM=%~1 %~2"
IF %2=="" (SET "_ITEM=%~1")

ECHO: -ITEM CHECK- Checking for ("%_where%\%_ITEM%")

IF EXIST "%_where%\%_ITEM%" (Goto FoundFolder)
IF EXIST "%_where%\%_ITEM%.door" (Goto FoundDoor)
IF EXIST "%_where%\%_ITEM%.txt" (Goto FoundTxt)
Goto Unfound

:FoundFolder
ECHO:Found a Folder
IF EXIST "%_where%\%_ITEM%\Disc.txt" (CALL ./PRGM/CMD/look.cmd "%_ITEM%")
EXIT /b


:FoundDoor
::ECHO:Found a door
CALL ./PRGM/CMD/door.cmd "%_ITEM%"
EXIT /b

:FoundTxt
::ECHO: Found a Text File!
CALL ./PRGM/CMD/look.cmd "%_ITEM%"
EXIT /b



:Unfound
ECHO:Command not recognized!
ECHO:%_ITEM% >> ".\Other\UnrecCMDS.txt"
Exit /b