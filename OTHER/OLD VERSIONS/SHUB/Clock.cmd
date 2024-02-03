echo OFF
COLOR 0F
chcp 65001>NULL

SET time=%~1
IF [%2]==[""] (SET /P time=Enter hour:)


if %time% LEQ 12 SET APM=AM
if %time% GTR 12 SET APM=PM
if %time% GTR 24 exit /b

if %APM%==PM SET /A time=%time%-12
if %time% EQU 0 SET time=12

SET min=00
SET min=%~2

if %min% LEQ 9 SET min=0%min%

::echo:AM/PM:%APM%
::echo:Hour:%time%

SET "ln1= ▄▄▄▄▄▄▄▄▄ "
SET "ln2=▐▀ - - - ▀▌"
SET "ln3=▐-       -▌"
SET "ln4=▐-   ♦   -▌"
SET "ln5=▐-       -▌"
SET "ln6=▐▄ - - - ▄▌"
SET "ln7= █▀▀▀▀▀▀▀█ "
SET "ln8= █?      █ "
SET "ln9=  ▀▀▀▀▀▀▀  "


if "%time%"=="1" (
SET "ln2=▐▀ - - ▄ ▀▌"
SET "ln3=▐-    /  -▌"
)

if "%time%"=="2" (
SET "ln3=▐-     _─▌▌"
SET "ln4=▐-   ♦¯  -▌"
)

if "%time%"=="3" (
SET "ln4=▐    ♦═══▌▌"
)

if "%time%"=="4" (
SET "ln4=▐-   ♦_  -▌"
SET "ln5=▐-     ¯─▌▌"
)

if "%time%"=="5" (
SET "ln5=▐-    \  -▌
SET "ln6=▐▄ - - ▀ ▄▌
)

if "%time%"=="6" (
SET "ln5=▐-   ║   -▌"
SET "ln6=▐▄ - ▀ - ▄▌"
)


if "%time%"=="7" (
SET "ln5=▐-  /    -▌"
SET "ln6=▐▄ ▀ - - ▄▌
)

if "%time%"=="8" (
SET "ln4=▐-  _♦   -▌"
SET "ln5=▐▐─¯     -▌"
)

if "%time%"=="9" (
SET "ln4=▐▐═══♦   -▌"
)

if "%time%"=="10" (
SET "ln3=▐▐─_     -▌
SET "ln4=▐-  ¯♦   -▌
)

if "%time%"=="11" (
SET "ln2=▐▀ ▄ - - ▀▌
SET "ln3=▐-  \    -▌
)

if "%time%"=="12" (
SET "ln2=▐▀ - ▄ - ▀▌
SET "ln3=▐-   ║   -▌
)

if %time% LEQ 9 SET "ln8= █%time%:%min% %APM%█ "
if %time% GEQ 10 SET "ln8= █%time%:%min%%APM%█ "


if %APM%==AM echo:[42m[37m

if %APM%==PM echo:[33m[40m

echo:%ln1%
echo:%ln2%
echo:%ln3%
echo:%ln4%
echo:%ln5%
echo:%ln6%
echo:%ln7%
echo:%ln8%
echo:%ln9%
if %APM%==AM echo:[0m[40m[37m

IF [%2]==[""] (CALL Clock.cmd)

