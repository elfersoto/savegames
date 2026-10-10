@echo off
rem Sube a GitHub los savegames (*.sav) de todos los juegos listados en saves.txt.
setlocal enabledelayedexpansion
cd /d "%~dp0"
set "PATHS="

for /f "usebackq eol=# tokens=1,* delims=|" %%A in ("saves.txt") do (
    call set "LOCALDIR=%%B"
    if exist "!LOCALDIR!" (
        echo [%%A] copiando desde !LOCALDIR!
        robocopy "!LOCALDIR!" "%~dp0%%A" *.sav /E /NFL /NDL /NJH /NJS /NP
        if errorlevel 8 (
            echo ERROR al copiar %%A al repo.
            exit /b 1
        )
        set "PATHS=!PATHS! "%%A""
    ) else (
        echo [%%A] AVISO: no existe !LOCALDIR!, se omite.
    )
)

if not defined PATHS (
    echo No hay ninguna carpeta de saves que subir.
    exit /b 1
)

git add -- !PATHS!
git diff --cached --quiet -- !PATHS!
if %errorlevel%==0 (
    echo No hay cambios en los savegames.
) else (
    for /f "tokens=*" %%d in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set FECHA=%%d
    git commit -q -m "Savegames !FECHA! (%COMPUTERNAME%)" -- !PATHS!
    if errorlevel 1 (
        echo ERROR al hacer commit.
        exit /b 1
    )
)

rem Primero se intenta subir directamente (una sola conexion, una sola passphrase).
rem Solo si el remoto tiene cambios nuevos se integra con pull --rebase y se reintenta.
git push origin main
if errorlevel 1 (
    echo.
    echo El remoto tiene cambios nuevos, integrando...
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
)
echo Listo. Savegames subidos.
