@echo off
setlocal
if not exist "%~dp0bin\zed.exe" (
  echo Missing bin\zed.exe. Extract the entire ZIP file first.
  pause
  exit /b 1
)
set "ZED_ZHCN_PROFILE=%LOCALAPPDATA%\Zed-zh-CN"
if not exist "%ZED_ZHCN_PROFILE%\config" mkdir "%ZED_ZHCN_PROFILE%\config"
if not exist "%ZED_ZHCN_PROFILE%\config\settings.json" (
  >"%ZED_ZHCN_PROFILE%\config\settings.json" echo {"auto_update": false}
)
start "" "%~dp0bin\zed.exe" --user-data-dir "%ZED_ZHCN_PROFILE%"
endlocal
