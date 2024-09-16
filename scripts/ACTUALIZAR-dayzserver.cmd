:: SCRIPT PARA DESCARGAR SERVIDOR DAYZ
:: AUTOR: guxlar
:: ACTUALIZACION: 08:45 4/7/2024

@echo off

:: CONFIGURACION - MODIFICAR A GUSTO

:: steamCmdFolder = carpeta donde está instalado el programa steamcmd.exe
SET steamCmdFolder=G:\SteamCmd

:: downloadFolder = carpeta donde descargar el server
SET downloadFolder=G:\DOWNLOADED-dayzserver

:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
ECHO ***SCRIPT PARA DESCARGAR EL SERVIDOR DAYZ DE STEAM
ECHO ***Se necesita conectar a Steam con un usuario y password que haya comprado DayZ !
SET /p steamLoginName=Nombre de usuario de Steam?:
SET /p steamPassword=Password de usuario de Steam?:

CLS

IF NOT EXIST %downloadFolder% MKDIR %downloadFolder%

ECHO ***CONFIGURACION DEL SCRIPT:
ECHO Carpeta donde ya esta instalado steamcmd.exe: %steamCmdFolder%
ECHO Carpeta donde guardar el Dayz Server: %downloadFolder%
ECHO ***
SET /P AREYOUSURE=Ejecutar (S/[N])?
IF "%AREYOUSURE%" NEQ "S" GOTO END

:: ANOTAR LA FECHA/HORA DEL PROCESO
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c-%%a-%%b)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a%%b)

:: DESCARGAR DAYZ SERVER DE STEAM
%steamCmdFolder%\steamcmd.exe +force_install_dir %downloadFolder%\dayzserver_%mydate%_%mytime%  +login %steamLoginName% %steamPassword% +app_update 223350 validate +quit

:: Limpieza
DEL /Q %downloadFolder%\dayzserver_%mydate%_%mytime%\whitelist.txt
DEL /Q %downloadFolder%\dayzserver_%mydate%_%mytime%\serverDZ.cfg
DEL /Q %downloadFolder%\dayzserver_%mydate%_%mytime%\ban.txt
RMDIR /S /Q %downloadFolder%\dayzserver_%mydate%_%mytime%\mpmissions

:END
ECHO ***
ECHO ***DAYZ SERVER DESCARGADO EN LA CARPETA:
ECHO %downloadFolder%\dayzserver_%mydate%_%mytime%
ECHO ***FIN DEL SCRIPT
PAUSE
