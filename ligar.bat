@echo off
echo [GIT] Buscando novidades do mundo no GitHub...
git pull

echo.
echo [SERVER] Iniciando Servidor de Minecraft...
echo [DICA] Quando quiser fechar e salvar, digite "stop" no console do servidor.
echo.

:: Aqui usamos 4GB para voce, mas se for o Paulo, pode mudar para 2G
java -Xmx4G -Xms4G -jar server.jar nogui

echo.
echo [GIT] Servidor desligado. Salvando progresso...
git add .
git commit -m "Sincronia automatica: %date% %time%"
git push

echo.
echo [OK] O mundo foi enviado para o GitHub com sucesso!
echo Ja pode fechar esta janela.
pause