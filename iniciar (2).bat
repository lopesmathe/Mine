@echo off
setlocal enabledelayedexpansion

:: Forçar o CMD a reconhecer a pasta onde o .bat está (D:\Servidor_Mine)
cd /d "%~dp0"

:: Nome exato do seu arquivo JAR (Copiado do seu erro)
set FABRIC_JAR=fabric-server-mc.26.1.2-loader.0.19.2-launcher.1.1.1.jar

:INICIO
cls
echo ##########################################
echo #       MINECRAFT SERVER SYNC v2.5       #
echo #   Status: Matheus ^<--^> Paulo (GIT)    #
echo ##########################################
echo.

echo [GIT] Sincronizando com a Nuvem...
git fetch origin main >nul 2>&1

echo [GIT] Aplicando ultima versao e limpando arquivos temporarios...
git reset --hard origin/main >nul 2>&1
git clean -fd -e "%~nx0" -e "mods/" >nul 2>&1

echo.
echo [OK] Pasta de trabalho: %cd%
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
if exist server.properties (
    findstr /v "view-distance" server.properties > server.properties.tmp
    echo view-distance=%VIEW% >> server.properties.tmp
    move /y server.properties.tmp server.properties >nul
)

echo.
if exist "%FABRIC_JAR%" (
    echo [SERVER] Iniciando %FABRIC_JAR%...
    echo [AVISO] USE 'STOP' PARA SALVAR.
    echo.
    java -Xmx%RAM% -Xms%RAM% -jar "%FABRIC_JAR%" nogui
) else (
    echo [ERRO] O arquivo nao foi encontrado na pasta!
    echo Nome procurado: %FABRIC_JAR%
    echo.
    echo Certifique-se que o nome do arquivo .jar na pasta e EXATAMENTE igual ao acima.
    pause
    goto INICIO
)

echo.
echo [GIT] Servidor desligado. Iniciando salvamento...

if exist log_erro.txt del log_erro.txt
echo --- INICIO DO LOG %date% %time% --- > log_erro.txt

echo [1/3] Preparando arquivos...
git add . >> log_erro.txt 2>&1

echo [2/3] Registrando progresso...
git commit -m "Backup_v2.5_%date:/=-%_%time::=-%" >> log_erro.txt 2>&1

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
    echo [SUCESSO] Tudo salvo no GitHub!
)

echo.
echo Pressione qualquer tecla para encerrar.
pause >nul
exit