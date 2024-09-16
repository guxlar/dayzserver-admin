@echo off

:start
cls

::Name for CMD window
set serverName=SERVER_NITRADO
::Server files location
set serverLocation="G:\SERVER\SERVER_NITRADO"
::Server Port
set serverPort=2302
::Server config file
set serverConfig=serverDZ.cfg
::Server profile folder
set serverProfile=CONFIG
::Logical CPU cores to use (Equal or less than available)
set serverCPU=2
::Server instance nro
set serverInstanceId=1
::List of mods (@modName;@anotherModname;@mod)
set mods=@CF;@VPPAdminTools;@Arland;@Dabs Framework;@DayZ Editor Loader;@BuilderItems;@RENACIMIENTO_RopaClanes;@Basic Map;@CZ Zones;@PvZmoD_TheDarkHorde;@RaG_Dragons
::List of server-side mods (@modName;@anotherModname;@mod)
set serverSideMods=
::Sets title for terminal (DONT edit)
title %serverName% batch
::DayZServer location (DONT edit)
cd "%serverLocation%"

echo %time%
echo serverName      : %serverName%
echo serverLocation  : %serverLocation%
echo serverPort      : %serverPort%
echo serverConfig    : %serverConfig%
echo serverProfile   : %serverProfile%
echo serverCPU       : %serverCPU%
echo serverInstanceId: %serverInstanceId%
echo serverSideMods  : %serverSideMods%
echo mods            : %mods%

@echo on

::Launch parameters (edit end: -config=|-port=|-profiles=|-doLogs|-adminLog|-netLog|-freezeCheck|-filePatching|-BEpath=|-cpuCount=)
start "DayZ Server" /min "DayZServer_x64.exe" -instanceid=%serverInstanceId% -port=%serverPort% -config=%serverConfig% -profiles=%serverProfile% -cpuCount=%serverCPU% -nologs -freezecheck "-mod=%mods%" "-servermod=%serverSideMods%"

pause