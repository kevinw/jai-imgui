# jai-imgui

An alternate IMGUI wrapper for Jai

## 

Make sure we have the `cimgui/` folder, and IT has its own `imgui/` folder.
```
git submodule update --init --recursive
```

Build `imgui.lib` and `imgui.dll`.

```
build_windows_libs.bat
```

Generate cimgui's description JSON files.

```
generate_cimgui_json.bat
```

And finally generate the jai bindings.

```
generate_bindings.bat
```

