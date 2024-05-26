:: SCRIPT PARA ACTUALIZAR MODS DEL SERVIDOR
:: AUTOR: guxlar
:: ACTUALIZACION: 14:08 26/5/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: 
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: modList = ruta al archivo de texto con la lista de mods a descargar
SET modList=C:\DOWNLOADED-mods\sample-modlist.txt

:: steamCmdFolder = carpeta donde está instalado el programa steamcmd.exe
SET steamCmdFolder=C:\SteamCmd

:: downloadFolder = carpeta donde descargar los mods
SET downloadFolder=C:\DOWNLOADED-mods

:: serverFolder = carpeta donde ya está instalado el servidor DayZ
SET serverFolder=C:\server\SERVER_VALNING

:: logFileName = nombre para el log del proceso
SET logFileName=C:\DOWNLOADED-mods\LOG-actualizar-mods


:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
ECHO ***SCRIPT PARA INSTALAR/ACTUALIZAR MODS EN UN SERVIDOR DAYZ
ECHO ***Se necesita conectar a Steam con usuario y password
SET /p steamLoginName=Nombre de usuario de Steam?:
SET /p steamPassword=Password de usuario de Steam?:

CLS

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c-%%b-%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a%%b)

SET logFile=%logFileName%_%mydate%_%mytime%.log

IF NOT EXIST %downloadFolder% MKDIR %downloadFolder%

ECHO ***Configuracion del script
ECHO Ruta al archivo con la lista de mods a descargar: %modList%
ECHO Carpeta donde ya esta instalado steamcmd.exe: %steamCmdFolder%
ECHO Carpeta de trabajo para descargar mods: %downloadFolder%
ECHO Carpeta donde ya esta instalado el servidor DayZ: %serverFolder%
ECHO logFile=%logFile%
ECHO ***
SET /P AREYOUSURE=Ejecutar (S/[N])?
IF /I "%AREYOUSURE%" NEQ "S" GOTO END

ECHO [INFO]logFile% > %logFile%
date /t >> %logFile%
time /t >> %logFile%

ECHO [INFO]modList=%modList% >> %logFile%
ECHO [INFO]steamCmdFolder=%steamCmdFolder% >> %logFile%
ECHO [INFO]downloadFolder=%downloadFolder% >> %logFile%
ECHO [INFO]serverFolder=%serverFolder% >> %logFile%
ECHO [INFO]logFile=%logFile% >> %logFile%

:: PARTE 1 - DESCARGAR LOS MODS DESDE STEAM
ECHO [INFO]Descargando los mods de la lista %modList% ... >> %logFile%
ECHO [INFO]Carpeta de descarga:  %downloadFolder%_%mydate%_%mytime% >> %logFile%
FOR /F "tokens=1,2 delims=," %%G IN (%modList%) DO (
	ECHO [INFO]Descargando mod: %%G %%H >> %logFile%
	%steamCmdFolder%\steamcmd.exe +force_install_dir %downloadFolder%\mods_%mydate%_%mytime% +login %steamLoginName% %steamPassword% +workshop_download_item 221100 %%G validate +quit
)

:: PARTE 2 - RENOMBRAR FOLDERS NUMERICOS A @NOMBRE-DE-MOD

ECHO [INFO]Renombrando mods descargados en %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\ >> %logFile%
FOR /F "tokens=1,2 delims=," %%G IN (%modList%) DO (
	ECHO [INFO]Renombrando mod: %%G %%H >> %logFile%
	RENAME %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\%%G "%%H"
	IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]rename >> %logFile%)
)

:: PARTE 3 - COPIAR LOS MODS Y SUS KEYS AL SERVIDOR

ECHO [INFO]Copiando todos los mods al servidor: %serverFolder% >> %logFile%
ECHO [INFO]Los mods descargados estan en: %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100 >> %logFile%

XCOPY /s /e /y /j /q %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\ %serverFolder%
IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy mod >> %logFile%)

ECHO [INFO]Instalando las keys en el servidor: %serverFolder%\keys >> %logFile%
FOR /F "tokens=1,2 delims=," %%G IN (%modList%) DO (
	ECHO [INFO]Instalando keys de mod: %%G %%H >> %logFile%
	XCOPY /s /e /y /j /q "%serverFolder%\%%H\keys" %serverFolder%\keys
	IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy key >> %logFile%)
)

:: FINAL DE TODO

ECHO [INFO]Proceso finalizado - mods instalados: >> %logFile%
FOR /F "tokens=1,2 delims=," %%G IN (%modList%) DO (
	ECHO %%H; >> %logFile%
)

ECHO [END]%logFile% >> %logFile%
date /t >> %logFile%
time /t >> %logFile%

:END
ECHO ***FIN DEL SCRIPT
PAUSE
