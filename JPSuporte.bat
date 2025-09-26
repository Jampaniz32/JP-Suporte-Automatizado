@echo off
setlocal EnableExtensions EnableDelayedExpansion
:: ==================================================================
::  MENU SUPORTE TECNICO V1.0  -  POR JAMPANIZ ABUCHIR PIRA
::  E-mail: jampanizabuchir32@gmail.com
::  Seguranca: sem acoes destrutivas; confirmacoes para passos sensiveis.
:: ==================================================================

color 0B
title MENU SUPORTE TECNICO V1.0 - POR JAMPANIZ ABUCHIR PIRA
cd /d "%~dp0"

:: >>> IMPORTANTE: pula definicoes de funcoes e vai direto ao MENU
goto :MENU

:: ----------------------[ Funcoes utilitarias ]----------------------
:CheckAdmin
fltmc >nul 2>&1
if errorlevel 1 ( set "_IS_ADMIN=0" ) else ( set "_IS_ADMIN=1" )
goto :eof

:ElevateSelf
powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
goto :eof

:PauseMenu
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto :eof

:ConfirmAction
set "_CONFIRM=N"
set /p "_CONFIRM=%~1 (S/N): "
if /I "%_CONFIRM%"=="S" ( set "_CONFIRM=Y" ) else ( set "_CONFIRM=N" )
goto :eof

:Header
cls
echo ===============================================================
echo   MENU SUPORTE TECNICO V1.0
echo   POR JAMPANIZ ABUCHIR PIRA
echo   jampanizabuchir32@gmail.com
echo ===============================================================
goto :eof

:: ---------------------------[ MENU ]--------------------------------
:MENU
call :Header
call :CheckAdmin
echo.
echo  SISTEMA: %COMPUTERNAME% ^| UTILIZADOR: %USERNAME% ^| ADMIN: %_IS_ADMIN%
echo ---------------------------------------------------------------
echo  [ 1] Desligar PC daqui 1 hora
echo  [ 2] Desligar PC daqui 2 horas
echo  [ 3] Cancelar desligamento agendado
echo  [ 4] Resolver PC com Lentidao (limpeza leve)
echo  [ 5] Resolver Internet Lenta
echo  [ 6] Iniciar Reparo no PC ^(DISM + SFC^) [Admin]
echo  [ 7] Teste de internet (Speedtest by Ookla)
echo  [ 8] Ver IP
echo  [ 9] Mostrar DNS cache
echo  [10] Abrir prompt como admin (UAC)
echo  [11] Abrir Gestor de Tarefas
echo  [12] Testar conectividade (ping 8.8.8.8)
echo  [13] Mostrar adaptadores de rede
echo  [14] Gerar log do Windows Update (Desktop)
echo  [15] Mostrar informacao do sistema
echo  [16] Flush DNS
echo  [17] Reset Winsock e IP [Admin] (requer reinicio)
echo  [18] Otimizar disco C: (defrag/trim) [Admin]
echo  [19] Desligar Firewall (NAO RECOMENDADO) [Admin]
echo  [20] Ligar Firewall [Admin]
echo  [21] Abrir Event Viewer
echo  [22] Teste de desempenho de disco (winsat disk)
echo  [23] Criar Ponto de Restauracao Manual [Admin]
echo  [24] Atualizar pacotes com winget (se disponivel)
echo  [25] Forcar gpupdate
echo  [ 0] Sair
echo ---------------------------------------------------------------
set "OP="
set /p "OP=Escolha uma opcao (0-25): "
if "%OP%"=="" goto :MENU

for /f "delims=0123456789" %%A in ("%OP%") do goto :MENU

