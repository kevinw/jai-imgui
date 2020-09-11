@echo off
setlocal

set n=^&echo.

echo generating imgui_new.jai ... 
python gen_mangle_map.py %* || exit /b
echo.

echo building imgui_sizes.exe and example_null.exe ...
jai run_test.jai || exit /b
echo.

echo creating imgui_sizes.exe...
cl imgui_sizes.cpp imgui.lib || exit /b
echo.

echo creating imgui_sizes.json...
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

