:: SCRIPT PARA ACTUALIZAR MODS DEL SERVIDOR
:: AUTOR: guxlar
:: ACTUALIZACION: 00:55 28/7/2024

@ECHO OFF

:::::::::::: CONFIGURACION - MODIFICAR A GUSTO ::::::::::::

:: serverFolder = carpeta donde ya está instalado el servidor DayZ
SET serverFolder=G:\SERVER\SERVER_DEERISLE126

:: modList = ruta al archivo de texto con la lista de mods a descargar
SET modList=G:\server-herramientas\deerislemods.txt

:: steamCmdFolder = carpeta donde está instalado el programa steamcmd.exe
SET steamCmdFolder=G:\STEAMcmd

:: downloadFolder = carpeta donde descargar los mods
SET downloadFolder=G:\DOWNLOADED-mods

:: logFileName = nombre para el log del proceso
SET logFileName=G:\DOWNLOADED-mods\LOG-actualizar-mods


:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
ECHO ***SCRIPT PARA INSTALAR/ACTUALIZAR MODS
ECHO ***Se necesita conectar a Steam con usuario y password
ECHO ***(o poner usuario anonymous y la password vacia)
SET /p steamLoginName=Nombre de usuario de Steam?:
SET /p steamPassword=Password de usuario de Steam?:
CLS

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c-%%b-%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a%%b)

SET logFile=%logFileName%_%mydate%_%mytime%.log
ECHO [INFO]%logFile% > %logFile%
ECHO %mydate%_%mytime% >> %logFile%

IF NOT EXIST %downloadFolder% MKDIR %downloadFolder%

ECHO ***Configuracion del script
ECHO Lista de mods a descargar: %modList%
ECHO Carpeta del steamcmd.exe: %steamCmdFolder%
ECHO Carpeta donde descargar mods: %downloadFolder%
ECHO Carpeta del servidor DayZ: %serverFolder%
ECHO logFile=%logFile%
ECHO ***LA LISTA DE MODS ES:
TYPE %modList%
ECHO ***
SET /P AREYOUSURE=Empezar (S/[N])?
IF /I "%AREYOUSURE%" NEQ "S" GOTO END

ECHO [INFO]modList=%modList% >> %logFile%
ECHO [INFO]steamCmdFolder=%steamCmdFolder% >> %logFile%
ECHO [INFO]downloadFolder=%downloadFolder% >> %logFile%
ECHO [INFO]serverFolder=%serverFolder% >> %logFile%
ECHO [INFO]logFile=%logFile% >> %logFile%

:: PARTE 1 - DESCARGAR LOS MODS DESDE STEAM
ECHO [INFO]PARTE 1 - DESCARGAR LOS MODS DESDE STEAM >> %logFile%
ECHO [INFO]PARTE 1 - DESCARGAR LOS MODS DESDE STEAM

ECHO [INFO]Descargando los mods de la lista %modList% ... >> %logFile%
ECHO [INFO]Descargando los mods de la lista %modList% ...
ECHO [INFO]Carpeta de descarga:  %downloadFolder%_%mydate%_%mytime% >> %logFile%
ECHO [INFO]Carpeta de descarga:  %downloadFolder%_%mydate%_%mytime%

SETLOCAL enabledelayedexpansion
FOR /F "tokens=1,2 delims=," %%G IN ('type %modList%') DO (
	CLS
	
	ECHO [INFO]Descargando mod: %%G %%H
	ECHO [INFO]Descargando mod: %%G %%H >> %logFile%
	ECHO [INFO]Ejecutando %steamCmdFolder%\steamcmd.exe >> %logFile%
	ECHO [INFO]Ejecutando %steamCmdFolder%\steamcmd.exe
	
	@ECHO ON 
	%steamCmdFolder%\steamcmd.exe +force_install_dir %downloadFolder%\mods_%mydate%_%mytime% +login %steamLoginName% %steamPassword% +workshop_download_item 221100 %%G validate +quit
	@ECHO OFF 
	
	
)

