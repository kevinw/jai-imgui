setlocal

set ROOT_DIR=%~dp0
cd /D "%ROOT_DIR%"

set PATH=%PATH%;"%ROOT_DIR%\tools\win"

cd cimgui\generator
luajit ./generator.lua cl "internal" glfw opengl3 opengl2 sdl
