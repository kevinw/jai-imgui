setlocal

cd /D "%~dp0"
set ROOT_DIR=%~dp0
set DEST_DIR="%~dp0\win"
if not exist win mkdir win

pushd cimgui\imgui || exit /b 1
git checkout docking || exit /b 1
git pull origin docking || exit /b 1

cl /nologo /c /Z7 /Os ^
/D IMGUI_API=__declspec(dllexport) ^
/D IMGUI_DISABLE_OBSOLETE_FUNCTIONS ^
/I. ^
imgui.cpp imgui_demo.cpp imgui_draw.cpp imgui_widgets.cpp "%ROOT_DIR%\dllmain.cpp" && ^
link /nologo *.obj /out:imgui.dll /incremental:no /debug /dll /machine:amd64

copy /y imgui.lib %DEST_DIR%
copy /y imgui.dll %DEST_DIR%