ECHO [INFO]FIN PARTE 1 - DESCARGAR LOS MODS DESDE STEAM >> %logFile%
ECHO [INFO]FIN PARTE 1 - DESCARGAR LOS MODS DESDE STEAM

:: PARTE 2 - RENOMBRAR FOLDERS NUMERICOS A @NOMBRE-DE-MOD
ECHO [INFO]PARTE 2 - RENOMBRAR FOLDERS NUMERICOS A @NOMBRE-DE-MOD >> %logFile%
ECHO [INFO]PARTE 2 - RENOMBRAR FOLDERS NUMERICOS A @NOMBRE-DE-MOD

ECHO [INFO]Renombrando mods descargados en %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\ >> %logFile%
ECHO [INFO]Renombrando mods descargados en %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\

SETLOCAL enabledelayedexpansion
FOR /F "tokens=1,2 delims=," %%G IN ('type %modList%') DO (
	CLS

	ECHO [INFO]Renombrando mod: %%G %%H
	ECHO [INFO]Renombrando mod: %%G %%H >> %logFile%
	
	RENAME %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\%%G "%%H"
	
	IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]rename >> %logFile%)
	RENAME "%serverFolder%\%%H" "%%H_%mydate%_%mytime%"
)
ECHO [INFO]FIN PARTE 2 - RENOMBRAR FOLDERS NUMERICOS A @NOMBRE-DE-MOD >> %logFile%
ECHO [INFO]FIN PARTE 2 - RENOMBRAR FOLDERS NUMERICOS A @NOMBRE-DE-MOD

:: PARTE 3 - COPIAR LOS MODS Y SUS KEYS AL SERVIDOR
ECHO [INFO]PARTE 3 - COPIAR LOS MODS Y SUS KEYS AL SERVIDOR >> %logFile%
ECHO [INFO]PARTE 3 - COPIAR LOS MODS Y SUS KEYS AL SERVIDOR

ECHO [INFO]Copiando todos los mods al servidor: %serverFolder% >> %logFile%
ECHO [INFO]Los mods descargados estan en: %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100 >> %logFile%
ECHO [INFO]Copiando todos los mods al servidor: %serverFolder%
ECHO [INFO]Los mods descargados estan en: %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100

ECHO [INFO]xcopy mods >> %logFile%
ECHO [INFO]xcopy mods

XCOPY /s /e /y /j /q %downloadFolder%\mods_%mydate%_%mytime%\steamapps\workshop\content\221100\ %serverFolder%

IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy mods >> %logFile%)

ECHO [INFO]Instalando las keys en el servidor: %serverFolder%\keys
ECHO [INFO]Instalando las keys en el servidor: %serverFolder%\keys >> %logFile%

ECHO [INFO]xcopy keys >> %logFile%
ECHO [INFO]xcopy keys
FOR /F "tokens=1,2 delims=," %%G IN (%modList%) DO (
	ECHO [INFO]Instalando keys de mod: %%G %%H
	ECHO [INFO]Instalando keys de mod: %%G %%H >> %logFile%
	
	XCOPY /s /e /y /j /q "%serverFolder%\%%H\keys" %serverFolder%\keys
	
	IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy keys >> %logFile%)
)
ECHO [INFO]FIN PARTE 3 - COPIAR LOS MODS Y SUS KEYS AL SERVIDOR >> %logFile%
ECHO [INFO]FIN PARTE 3 - COPIAR LOS MODS Y SUS KEYS AL SERVIDOR

:: FINAL DE TODO

ECHO [INFO]Proceso finalizado - mods instalados:
ECHO [INFO]Proceso finalizado - mods instalados: >> %logFile%
FOR /F "tokens=1,2 delims=," %%G IN (%modList%) DO (
	ECHO %%H; 
	ECHO %%H; >> %logFile%
)

ECHO [END]%logFile% >> %logFile%

:END
ECHO ***FIN DEL SCRIPT
PAUSE
