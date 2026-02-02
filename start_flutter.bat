@echo off
echo ========================================
echo   1-3-7 Study App - Flutter App
echo ========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed!
    echo Please install Flutter from https://flutter.dev/
    pause
    exit /b 1
)

echo [OK] Flutter is installed
echo.

REM Get dependencies
echo Installing Flutter dependencies...
call flutter pub get

echo.
echo ========================================
echo   Starting Flutter App...
echo ========================================
echo.
echo Starting standalone frontend...
echo.
echo Available devices:
flutter devices

echo.
echo ========================================
echo.

REM Run the app
flutter run
