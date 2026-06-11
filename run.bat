@echo off
:: Shadow of the Pyramid — launcher
:: Requires Godot Engine 4.x (https://godotengine.org/download)

SET SCRIPT_DIR=%~dp0
SET PROJECT_DIR=%SCRIPT_DIR%pyramid

:: Search for Godot in PATH
WHERE godot4 >nul 2>&1
IF %ERRORLEVEL%==0 ( SET GODOT=godot4 & GOTO run )

WHERE godot >nul 2>&1
IF %ERRORLEVEL%==0 ( SET GODOT=godot & GOTO run )

:: Check common manual-install location
IF EXIST "%LOCALAPPDATA%\Programs\Godot\Godot_v4*.exe" (
    FOR /F "delims=" %%G IN ('DIR /B /O-N "%LOCALAPPDATA%\Programs\Godot\Godot_v4*.exe" 2^>nul') DO (
        SET GODOT=%LOCALAPPDATA%\Programs\Godot\%%G
        GOTO run
    )
)

:: Not found
echo ERROR: Godot Engine 4.x not found.
echo.
echo Please install Godot 4 from https://godotengine.org/download
echo and make sure it is on your PATH or installed in %%LOCALAPPDATA%%\Programs\Godot.
pause
EXIT /B 1

:run
echo Using Godot: %GODOT%
"%GODOT%" --path "%PROJECT_DIR%"