if "%OP%"=="1"  goto :SHUT1H
if "%OP%"=="2"  goto :SHUT2H
if "%OP%"=="3"  goto :CANCEL_SHUT
if "%OP%"=="4"  goto :FIX_SLOW_PC
if "%OP%"=="5"  goto :FIX_SLOW_NET
if "%OP%"=="6"  goto :REPAIR_PC
if "%OP%"=="7"  goto :OOKLA
if "%OP%"=="8"  goto :SHOW_IP
if "%OP%"=="9"  goto :SHOW_DNSCACHE
if "%OP%"=="10" goto :OPEN_ADMIN_PROMPT
if "%OP%"=="11" goto :OPEN_TASKMGR
if "%OP%"=="12" goto :PING8888
if "%OP%"=="13" goto :SHOW_NETADAPTERS
if "%OP%"=="14" goto :WU_LOG
if "%OP%"=="15" goto :SYSINFO
if "%OP%"=="16" goto :FLUSH_DNS
if "%OP%"=="17" goto :RESET_NET
if "%OP%"=="18" goto :DEFRAG_C
if "%OP%"=="19" goto :FW_OFF
if "%OP%"=="20" goto :FW_ON
if "%OP%"=="21" goto :EVENTVWR
if "%OP%"=="22" goto :WINSAT
if "%OP%"=="23" goto :RESTORE_POINT
if "%OP%"=="24" goto :WINGET_UP
if "%OP%"=="25" goto :GPUPDATE
if "%OP%"=="0"  goto :SAIR
goto :MENU

:: -------------------------[ IMPLEMENTACOES ]------------------------
:SHUT1H
echo Agendando desligamento em 1 hora...
shutdown /s /t 3600 /c "Desligamento agendado (1h) - Menu Suporte"
call :PauseMenu
goto :MENU

:SHUT2H
echo Agendando desligamento em 2 horas...
shutdown /s /t 7200 /c "Desligamento agendado (2h) - Menu Suporte"
call :PauseMenu
goto :MENU

:CANCEL_SHUT
echo Cancelando desligamento agendado...
shutdown /a
if errorlevel 1 (echo Nao havia desligamento agendado.)
call :PauseMenu
goto :MENU

:FIX_SLOW_PC
echo Fechando apps comuns em segundo plano (ignora erros)...
for %%P in (OneDrive.exe Teams.exe msedge.exe chrome.exe brave.exe firefox.exe) do taskkill /F /IM %%P >nul 2>&1
echo Limpando temporarios do usuario...
del /q /f /s "%TEMP%\*" >nul 2>&1
echo Limpando temporarios do sistema...
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
echo Executando limpeza de disco basica (cleanmgr)...
cleanmgr /sageset:9 >nul 2>&1
cleanmgr /sagerun:9
echo Concluido.
call :PauseMenu
goto :MENU

:FIX_SLOW_NET
call :Header
call :CheckAdmin
echo Teste rapido de conectividade:
ping -n 4 1.1.1.1
ping -n 4 8.8.8.8
ping -n 4 google.com
echo.
echo Flush DNS...
ipconfig /flushdns
echo Renovando IP (pode cair a conexao por instantes)...
ipconfig /release
ipconfig /renew
if "%_IS_ADMIN%"=="1" (
  call :ConfirmAction "Deseja resetar Winsock e TCP/IP (requer reinicio)"
  if /I "%_CONFIRM%"=="Y" (
    netsh winsock reset
    netsh int ip reset
    echo Reinicie o PC para aplicar completamente as mudancas.
  )
) else (
  echo Para reset profundo (netsh) reabra este menu como Administrador.
)
call :PauseMenu
goto :MENU

:REPAIR_PC
call :CheckAdmin
if not "%_IS_ADMIN%"=="1" (
  echo Esta opcao requer Administrador.
  call :ConfirmAction "Deseja reabrir o menu elevado agora"
  if /I "%_CONFIRM%"=="Y" ( call :ElevateSelf )
  call :PauseMenu
  goto :MENU
)
echo Verificando e reparando imagem do Windows (DISM)...
DISM /Online /Cleanup-Image /RestoreHealth
echo Verificando arquivos do sistema (SFC)...
sfc /scannow
echo Reparos concluidos. Recomenda-se reiniciar o PC.
call :PauseMenu
goto :MENU

:OOKLA
start "" https://www.speedtest.net
echo Aberto no navegador padrao.
call :PauseMenu
goto :MENU

:SHOW_IP
ipconfig
echo.
ipconfig /all | findstr /I "IPv4 DNS DHCP"
call :PauseMenu
goto :MENU

