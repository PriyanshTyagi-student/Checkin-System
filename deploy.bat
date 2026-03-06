@echo off
REM Quick deployment check for Windows
REM Call this before pushing to Cloudflare Pages

echo.
echo ========================================
echo Zonex 2026 Check-In System
echo Deployment Verification (Windows)
echo ========================================
echo.

setlocal enabledelayedexpansion

REM Check if index.html exists
if not exist "%CD%\index.html" (
    echo Error: index.html not found!
    echo Run this script from the checkin folder
    exit /b 1
)

echo Step 1: Checking files...
if exist "%CD%\index.html" (
    echo [OK] index.html found
) else (
    echo [FAIL] index.html not found
    exit /b 1
)

if exist "%CD%\README.md" (
    echo [OK] README.md found
) else (
    echo [WARN] README.md not found (recommended to have)
)

if exist "%CD%\CLOUDFLARE-DEPLOYMENT.md" (
    echo [OK] CLOUDFLARE-DEPLOYMENT.md found
) else (
    echo [WARN] CLOUDFLARE-DEPLOYMENT.md not found
)

echo.
echo Step 2: Checking backend URL configuration...
findstr /C:"const BACKEND_URL" "%CD%\index.html" > nul
if %ERRORLEVEL% equ 0 (
    echo [OK] BACKEND_URL configuration found
    
    findstr /C:"http://localhost:5000" "%CD%\index.html" > nul
    if %ERRORLEVEL% equ 0 (
        echo [WARN] BACKEND_URL still set to placeholder!
        echo        Update it before deploying to production
    ) else (
        echo [OK] BACKEND_URL appears to be set
    )
) else (
    echo [FAIL] BACKEND_URL not found
    exit /b 1
)

echo.
echo Step 3: Checking for unnecessary files...
if exist "%CD%\node_modules" (
    echo [WARN] node_modules folder found - should not be committed
    echo        Add to .gitignore if not already there
)

if exist "%CD%\.git\*" (
    echo [INFO] Git repository detected
)

echo.
echo ========================================
echo Verification Complete!
echo ========================================
echo.
echo Next Steps:
echo 1. Commit and push to GitHub
echo    git add .
echo    git commit -m "Update check-in system"
echo    git push
echo.
echo 2. Go to Cloudflare Pages:
echo    https://pages.cloudflare.com
echo.
echo 3. Create new project from Git
echo    - Build output directory: checkin
echo    - No build command needed
echo.
echo 4. Update backend CORS to allow your Pages URL
echo.
echo For details, see CLOUDFLARE-DEPLOYMENT.md
echo.
pause
