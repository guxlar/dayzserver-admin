:: SCRIPT PARA DESCARGAR SERVIDOR DAYZ
:: AUTOR: guxlar
:: ACTUALIZACION: 2024-04-14 15:44:03

@echo off
:: 
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: steamCmdFolder = carpeta donde está instalado el programa steamcmd.exe
SET steamCmdFolder=C:\SteamCmd

:: downloadFolder = carpeta donde descargar el server
SET downloadFolder="C:\DOWNLOADED-serverdayz"

:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
ECHO ***SCRIPT PARA DESCARGAR EL SERVIDOR DAYZ DE STEAM
ECHO ***Se necesita conectar a Steam con usuario y password
SET /p steamLoginName=Nombre de usuario de Steam?:
SET /p steamPassword=Password de usuario de Steam?:

IF NOT EXIST %downloadFolder% MKDIR %downloadFolder%

ECHO ***Configuracion del script
ECHO Carpeta donde ya esta instalado steamcmd.exe: %steamCmdFolder%
ECHO Carpeta de trabajo donde descargar: %downloadFolder%
ECHO ***
SET /P AREYOUSURE=Ejecutar (S/[N])?
IF /I "%AREYOUSURE%" NEQ "S" GOTO END

:: ANOTAR LA FECHA/HORA DEL PROCESO
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c-%%a-%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a%%b)

:: DESCARGAR DAYZ SERVER DE STEAM
%steamCmdFolder%\steamcmd.exe +force_install_dir %downloadFolder%\dayzserver_%mydate%_%mytime%  +login %steamLoginName% %steamPassword% +app_update 223350 validate +quit

rename %downloadFolder%\dayzserver_%mydate%_%mytime%\whitelist.txt whitelist.txt.%mydate%_%mytime%
rename %downloadFolder%\dayzserver_%mydate%_%mytime%\serverDZ.cfg serverDZ.cfg.%mydate%_%mytime%
rename %downloadFolder%\dayzserver_%mydate%_%mytime%\ban.txt ban.txt.%mydate%_%mytime%
rename %downloadFolder%\dayzserver_%mydate%_%mytime%\mpmissions\dayzOffline.enoch dayzOffline.enoch.%mydate%_%mytime%
rename %downloadFolder%\dayzserver_%mydate%_%mytime%\mpmissions\dayzOffline.chernarusplus dayzOffline.chernarusplus.%mydate%_%mytime%

:END
ECHO ***FIN DEL SCRIPT
PAUSE
