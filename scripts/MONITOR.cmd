:: SCRIPT PARA MONITOREAR LOS SERVICIOS
:: AUTOR: guxlar
:: ACTUALIZACION: 12:02 25/5/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: 
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: ESPERAENSEGUNDOS = tiempo en segundos entre cada medicion
:: DISCORDWEBHOOK = enlace al webhook del Discord donde se muestran los mensajes
:: 
SET ESPERAENSEGUNDOS=60
SET DISCORDWEBHOOK=https://discord.com/api/webhooks/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
::
:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] INICIANDO SCRIPT\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] INICIANDO SCRIPT

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Script: %~nx0\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Script: %~nx0

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Servidor: %COMPUTERNAME%\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Servidor: %COMPUTERNAME%

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Usuario: %USERNAME%\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Usuario: %USERNAME%

:: MONITOREO EL ESTADO DEL SERVIDOR
:checkServer
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

:: 1 - Reviso cual es la actual IP del servidor
powershell.exe -Command "(Invoke-WebRequest -Uri 'https://www.showmyip.com/' | Select-String -Pattern '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' -AllMatches).Matches.Value" > monitor-ip.txt

SET /P EXTERNALIP=<monitor-ip.txt
CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] SERVER IP: %EXTERNALIP%\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] SERVER IP: %EXTERNALIP%

:: 1 - Veo si dayzserver_x64.exe esta funcionando
ECHO [%mydate% %mytime% - %~nx0] Monitoreando: dayzserver_x64.exe
 
TASKLIST | find /i "dayzserver_x64.exe" && CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ON: dayzserver_x64.exe\"}" %DISCORDWEBHOOK% >NUL
TASKLIST | find /i "dayzserver_x64.exe" || CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ***OFF: dayzserver_x64.exe\"}" %DISCORDWEBHOOK% >NUL

:: 2- Veo si BEC.EXE esta funcionando
ECHO [%mydate% %mytime% - %~nx0] Monitoreando: bec.exe

TASKLIST | find /i "bec.exe" && CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ON: bec.exe\"}" %DISCORDWEBHOOK% >NUL
TASKLIST | find /i "bec.exe" || CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ***OFF: bec.exe\"}" %DISCORDWEBHOOK% >NUL

:: Espero unos segundos y vuelvo a probar
CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Proximo check en %ESPERAENSEGUNDOS% segundos...\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Proximo check en %ESPERAENSEGUNDOS% segundos...

TIMEOUT %ESPERAENSEGUNDOS%
GOTO checkServer
