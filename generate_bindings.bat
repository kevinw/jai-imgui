@echo off
setlocal

set ROOT_DIR=%~dp0
cd /D "%ROOT_DIR%"

set n=^&echo.

echo generating Jai bindings ... 
python generate_jai_wrapper.py %* || exit /b
echo.

type stats.txt

echo building imgui_sizes.exe and example_null.exe ...
jai build.jai || exit /b
echo.

echo creating imgui_sizes.exe...
cl imgui_sizes.cpp /Icimgui\imgui win\static\imgui.lib || exit /b
echo.

echo creating imgui_sizes.json...
set PATH=%PATH%;%ROOT_DIR%win
imgui_sizes.exe > imgui_sizes.txt || exit /b
echo.

echo struct sizes:
type imgui_sizes.txt || exit /b
echo.

echo checking jai sizes with test_sizes.exe
test_sizes.exe || exit /b
echo.

echo testing null example...
example_null.exe || exit /b
echo.

echo everything ok!
echo.

