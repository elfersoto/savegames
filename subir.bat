@echo off
rem Hace commit de TODO lo que hay en esta carpeta y lo sube a GitHub (origin/main).
setlocal enabledelayedexpansion
cd /d "%~dp0"
git add -A
git diff --cached --quiet
if %errorlevel%==0 (
    echo No hay cambios que subir.
) else (
    for /f "tokens=*" %%d in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set FECHA=%%d
    git commit -q -m "Guardado manual !FECHA!"
    if errorlevel 1 (
        echo ERROR al hacer commit.
        exit /b 1
    )
)
git push origin main
if errorlevel 1 (
    echo.
    echo ERROR al subir. Si el remoto tiene cambios nuevos, ejecuta bajar.bat antes o revisa el conflicto.
    exit /b 1
)
echo Listo.
