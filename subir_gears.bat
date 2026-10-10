@echo off
rem Sube los savegames de Gears of War E-Day (.sav) a GitHub.
rem Origen: %LOCALAPPDATA%\Microsoft\Gears of War E-Day\Saves  ->  Repo: GearsOfWarEDay\Saves
setlocal enabledelayedexpansion
cd /d "%~dp0"
set "LOCALSAVES=%LOCALAPPDATA%\Microsoft\Gears of War E-Day\Saves"
set "REPOSAVES=%~dp0GearsOfWarEDay\Saves"

if not exist "%LOCALSAVES%" (
    echo ERROR: no existe la carpeta de saves: %LOCALSAVES%
    exit /b 1
)

robocopy "%LOCALSAVES%" "%REPOSAVES%" *.sav /E /NFL /NDL /NJH /NJS /NP
if errorlevel 8 (
    echo ERROR al copiar los saves al repo.
    exit /b 1
)

git add -- GearsOfWarEDay
git diff --cached --quiet -- GearsOfWarEDay
if %errorlevel%==0 (
    echo No hay cambios en los savegames.
) else (
    for /f "tokens=*" %%d in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set FECHA=%%d
    git commit -q -m "Gears of War E-Day saves !FECHA! (%COMPUTERNAME%)" -- GearsOfWarEDay
    if errorlevel 1 (
        echo ERROR al hacer commit.
        exit /b 1
    )
)

git pull --rebase --autostash origin main
if errorlevel 1 (
    echo ERROR al integrar cambios del remoto. Resuelve el conflicto o ejecuta: git rebase --abort
    exit /b 1
)
git push origin main
if errorlevel 1 (
    echo ERROR al subir.
    exit /b 1
)
echo Listo. Savegames subidos.
