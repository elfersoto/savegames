@echo off
rem Descarga el remoto y SOBRESCRIBE los archivos rastreados (los cambios locales en ellos se pierden). No borra archivos nuevos sin rastrear.
cd /d "%~dp0"
git fetch origin main
if errorlevel 1 (
    echo ERROR al descargar del remoto.
    exit /b 1
)
git reset --hard origin/main
echo Listo. Los archivos rastreados ahora son identicos al remoto.
