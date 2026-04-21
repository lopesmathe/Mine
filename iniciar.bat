@echo off
setlocal enabledelayedexpansion

:: Pega o nome do próprio arquivo .bat para não se deletar
set SCRIPT_NAME=%~nx0

:INICIO
cls
echo ##########################################
echo #       MINECRAFT SERVER SYNC v2.2       #
echo #   Status: Matheus ^<--^> Paulo (GIT)    #
echo ##########################################
echo.

echo [GIT] Sincronizando com a Nuvem...
git fetch origin main >nul 2>&1

echo [GIT] Limpando arquivos temporarios...
:: O reset apenas volta os arquivos que já existem para a versão do GitHub
git reset --hard origin/main >nul 2>&1

:: O clean agora ignora o próprio script para não se deletar
git clean -fd -e "%SCRIPT_NAME%" >nul 2>&1

echo.
echo [OK] Sistema pronto e protegido.
echo ------------------------------------------
echo.

echo ==========================================
echo    QUEM ESTA LIGANDO O SERVIDOR?
echo ==========================================
echo [1] Matheus (PC BOM - 6GB RAM)
echo [2] Paulo (PC FRACO - 2GB RAM)
set /p escolha="Escolha (1 ou 2): "

if "%escolha%"=="1" (
    set RAM=6G
    set VIEW=12
) else (
    set RAM=2G
    set VIEW=6
)

:: Ajusta o server.properties
findstr /v "view-distance" server.properties > server.properties.tmp
echo view-distance=%VIEW% >> server.properties.tmp
move /y server.properties.tmp server.properties >nul

echo.
echo [SERVER] Iniciando Minecraft com %RAM%...
java -Xmx%RAM% -Xms%RAM% -jar server.jar nogui

echo.
echo [GIT] Servidor desligado. Salvando...

if exist log_erro.txt del log_erro.txt
echo --- INICIO DO LOG %date% %time% --- > log_erro.txt

echo [1/3] Preparando arquivos...
git add . >> log_erro.txt 2>&1

echo [2/3] Registrando progresso...
git commit -m "Backup_v2.2_%date:/=-%_%time::=-%" >> log_erro.txt 2>&1

echo [3/3] Enviando para nuvem...
git push origin main >> log_erro.txt 2>&1

echo.
echo ==========================================
echo    RESULTADO DO SINCRONISMO
echo ==========================================
if %ERRORLEVEL% NEQ 0 (
    echo [ALERTA] O envio falhou! 
    start notepad log_erro.txt
) else (
    echo [SUCESSO] Mundo enviado ao GitHub!
)

echo.
echo Pressione qualquer tecla para encerrar.
pause >nul
exit