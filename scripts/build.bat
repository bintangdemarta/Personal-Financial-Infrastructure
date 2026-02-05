@echo off
setlocal enabledelayedexpansion

echo Starting enhanced build process for Firefly III...

REM Check if Docker is available
docker --version >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not installed or not in PATH
    exit /b 1
)

echo Building the application...
docker-compose build

if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo Build completed successfully!

echo.
echo To start the application, run:
echo   docker-compose up -d
echo.
echo To view logs:
echo   docker-compose logs -f
echo.

REM Optionally run tests if they exist
if exist "phpunit.xml" (
    echo Running tests...
    docker-compose run --rm app vendor/bin/phpunit
) else if exist "phpunit.xml.dist" (
    echo Running tests...
    docker-compose run --rm app vendor/bin/phpunit
)

endlocal