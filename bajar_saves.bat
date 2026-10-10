@echo off
rem Baja de GitHub los savegames (*.sav) de todos los juegos listados en saves.txt y los copia a su carpeta local.
rem Antes de sobrescribir, guarda una copia de los saves locales en %LOCALAPPDATA%\SavesBackup\<fecha>\<juego>.
setlocal enabledelayedexpansion
cd /d "%~dp0"

git pull --rebase --autostash origin main
if errorlevel 1 (
    echo ERROR al descargar del remoto.
    exit /b 1
)

for /f "tokens=*" %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set FECHA=%%d

for /f "usebackq eol=# tokens=1,* delims=|" %%A in ("saves.txt") do (
    call set "LOCALDIR=%%B"
    if not exist "%~dp0%%A" (
        echo [%%A] AVISO: no hay saves en el repo todavia, se omite.
    ) else (
        if exist "!LOCALDIR!" (
            robocopy "!LOCALDIR!" "%LOCALAPPDATA%\SavesBackup\!FECHA!\%%A" *.sav /E /NFL /NDL /NJH /NJS /NP
            if errorlevel 8 (
                echo ERROR al hacer la copia de seguridad de %%A. No se sobrescribe.
                exit /b 1
            )
            echo [%%A] copia de seguridad en %LOCALAPPDATA%\SavesBackup\!FECHA!\%%A
        )
        robocopy "%~dp0%%A" "!LOCALDIR!" *.sav /E /NFL /NDL /NJH /NJS /NP
        if errorlevel 8 (
            echo ERROR al copiar %%A.
            exit /b 1
        )
        echo [%%A] actualizado en !LOCALDIR!
    )
)
echo Listo. Savegames actualizados.
