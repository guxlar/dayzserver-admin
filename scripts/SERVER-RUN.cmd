:: SCRIPT PARA INICIAR SERVIDOR DAYZ
:: AUTOR: guxlar
:: ACTUALIZACION: 10:03 15/5/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: 
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
SET DAYZSRVPATH="C:\server\SERVER_VALNING"
SET BECPATH="C:\server\SERVER_VALNING\BEC"
SET SEGUNDOSTIMEOUT=300
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

:checkDayz
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

tasklist /fi "imagename eq DayZServer_x64.exe" 2>NUL | find /i /n "DayZServer_x64.exe">NUL
if "%ERRORLEVEL%"=="0" GOTO checkBEC

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ***NO ESTA EJECUTANDO: DayZServer_x64.exe\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] ***NO ESTA EJECUTANDO: DayZServer_x64.exe

GOTO killServer

:checkBEC
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

tasklist /fi "imagename eq BEC.exe" 2>NUL | find /i /n "BEC.exe">NUL
if "%ERRORLEVEL%"=="0" GOTO loopServer

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ***NO ESTA EJECUTANDO: BEC.exe\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] ***NO ESTA EJECUTANDO: BEC.exe

GOTO startBEC

:loopServer
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] OK SERVICIOS - Proximo check en %SEGUNDOSTIMEOUT% segundos...\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] OK SERVICIOS - Proximo check en %SEGUNDOSTIMEOUT% segundos...

TIMEOUT %SEGUNDOSTIMEOUT%
GOTO checkDayz

:killServer
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Reseteando servicios...\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Reseteando servicios...

taskkill /f /im Bec.exe
taskkill /f /im DayZServer_x64.exe

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] OK servicios reseteados\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] OK servicios reseteados

GOTO backupServer

:backupServer
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Backupeando DayZ...\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Backupeando DayZ...

CALL C:\server-herramientas\BACKUP-servidor.cmd

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Fin de backup\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Fin de backup

GOTO startServer

:startBEC
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Iniciando: BEC.exe\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Iniciando: BEC.exe 

cd "%BECPATH%"

START Bec.exe -f Config.cfg --dsc

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ***OK INICIADO: BEC.exe\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] ***OK INICIADO: BEC.exe

GOTO checkDayz

:startServer
TITLE %~nx0

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c%%b%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a:%%b)

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Iniciando: DayZServer_x64.exe\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Iniciando: DayZServer_x64.exe

cd "%DAYZSRVPATH%"

START DayZServer_x64.exe -port=2302 -dologs -adminlog -netlog -freezecheck -profiles=SERVER_PROFILES -config=SERVER_CONFIG.cfg "-mod=@CF;@Dabs Framework;@Valning Map;@Trader;@BuilderItems;@Valning Traders;@DayZ-Expansion-Core;@DayZ-Expansion;@DayZ-Expansion-Licensed;@DayZ-Expansion-Bundle;@DayZ-Expansion-Animations;@DayZ-Expansion-Vehicles;@VPPAdminTools;@AC-Mod-Pack;@RUSForma_Motorcycles;@BaseBuildingPlus;@RedFalcon Flight System Heliz;@DBN_FordRaptor_Scorpio;@MMG - Mightys Military Gear;@MuchFramework;@MuchStuffPack;@Code Lock;@Helicopter landing pad;@RedFalcon Watercraft;@Breachingcharge;@SNAFU Weapons;@CannabisPlus;@KOTH;@TerrainIslands;@RENACIMIENTO_CustomWatermark;@Paragon Storage;@Paragon Arsenal;@Paragon Gear and Armor;@Portable Houses (codelock version);@DBN_MercedesG65_6x6 FREE;@Volkswagen Golf 7.5 R-Line;@MBM_CanAm;@AggressiveMetabolism"

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] ***OK INICIADO: DayZServer_x64.exe\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] ***OK INICIADO: DayZServer_x64.exe

CURL -s -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST  --data "{\"content\": \"[%mydate% %mytime% - %~nx0] Esperando 1 minuto para iniciar BEC.exe ...\"}" %DISCORDWEBHOOK% >NUL
ECHO [%mydate% %mytime% - %~nx0] Esperando 1 minuto para iniciar BEC.exe ...

TIMEOUT 60

GOTO startBEC