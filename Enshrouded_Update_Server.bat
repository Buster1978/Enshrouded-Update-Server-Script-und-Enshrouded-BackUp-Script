@echo off
setlocal
TITLE Update, Validate and Launch Enshrouded
echo Checking for updates, validating, and launching Enshrouded dedicated server...

:: Pfade anpassen
set STEAMCMD_PATH=C:\SteamCMD\
set SERVER_PATH=C:\SteamCMD\enshrouded_server
set SERVER_EXECUTABLE=enshrouded_server.exe
set APP_ID=2278520
set BACKUP_SCRIPT=C:\Users\vm1\Desktop\Enshrouded_BackUp.bat

echo [%time%] Starte Update-Prozess...

echo Speichere den aktuellen Spielstand...
:: Falls dein Server eine Möglichkeit hat, den Speicherbefehl zu senden (z. B. RCON), kann das hier ergänzt werden.

timeout /t 15

echo Stoppe Enshrouded Server...
taskkill /F /IM %SERVER_EXECUTABLE% >nul 2>&1
timeout /t 10

echo Starte Update fuer Enshrouded Server...
%STEAMCMD_PATH%\steamcmd.exe +login anonymous +force_install_dir "%SERVER_PATH%" +app_update %APP_ID% validate +quit

echo Update abgeschlossen.

echo Starte Enshrouded Server neu...
cd /d "%SERVER_PATH%"
start "" "%SERVER_EXECUTABLE%"

:: Starte Backup-Skript synchron (wartet, bis Backup abgeschlossen ist)
if exist "%BACKUP_SCRIPT%" (
    echo [%time%] Starte Backup...
    call "%BACKUP_SCRIPT%"
) else (
    echo [%time%] Fehler: Backup-Skript nicht gefunden!
)
