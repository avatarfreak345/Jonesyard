@echo off
cls

set n=[NeoLaunch]
set i=[INFO]
set w=[WARN]
set e=[ERROR]
set ex=[EXIT]

echo +=========+
echo +NeoLaunch+
echo +=========+
echo ___________

IF EXIST !OPENED.txt (

echo %n%%e% NeoFly is showing opened on another PC. NeoFly was not launched to avoid internal conflicts.
echo %n%%e% Open NeoFly manually or delete '!OPENED.txt' to override.
pause

) ELSE (

echo %n%%i% Registering NeoFly as OPENED...
call>!OPENED.txt
echo %n%%i% Generated '!OPENED.txt'.
echo %n%%i% Opening Logbook...

IF EXIST !zLOGBOOK.txt (
notepad !zLOGBOOK.txt
echo %n%%i% Logbook Closed.
) ELSE (
echo %n%%w% '!zLOGBOOK.txt' could not be found!!!
)

echo %n%%i% Launching NeoFly...
echo %n%%i% Monitoring Application Status.

NeoFly.exe

echo %n%%i% Closing NeoFly...
echo %n%
echo %n%

echo %n%%i% Registering NeoFly as CLOSED...
IF EXIST !OPENED.txt (
del !OPENED.txt
echo %n%%i% Removed '!OPENED.txt'.
) ELSE (
echo %n%%w% '!OPENED.txt' was not deleted because it doesn't exists.
)

echo %n%%i% Opening Logbook...

IF EXIST !zLOGBOOK.txt (
notepad !zLOGBOOK.txt
echo %n%%i% Logbook Closed.
) ELSE (
echo %n%%w% '!zLOGBOOK.txt' was not opened because it does not exists! This is bad.
)

echo %n%%i% NeoFly Closed Sucessfully!

)

echo %n%%ex% NeoLaunch Exiting... goodbye :)
TIMEOUT /T 5