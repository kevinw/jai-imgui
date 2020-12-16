setlocal

REM
REM setup directories
REM

@cd /D "%~dp0"
@set ROOT_DIR=%~dp0
@set DEST_DIR=%~dp0win
@if not exist win mkdir win
@if not exist win\static mkdir win\static
@if not exist win\dll mkdir win\dll

REM
REM update the git repos
REM

@pushd cimgui\imgui || exit /b 1
git checkout docking || exit /b 1
git pull origin docking || exit /b 1

REM
REM compile options
REM

set COMPILE=cl /nologo /c /Zi /Os /I.
set COMMON_DEFINES=/DIMGUI_DISABLE_OBSOLETE_FUNCTIONS /DIMGUI_DISABLE_DEFAULT_ALLOCATORS /DIMGUI_USE_BGRA_PACKED_COLOR
set COMMON_SOURCES=imgui.cpp imgui_demo.cpp imgui_draw.cpp imgui_widgets.cpp imgui_tables.cpp

REM
REM compile DLL version
REM

%COMPILE% /D IMGUI_API=__declspec(dllexport) %COMMON_DEFINES% %COMMON_SOURCES% "%ROOT_DIR%\dllmain.cpp" || exit /b 1
link /NOLOGO *.obj /OUT:imgui.dll /DEBUG:FULL /DLL /MACHINE:amd64 || exit /b 1

@for %%I in (imgui.lib imgui.dll imgui.pdb) do copy /y %%I "%DEST_DIR%\dll"

del imgui.lib imgui.dll imgui.pdb

REM
REM compile static version
REM

%COMPILE% /D %COMMON_DEFINES% %COMMON_SOURCES% || exit /b 1
lib /NOLOGO *.obj /OUT:imgui.lib /MACHINE:amd64 || exit /b 1

@for %%I in (imgui.lib) do copy /y %%I "%DEST_DIR%\static"

del imgui.lib imgui.lb imgui.exp
