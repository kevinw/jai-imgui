setlocal

pushd cimgui\imgui || exit /b 1
git checkout docking || exit /b 1
git pull origin docking || exit /b 1

cl /nologo /c /Z7 /Os imgui.cpp imgui_demo.cpp imgui_draw.cpp imgui_widgets.cpp /I. && ^
lib /nologo *.obj /out:imgui.lib /machine:amd64