:SHOW_DNSCACHE
ipconfig /displaydns
call :PauseMenu
goto :MENU

:OPEN_ADMIN_PROMPT
powershell -NoProfile -Command "Start-Process cmd -Verb RunAs"
echo Se solicitado, aprove o UAC.
call :PauseMenu
goto :MENU

:OPEN_TASKMGR
start "" taskmgr
call :PauseMenu
goto :MENU

:PING8888
ping -n 6 8.8.8.8
call :PauseMenu
goto :MENU

:SHOW_NETADAPTERS
echo Adaptadores de rede (netsh):
netsh interface show interface
echo.
echo Enderecamento detalhado (ipconfig /all):
ipconfig /all
call :PauseMenu
goto :MENU

:WU_LOG
echo Gerando WindowsUpdate.log na Area de Trabalho...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-WindowsUpdateLog -LogPath \"$env:USERPROFILE\Desktop\WindowsUpdate.log\"" 
echo Concluido. Verifique o ficheiro WindowsUpdate.log no Desktop.
call :PauseMenu
goto :MENU

:SYSINFO
systeminfo
call :PauseMenu
goto :MENU

:FLUSH_DNS
ipconfig /flushdns
call :PauseMenu
goto :MENU

:RESET_NET
call :CheckAdmin
if not "%_IS_ADMIN%"=="1" (
  echo Esta opcao requer Administrador.
  call :PauseMenu
  goto :MENU
)
call :ConfirmAction "Tem certeza que deseja RESETAR Winsock e TCP/IP (requer reinicio)"
if /I not "%_CONFIRM%"=="Y" goto :MENU
netsh winsock reset
netsh int ip reset
echo Reinicie o PC para concluir.
call :PauseMenu
goto :MENU

:DEFRAG_C
call :CheckAdmin
if not "%_IS_ADMIN%"=="1" (
  echo Esta opcao requer Administrador.
  call :PauseMenu
  goto :MENU
)
call :ConfirmAction "Otimizar/Desfragmentar C: agora"
if /I not "%_CONFIRM%"=="Y" goto :MENU
defrag C: /O /U /V
call :PauseMenu
goto :MENU

:FW_OFF
call :CheckAdmin
if not "%_IS_ADMIN%"=="1" (
  echo Esta opcao requer Administrador.
  call :PauseMenu
  goto :MENU
)
echo ATENCAO: Desligar o firewall reduz a seguranca do sistema.
call :ConfirmAction "Deseja REALMENTE desligar o Firewall (todas as perfis)"
if /I not "%_CONFIRM%"=="Y" goto :MENU
netsh advfirewall set allprofiles state off
echo Firewall desativado. Use a opcao [20] para ligar novamente.
call :PauseMenu
goto :MENU

:FW_ON
call :CheckAdmin
if not "%_IS_ADMIN%"=="1" (
  echo Esta opcao requer Administrador.
  call :PauseMenu
  goto :MENU
)
netsh advfirewall set allprofiles state on
echo Firewall ativado.
call :PauseMenu
goto :MENU

:EVENTVWR
start "" eventvwr.msc
call :PauseMenu
goto :MENU

:WINSAT
winsat disk
call :PauseMenu
goto :MENU

:RESTORE_POINT
call :CheckAdmin
if not "%_IS_ADMIN%"=="1" (
  echo Esta opcao requer Administrador.
  call :PauseMenu
  goto :MENU
)
echo Criando ponto de restauracao manual...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'PontoManual_MenuSuporte' -RestorePointType 'MODIFY_SETTINGS'"
echo Concluido (se a Protecao do Sistema estiver ativa).
call :PauseMenu
goto :MENU

:WINGET_UP
where winget >nul 2>&1
if errorlevel 1 (
  echo winget nao encontrado neste sistema.
  call :PauseMenu
  goto :MENU
)
echo Iniciando atualizacao de pacotes com winget...
winget upgrade --all --include-unknown
echo Concluido (alguns pacotes podem requerer confirmacoes).
call :PauseMenu
goto :MENU

:GPUPDATE
gpupdate /force
call :PauseMenu
goto :MENU

:SAIR
echo Encerrando... Ate logo!
endlocal
exit /b 0
