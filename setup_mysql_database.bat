@echo off
title Gamified Syllabus Tracker - MySQL Setup
echo ========================================================
echo   Importing MySQL Database Schema & Sample Data
echo   Database: gamified_syllabus_db
echo ========================================================
echo.

set MYSQL_EXE=C:\xampp\mysql\bin\mysql.exe
if exist "%MYSQL_EXE%" (
    echo Using XAMPP MySQL binary at %MYSQL_EXE%...
    "%MYSQL_EXE%" -u root < backend\database\schema.sql
    "%MYSQL_EXE%" -u root < backend\database\seed.sql
    echo.
    echo Database gamified_syllabus_db created and seeded successfully!
) else (
    echo Attempting default mysql in PATH...
    mysql -u root < backend\database\schema.sql
    mysql -u root < backend\database\seed.sql
    echo.
    echo Database setup executed!
)

pause
