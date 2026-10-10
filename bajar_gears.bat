@echo off
rem Baja los savegames de Gears of War E-Day desde GitHub y los copia a la carpeta del juego.
rem Antes de sobrescribir, guarda una copia de los saves locales en Saves_backup\<fecha>.
setlocal enabledelayedexpansion
cd /d "%~dp0"
set "GAMEDIR=%LOCALAPPDATA%\Microsoft\Gears of War E-Day"
set "LOCALSAVES=%GAMEDIR%\Saves"
set "REPOSAVES=%~dp0GearsOfWarEDay\Saves"

git pull --rebase --autostash origin main
if errorlevel 1 (
    echo ERROR al descargar del remoto.
    exit /b 1
)

if not exist "%REPOSAVES%" (
    echo No hay savegames en el repo todavia. Ejecuta primero subir_gears.bat en la otra maquina.
    exit /b 1
)

if exist "%LOCALSAVES%" (
    for /f "tokens=*" %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set FECHA=%%d
    robocopy "%LOCALSAVES%" "%GAMEDIR%\Saves_backup\!FECHA!" *.sav /E /NFL /NDL /NJH /NJS /NP
    if errorlevel 8 (
        echo ERROR al hacer la copia de seguridad. No se sobrescribe nada.
        exit /b 1
    )
    echo Copia de seguridad en: %GAMEDIR%\Saves_backup\!FECHA!
)

robocopy "%REPOSAVES%" "%LOCALSAVES%" *.sav /E /NFL /NDL /NJH /NJS /NP
if errorlevel 8 (
    echo ERROR al copiar los saves.
    exit /b 1
)
echo Listo. Savegames actualizados.
