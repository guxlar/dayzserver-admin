:: SCRIPT PARA MONITOREAR LOS SERVICIOS
:: AUTOR: guxlar
:: ACTUALIZACION: 12:02 25/5/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: 
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: DISCORDWEBHOOK = enlace al webhook del Discord donde se muestran los mensajes
:: 
SET DISCORDWEBHOOK=https://discord.com/api/webhooks/1285019768037969980/kbFi6VMEfOc5PyhLcCddgUZ0RD5neVC9SkQEnKwblba1rqYcoBE8qdxiTnDFApII1oRL
::
:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

:checkServer
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a%%b)

:: 1 - Obtengo la actual IP del servidor
powershell.exe -Command "(Invoke-WebRequest -Uri 'https://www.showmyip.com/' | Select-String -Pattern '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' -AllMatches).Matches.Value" > %~nx0.txt

SET /P EXTERNALIP=<%~nx0.txt

:: 1 - Veo si dayzserver_x64.exe esta funcionando
TASKLIST | find /i "dayzserver_x64.exe" && CURL -k -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% %~nx0] ON: dayzserver_x64.exe - %COMPUTERNAME% (%EXTERNALIP%)\"}" %DISCORDWEBHOOK% >NUL
TASKLIST | find /i "dayzserver_x64.exe" || CURL -k -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% %~nx0] ***OFF: dayzserver_x64.exe - %COMPUTERNAME% (%EXTERNALIP%)\"}" %DISCORDWEBHOOK% >NUL

:: 2- Veo si BEC.EXE esta funcionando
TASKLIST | find /i "bec.exe" && CURL -k -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% %~nx0] ON: bec.exe - %COMPUTERNAME% (%EXTERNALIP%)\"}" %DISCORDWEBHOOK% >NUL
TASKLIST | find /i "bec.exe" || CURL -k -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% %~nx0] ***OFF: bec.exe - %COMPUTERNAME% (%EXTERNALIP%)\"}" %DISCORDWEBHOOK% >NUL

:: 3- Veo si ANYDESK.EXE esta funcionando
TASKLIST | find /i "anydesk.exe" && CURL -k -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% %~nx0] ON: anydesk.exe - %COMPUTERNAME% (%EXTERNALIP%)\"}" %DISCORDWEBHOOK% >NUL
TASKLIST | find /i "anydesk.exe" || CURL -k -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% %~nx0] ***OFF: anydesk.exe - %COMPUTERNAME% (%EXTERNALIP%)\"}" %DISCORDWEBHOOK% >NUL

