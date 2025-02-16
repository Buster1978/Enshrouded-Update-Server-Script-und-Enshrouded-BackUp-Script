@echo off
setlocal

:: Konfiguration
set "source=C:\SteamCMD\enshrouded_server\savegame"
set "destination=C:\Users\vm1\Desktop\Enshrouded_BackUp_SaveGame" :: TRAG HIER DEINEN ZIELORDNER EIN!
set "interval=3600"  :: Zeitintervall in Sekunden (1 Stunde = 3600 Sekunden)
set "days_to_keep=30"  :: Anzahl der Tage, die Backups behalten werden

echo Starte regelmaessige Sicherung...
echo Quelle: %source%
echo Ziel: %destination%
echo Intervall: %interval% Sekunden
echo Backups werden nach %days_to_keep% Tagen geloescht.

:loop
:: Zeitstempel erstellen (Jahr-Monat-Tag_Stunde-Minute-Sekunde)
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set "timestamp=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%"

:: Zielordner mit Zeitstempel
set "backupfolder=%destination%\Backup_%timestamp%"

echo [%time%] Sicherung gestartet: %backupfolder%...
mkdir "%backupfolder%"
xcopy "%source%" "%backupfolder%" /E /I /Y /Q
if %errorlevel% equ 0 (
    echo [%time%] Sicherung erfolgreich!
) else (
    echo [%time%] Fehler bei der Sicherung!
)

:: Alte Backups löschen
echo [%time%] Alte Backups loeschen (aelter als %days_to_keep% Tage)...
forfiles /p "%destination%" /m "Backup_*" /d -%days_to_keep% /c "cmd /c echo Loesche @path & rd /s /q @path"

echo [%time%] Warten auf naechstes Intervall (1 Stunde)...
timeout /t %interval% /nobreak >nul
goto loop
