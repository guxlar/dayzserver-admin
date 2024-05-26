:: SCRIPT PARA BACKUP DEL SERVIDOR
:: AUTOR: guxlar
:: ACTUALIZACION: 2:46 PM 5/10/2024
@ECHO OFF
TITLE %~nx0
COLOR 0A
:: 
:: CONFIGURAR ESTAS VARIABLES SEGUN CORRESPONDA
::
:: CARPETASERVIDOR = Carpeta del servidor a respaldar
:: CARPETABAK = Carpeta donde se guardan los backups
:: CARPETALOG = Carpeta para los logs del proceso
:: LOGFILENAME = Nombre del archivo para el log del proceso
:: SERVERPROFILES = Carpeta de los server profiles
::
SET CARPETASERVIDOR=C:\server\SERVER_VALNING
SET CARPETABAK=C:\server-BACKUPS
SET CARPETALOG=%CARPETABAK%\LOGS
SET LOGFILENAME=%CARPETALOG%\LOG-backup-servidor
SET SERVERPROFILES=SERVER_PROFILES
::
:::::::::::: NO MODIFICAR NADA DE ACA PARA ABAJO ::::::::::::

CLS
FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (set mydate=%%c-%%b-%%a)
FOR /f "tokens=1-2 delims=/:" %%a IN ('time /t') DO (set mytime=%%a)

SET logFile=%LOGFILENAME%_%mydate%_%mytime%.log
IF NOT EXIST "%CARPETALOG%" MKDIR "%CARPETALOG%"

SET backupServer=%CARPETABAK%\BAK_%mydate%_%mytime%
IF NOT EXIST "%backupServer%" MKDIR "%backupServer%"

ECHO ***Configuracion del script
ECHO Servidor a respaldar: %CARPETASERVIDOR%
ECHO Carpeta para el backup: %backupServer%
ECHO Logs del proceso: %CARPETALOG%
ECHO logFile=%logFile%
ECHO ***
ECHO *** EL SERVIDOR DAYZ TIENE QUE ESTAR APAGADO***

:: Activo el log del proceso de backup
ECHO %~nx0 > %logFile%
ECHO logFile% >> %logFile%
date /t >> %logFile%
time /t >> %logFile%
ECHO Servidor: %COMPUTERNAME% >> %logFile%
ECHO Usuario: %USERNAME% >> %logFile%
ECHO [INFO]CARPETASERVIDOR=%CARPETASERVIDOR% >> %logFile%
ECHO [INFO]BACKUPSERVER=%backupServer% >> %logFile%
ECHO [INFO]CARPETALOG=%CARPETALOG% >> %logFile%
ECHO [INFO]logFile=%logFile% >> %logFile%

:: PARTE 1 - COPIAR CONFIGURACION DEL SERVIDOR
ECHO [INFO]xcopy1 archivos de %CARPETASERVIDOR% hacia %backupServer% >> %logFile%
COPY /y "%CARPETASERVIDOR%\*.*" "%backupServer%"
IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy 1 >> %logFile%)

:: PARTE 2 - COPIAR SERVER PROFILES
ECHO [INFO]xcopy2 %CARPETASERVIDOR%\%SERVERPROFILES% hacia %backupServer%\%SERVERPROFILES% >> %logFile%
XCOPY /s /e /y /j /q %CARPETASERVIDOR%\%SERVERPROFILES% %backupServer%\%SERVERPROFILES%\ 
IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy 2 >> %logFile%)

:: PARTE 3 - COPIAR MPMISSIONS
ECHO [INFO]xcopy3 %CARPETASERVIDOR%\mpmissions hacia %backupServer%\mpmissions >> %logFile%
XCOPY /s /e /y /j /q %CARPETASERVIDOR%\mpmissions %backupServer%\mpmissions\
IF %ERRORLEVEL% EQU 0 (ECHO [INFO]OK >> %logFile%) ELSE (ECHO [ERROR]xcopy 3 >> %logFile%)

:END
ECHO [INFO]***FIN DEL SCRIPT*** >> %logFile%
ECHO [INFO]logFile% >> %logFile%
