@echo off
echo ========================================
echo PostgreSQL Database Setup
echo ========================================
echo.

echo Step 1: Creating the database...
"C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres exoticanimaldb
if %errorlevel% neq 0 (
    echo Database might already exist, trying to connect anyway...
)

echo.
echo Step 2: Loading the schema and sample data...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -f schema_postgresql.sql

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Your database is ready to use!
echo The server is already running at: http://localhost:3000
echo.
pause
