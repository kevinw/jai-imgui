# jai-imgui

### NOTE: Jai comes with a working ImGui module, but based on an older version of ImGui.

This is an alternate [Dear ImGui](https://github.com/ocornut/imgui) wrapper for Jai with an automatic C++ <-> Jai bindings generator.

![a screenshot showing the demo window](docs/screenshot1.png)

Currently this repo includes Windows binaries for the `docking` branch of ImGui 1.83 WIP. (You can checkout whatever revision you like in the `imgui` subrepo and regenerate the bindings.)

This project makes an effort to preserve the convenience of the C++ API by:

* maintaining default argument values
* turning `label` and `label_end` `const char *` arguments into single Jai string arguments
* providing a module parameter for whether to link statically against ImGui or not

## Building demos

```
jai build_examples.jai
```

Then run

`example_no_graphics.exe` to see a command-line (non-graphical) test of the bindings, or

`example_opengl.exe` to see the ImGui demo window. In this second example, you can go to `Examples->Dockspace` to test out docking.

One gotcha here: there's an ImGui module included in Jai. The demos expect THIS ImGui library to be `#import`ed. So your build script in your own project must modify the `import_path`.

## Regenerating bindings from scratch

The ImGui project itself sits in a subrepository in the `imgui` directory.

To update the ImGui headers, and rebuild `win/static/imgui.lib` and `win/dll/imgui.dll`:

```
update_imgui_subrepro_and_rebuild_libs.bat
```

To generate `imgui.jai`:

```
jai generate_imgui_bindings.jai
```
