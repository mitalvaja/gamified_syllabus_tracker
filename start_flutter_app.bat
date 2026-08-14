@echo off
title Gamified Syllabus Tracker - Flutter Client
echo ========================================================
echo   Launching Gamified Syllabus Tracker (Flutter)
echo   GLS University - Cross Platform Mobile App Dev
echo ========================================================
echo.

flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [NOTE] Flutter command not found in current PATH.
    echo Please install Flutter or add Flutter SDK to your environment PATH.
    echo You can also open web_preview\index.html in any browser for immediate demonstration.
    pause
    exit /b 1
)

echo Fetching Flutter dependencies...
call flutter pub get

echo Starting Flutter App (Chrome)...
call flutter run -d chrome

pause
