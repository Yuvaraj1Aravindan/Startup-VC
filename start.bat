@echo off
REM VC UseCase Scoring - Quick Start Script for Windows

echo Starting VC UseCase Scoring Platform...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo Docker is not running. Please start Docker Desktop.
    exit /b 1
)

REM Check if .env exists
if not exist .env (
    echo Creating .env file from .env.example...
    copy .env.example .env
    echo .env file created. Please review and update if needed.
    echo.
)

REM Build and start containers
echo Building and starting Docker containers...
docker-compose up -d --build

echo.
echo Waiting for services to be ready...
timeout /t 10 /nobreak >nul

echo.
echo All services are running!
echo.
echo Access the application:
echo   Frontend:  http://localhost:5173
echo   Backend:   http://localhost:8000
echo   API Docs:  http://localhost:8000/docs
echo.
echo Default test users (you can register new ones):
echo   Email: startup@example.com ^| Password: password123 ^| Role: Startup Aspirant
echo   Email: vc@example.com      ^| Password: password123 ^| Role: VC Representative
echo.
echo View logs:
echo   docker-compose logs -f
echo.
echo Stop services:
echo   docker-compose down
echo.

pause
