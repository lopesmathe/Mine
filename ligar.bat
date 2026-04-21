@echo off
setlocal enabledelayedexpansion

echo [GIT] Buscando novidades do mundo no GitHub...
git pull

echo.
echo ==========================================
echo   QUEM ESTA LIGANDO O SERVIDOR?
echo ==========================================
echo [1] Matheus (PC BOM - 6GB RAM)
echo [2] Paulo (PC FRACO - 2GB RAM)
set /p escolha="Escolha (1 ou 2): "

if "%escolha%"=="1" (
    set RAM=6G
    set VIEW=12
    echo [CONFIG] Modo Alta Performance selecionado.
) else (
    set RAM=2G
    set VIEW=6
    echo [CONFIG] Modo Economico selecionado.
)

:: Ajusta o server.properties automaticamente antes de ligar
findstr /v "view-distance" server.properties > server.properties.tmp
echo view-distance=%VIEW% >> server.properties.tmp
move /y server.properties.tmp server.properties >nul

echo.
echo [SERVER] Iniciando com %RAM%...
java -Xmx%RAM% -Xms%RAM% -jar server.jar nogui

echo.
echo [GIT] Servidor desligado. Salvando progresso no GitHub...
git add .
git commit -m "Sincronia automatica: Host foi %RAM% em %date%"
git push

echo.
echo [OK] Tudo salvo! Ja pode fechar.
pause