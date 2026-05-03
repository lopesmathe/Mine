@echo off
setlocal enabledelayedexpansion

:: Forca o CMD a trabalhar na pasta correta
cd /d "%~dp0"

:: Nome exato do seu Loader do Fabric
set FABRIC_JAR=fabric-server-mc.26.1.2-loader.0.19.2-launcher.1.1.1.jar

:INICIO
cls
echo ##########################################
echo #       MINECRAFT SERVER SYNC v3.2       #
echo #   Status: Matheus ^<--^> Paulo (GIT)    #
echo ##########################################
echo.

:: DESTRAVA O GIT
if exist ".git\index.lock" (
    powershell -Command "Write-Host '[SISTEMA] Removendo trava de seguranca do Git...' -ForegroundColor Cyan"
    del /f /q ".git\index.lock" >nul 2>&1
)

echo [GIT] Verificando atualizacoes na rede...
git pull origin main >nul 2>&1

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
if exist server.properties (
    findstr /v "view-distance" server.properties > server.properties.tmp
    echo view-distance=%VIEW% >> server.properties.tmp
    move /y server.properties.tmp server.properties >nul
)

echo.
if exist "%FABRIC_JAR%" (
    :: AVISO EM VERDE
    powershell -Command "Write-Host '############################################' -ForegroundColor Green"
    powershell -Command "Write-Host '#      SERVIDOR ESTA SENDO LIGADO...       #' -ForegroundColor Green"
    powershell -Command "Write-Host '#   AGUARDE O MUNDO CARREGAR PARA ENTRAR   #' -ForegroundColor Green"
    powershell -Command "Write-Host '############################################' -ForegroundColor Green"
    echo.
    
    :: Inicia o Servidor
    java -Xmx%RAM% -Xms%RAM% -jar "%FABRIC_JAR%" nogui
) else (
    powershell -Command "Write-Host '[ERRO] Loader do Fabric nao encontrado!' -ForegroundColor Red"
    pause
    exit
)

echo.
:: AVISO EM AMARELO
powershell -Command "Write-Host '[!] Servidor desligado. Iniciando Backup...' -ForegroundColor Yellow"

if exist log_erro.txt del log_erro.txt
echo --- INICIO DO LOG %date% %time% --- > log_erro.txt

echo [1/3] Preparando arquivos...
git add . >> log_erro.txt 2>&1

echo [2/3] Registrando progresso...
git commit -m "Backup_v3.2_%date:/=-%_%time::=-%" >> log_erro.txt 2>&1

echo [3/3] Enviando para a nuvem...
git push origin main >> log_erro.txt 2>&1

echo.
echo ==========================================
echo    RESULTADO DO SINCRONISMO
echo ==========================================
if %ERRORLEVEL% NEQ 0 (
    powershell -Command "Write-Host '[ALERTA] O envio falhou!' -ForegroundColor Red"
    start notepad log_erro.txt
) else (
    powershell -Command "Write-Host '[SUCESSO] Tudo salvo no GitHub!' -ForegroundColor Green"
)

echo.
echo Pressione qualquer tecla para encerrar.
pause >nul
exit