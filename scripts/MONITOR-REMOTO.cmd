:: SCRIPT MONITOR REMOTO
:: AUTOR: guxlar
:: ACTUALIZACION: 16:01 26/5/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: EXTERNALIP = dirección IP pública del servidor DayZ
:: QUERYPORT = debe coincidir con el port del servidor DayZ, mas uno (ejemplo: 2302+1=2303)
:: SEGUNDOS = tiempo en segundos entre cada medicion
:: DISCORDWEBHOOK = enlace al webhook del Discord donde se muestran los mensajes
::
SET EXTERNALIP=190.48.194.91
SET QUERYPORT=2303 
SET SEGUNDOS=300 
SET DISCORDWEBHOOK=https://discord.com/api/webhooks/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
::
:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Script: %~nx0\"}" %DISCORDWEBHOOK%
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Servidor: %COMPUTERNAME%\"}" %DISCORDWEBHOOK%
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Usuario: %USERNAME%\"}" %DISCORDWEBHOOK%
ECHO [%mydate% %mytime% - %~nx0] Script: %~nx0


:START
CLS

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Consultando servidor %SERVERNAME%:%QUERYPORT%\"}" %DISCORDWEBHOOK% > curloutput.txt

powershell.exe -Command (new-object System.Net.WebClient).DownloadString('http://dayzsalauncher.com/api/v1/query/%EXTERNALIP%/%QUERYPORT%') >> dzoutput.txt

curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] DAYZSALAUNCHER OUTPUT STATUS: %DZSTATUS% (0=OK 1=ERR) \"}" %DISCORDWEBHOOK% >> curloutput.txt

curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Esperando %SEGUNDOS% segundos...\"}" %DISCORDWEBHOOK% >> curloutput.txt

ECHO Servidor consultado: %SERVERNAME%:%QUERYPORT%

SET /p DZJSON=<dzoutput.txt
CALL SET "DZSTATUS=%%DZJSON:~10,1%%"

ECHO %DZJSON%
ECHO %DZSTATUS%
ECHO Esperando %SEGUNDOS% segundos...

TIMEOUT %SEGUNDOS%
GOTO START

:FINALIZAR
DEL dzoutput.txt
DEL curloutput.txt
