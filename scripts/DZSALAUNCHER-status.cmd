:: SCRIPT DEL LAUNCHER ROJO
:: AUTOR: guxlar
:: ACTUALIZACION: 9:19 AM 5/11/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: QUERYPORT = debe coincidir con el del DAYZ SERVER mas uno (2302+1)=2303
:: SEGUNDOS = tiempo en segundos entre cada medicion
:: DiscordWebHook = enlace al webhook del Discord donde se muestran los mensajes
::
SET QUERYPORT=2303 
SET SEGUNDOS=300 
SET DiscordWebHook=https://discord.com/api/webhooks/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
::
:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Script: %~nx0\"}" %DiscordWebHook%
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Servidor: %COMPUTERNAME%\"}" %DiscordWebHook%
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Usuario: %USERNAME%\"}" %DiscordWebHook%
echo [%mydate% %mytime% - %~nx0] Script: %~nx0

:: Obtengo la dirección IP externa desde www.showmyip.com
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Obteniendo la direccion IP externa\"}" %DiscordWebHook%

powershell.exe -Command "(Invoke-WebRequest -Uri 'https://www.showmyip.com/' | Select-String -Pattern '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' -AllMatches).Matches.Value" > tempip.txt

:: Leer la dirección IP externa del archivo temporal
SET /P EXTERNALIP=<tempip.txt

:: Verificar si se pudo obtener la dirección IP externa
IF "%EXTERNALIP%"=="" (
	FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
	FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)
	curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] No se pudo obtener la direccion IP externa.\"}" %DiscordWebHook%
    ECHO No se pudo obtener la dirección IP externa. Verifique la conexión a Internet y vuelva a intentarlo.
    TIMEOUT 10
    GOTO FINALIZAR
)

SET SERVERNAME=%EXTERNALIP%

:START
CLS

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Consultando servidor %SERVERNAME%:%QUERYPORT%\"}" %DiscordWebHook% > curloutput.txt

powershell.exe -Command (new-object System.Net.WebClient).DownloadString('http://dayzsalauncher.com/api/v1/query/%SERVERNAME%/%QUERYPORT%') > dzoutput.txt

ECHO Servidor consultado: %SERVERNAME%:%QUERYPORT%

SET /p DZJSON=<dzoutput.txt
CALL SET "DZSTATUS=%%DZJSON:~10,1%%"

ECHO %DZJSON%
ECHO %DZSTATUS%

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%a%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] DAYZSALAUNCHER OUTPUT STATUS: %DZSTATUS% (0=OK 1=ERR) \"}" %DiscordWebHook% > curloutput.txt

:proxActualizacion
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Esperando %SEGUNDOS% segundos...\"}" %DiscordWebHook% > curloutput.txt

ECHO Esperando %SEGUNDOS% segundos...
TIMEOUT %SEGUNDOS%
GOTO START

:FINALIZAR
DEL dzoutput.txt
DEL tempip.txt
DEL curloutput.txt
