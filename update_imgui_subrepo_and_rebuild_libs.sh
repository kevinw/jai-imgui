#!/bin/bash

IMGUI_BRANCH=docking
COMMON_IMPL=jai-imgui.cpp

git submodule update --init
(cd imgui; git checkout $IMGUI_BRANCH && git pull origin $IMGUI_BRANCH ) || exit 1

g++ -fPIC -DJAI_IMGUI_BUILDING_IMPLEMENTATION -Iimgui -c $COMMON_IMPL -o imgui.o || exit 1
g++ imgui.o -shared -o imgui.so || exit 1
ar rc imgui.a imgui.o
mkdir -p linux/static
mv imgui.so linux/
mv imgui.a linux/static/
rm imgui.o

echo "OK!"
