@echo off
rem Hace commit de los cambios en Epic y Steam y los sube a GitHub (origin/main).
cd /d "%~dp0"
git add -A Epic Steam subir.bat bajar.bat
git diff --cached --quiet
if %errorlevel%==0 (
    echo No hay cambios que subir.
) else (
    for /f "tokens=*" %%d in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set FECHA=%%d
    git commit -q -m "Guardado automatico %FECHA%"
)
git push origin main
if errorlevel 1 (
    echo.
    echo ERROR al subir. Si el remoto tiene cambios nuevos, ejecuta bajar.bat antes o revisa el conflicto.
    exit /b 1
)
echo Listo.
