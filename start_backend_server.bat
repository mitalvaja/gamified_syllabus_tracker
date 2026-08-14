@echo off
title Gamified Syllabus Tracker - REST API Backend
echo ========================================================
echo   Launching Gamified Syllabus Tracker - REST API Backend
echo   Node.js / Express on http://localhost:5000/api
echo ========================================================
echo.

cd backend
if not exist node_modules (
    echo Installing backend dependencies...
    call npm install
)

echo Starting backend server on http://localhost:5000...
node server.js
pause
