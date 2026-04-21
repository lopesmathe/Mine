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
echo [GIT] Servidor desligado. Iniciando captura de log...

:: Limpa o log antigo se existir
if exist log_erro.txt del log_erro.txt

echo --- INICIO DO LOG %date% %time% --- > log_erro.txt

echo [1/3] Adicionando arquivos...
git add . >> log_erro.txt 2>&1

echo [2/3] Criando commit...
git commit -m "Backup_Automatico_%date:/=-%" >> log_erro.txt 2>&1

echo [3/3] Tentando Push (Isso pode demorar)...
git push origin main >> log_erro.txt 2>&1

echo.
echo ==========================================
echo   VERIFICACAO DE ENVIO
echo ==========================================
if %ERRORLEVEL% NEQ 0 (
    echo [ALERTA] O Git falhou! Abrindo log de erros...
    start notepad log_erro.txt
) else (
    echo [OK] Tudo foi salvo no GitHub com sucesso!
)

echo.
echo Pressione qualquer tecla para fechar.
pause >nul