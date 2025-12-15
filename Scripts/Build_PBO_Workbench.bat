@echo off
setlocal enabledelayedexpansion

rem Simple test wrapper to try the CF Workbench BinarizePBO.bat
rem Usage: Build_PBO_Workbench.bat [ModFolderRelativeToPrefix]
rem Example: Build_PBO_Workbench.bat \askal\Core

set "WORKBENCH_URL=https://raw.githubusercontent.com/Arkensor/DayZ-CommunityFramework/production/JM/CF/Workbench/Batchfiles/BinarizePBO.bat"
set "WORKBENCH_DIR=%~dp0WorkbenchTemp"
set "PROJECT_CFG=%WORKBENCH_DIR%\project.cfg"
set "USER_CFG=%WORKBENCH_DIR%\user.cfg"

rem --- Defaults (edit as needed or pass env vars) ---
set "keyDirectory=D:\Dayz\Keys\"
set "keyName=AsKal"
set "modName=Askal_MOD"
set "workDrive=D:"
set "modBuildDirectory=D:\Dayz\Mods\"
set "prefixLinkRoot=\askal"

if "%1"=="" (
  set "folderToBuild=%prefixLinkRoot%\%modName%"
) else (
  set "folderToBuild=%~1"
)

echo Preparing Workbench test in %WORKBENCH_DIR%
mkdir "%WORKBENCH_DIR%" 2>nul

echo keyDirectory=%keyDirectory%> "%PROJECT_CFG%"
echo keyName=%keyName%>> "%PROJECT_CFG%"
echo modName=%modName%>> "%PROJECT_CFG%"
echo workDrive=%workDrive%>> "%PROJECT_CFG%"
echo modBuildDirectory=%modBuildDirectory%>> "%PROJECT_CFG%"
echo prefixLinkRoot=%prefixLinkRoot%>> "%PROJECT_CFG%"

echo user specific settings > "%USER_CFG%"

echo Downloading BinarizePBO.bat from CF Workbench...
powershell -NoProfile -Command "Try { Invoke-WebRequest -UseBasicParsing -Uri '%WORKBENCH_URL%' -OutFile '%WORKBENCH_DIR%\BinarizePBO.bat' } Catch { Exit 1 }"
if ERRORLEVEL 1 (
  echo Failed to download BinarizePBO.bat from %WORKBENCH_URL%
  exit /b 2
)

echo Running Workbench Binarize for %folderToBuild%
pushd "%WORKBENCH_DIR%"
call "%WORKBENCH_DIR%\BinarizePBO.bat" "%folderToBuild%"
set "rc=%ERRORLEVEL%"
popd

if %rc%==0 (
  echo Workbench build finished successfully.
) else (
  echo Workbench build failed (exit code %rc%). See above output for details.
)

exit /b %rc%
