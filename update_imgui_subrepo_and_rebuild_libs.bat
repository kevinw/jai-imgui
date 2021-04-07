@setlocal

@set IMGUI_BRANCH=docking
@set ROOT_DIR=%~dp0
@set COMPILE=cl /nologo /c /Zi /Os /I.
@set COMMON_IMPL=/DJAI_IMGUI_BUILDING_IMPLEMENTATION "%ROOT_DIR%\jai-imgui.cpp"

@REM
@REM setup directories
@REM
@cd /D "%~dp0"
@set DEST_DIR=%~dp0win
@if not exist win mkdir win
@if not exist win\static mkdir win\static
@if not exist win\dll mkdir win\dll

@REM
@REM update the imgui git repo
@REM
git submodule update --init
pushd imgui || exit /b 1
git checkout %IMGUI_BRANCH% && git pull origin %IMGUI_BRANCH% || exit /b 1

@echo.
@echo ===== compile dynamic library (DLL) build...
@del *.obj
%COMPILE% /DIMGUI_API=__declspec(dllexport) %COMMON_IMPL% "%ROOT_DIR%\dllmain.cpp" || exit /b 1
link /NOLOGO *.obj /OUT:imgui.dll /INCREMENTAL:NO /DEBUG:FULL /DLL /MACHINE:amd64 || exit /b 1
@for %%I in (imgui.lib imgui.dll imgui.pdb) do @copy /y %%I "%DEST_DIR%\dll"
@del imgui.lib imgui.dll imgui.pdb

@echo.
@echo ===== compile static build...
@del *.obj
%COMPILE% %COMMON_IMPL% || exit /b 1
lib /NOLOGO *.obj /OUT:imgui.lib /MACHINE:amd64 || exit /b 1
@for %%I in (imgui.lib) do @copy /y %%I "%DEST_DIR%\static"
@del imgui.lib imgui.lb imgui.exp

@echo off
echo.
echo OK!
echo Binaries have been copied to %DEST_DIR%.
echo.
