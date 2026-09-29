@echo off
rem Descarga el remoto y SOBRESCRIBE lo local en Epic y Steam (cambios y archivos nuevos locales se pierden).
cd /d "%~dp0"
git fetch origin main
if errorlevel 1 (
    echo ERROR al descargar del remoto.
    exit /b 1
)
git reset --hard origin/main
git clean -fd -- Epic Steam
echo Listo. Epic y Steam ahora son identicos al remoto.
