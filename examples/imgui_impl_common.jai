UI_State_Base :: struct {
    ctx: *ImGui.Context;

    small_font:     *ImGui.ImFont;
    monospace_font: *ImGui.ImFont;

    Time: float64;
    MousePressed: [3]bool;
    MouseWheel: float;

    original_style: *ImGui.Style; // infrequently accessed, so pointer

    config: struct {
        current_style_scale:float = 1.1;
    };
}

imgui_alloc_context: Context;

c_alloc :: (sz: u64, userdata: *void) -> *void #c_call {
    push_context << cast(*Context)userdata {
        return alloc(cast(s64)sz);
    }
}

c_free :: (ptr: *void, userdata: *void) #c_call {
    push_context << cast(*Context)userdata {
        free(ptr);
    }
}

_SetImGuiAllocators :: () {
    imgui_alloc_context = context;
    ImGui.SetAllocatorFunctions(c_alloc, c_free, *imgui_alloc_context);
}

ImGui_Impl_CreateContext :: (using ui_state: *UI_State, $set_default_allocators: bool = true) {
    #if set_default_allocators {
        imgui_alloc_context = context;
        _SetImGuiAllocators();
    }

    ctx = ImGui.CreateContext();

    io := ImGui.GetIO();
    io.ConfigFlags_ |= .DockingEnable;
}

ImGui_Impl_ProcessInputEvents :: (using ui_state: *UI_State, events: []Input.Event) {
    using Input;
    io := ImGui.GetIO();

    MouseWheel = 0;
    for events {
        if it.type == {
            case .MOUSE_WHEEL;
                MouseWheel = cast(float)it.wheel_delta / cast(float)it.typical_wheel_delta;
                remove it;
            case .KEYBOARD;
                if it.key_code == {
                    case .MOUSE_BUTTON_LEFT;   MousePressed[0] = it.key_pressed != 0;
                    case .MOUSE_BUTTON_RIGHT;  MousePressed[1] = it.key_pressed != 0;
                    case .MOUSE_BUTTON_MIDDLE; MousePressed[2] = it.key_pressed != 0;
                    case;
                        io.KeysDown[it.key_code] = it.key_pressed != 0;
                        io.KeyShift = it.shift_pressed;
                        io.KeyCtrl  = it.ctrl_pressed;
                        io.KeyAlt   = it.alt_pressed;
                }
                remove it;
            case .TEXT_INPUT;
                buf: [size_of(s32) + 1]u8; // unicode rune + 0
                <<(cast(*s32)buf.data) = cast(s32)it.utf32;
                io.AddInputCharactersUTF8(io, buf.data);
                remove it;
        }
    }
}

ImGui_Impl_SetupInputModuleKeymap :: (using ui_state: *UI_State) {
    using Input.Key_Code;
    io := ImGui.GetIO();
    // Keyboard mapping. ImGui will use those indices to peek into the io.KeyDown[] array.
    io.KeyMap[ImGui.Key.Tab]        = xx TAB;
    io.KeyMap[ImGui.Key.LeftArrow]  = xx ARROW_LEFT;
    io.KeyMap[ImGui.Key.RightArrow] = xx ARROW_RIGHT;
    io.KeyMap[ImGui.Key.UpArrow]    = xx ARROW_UP;
    io.KeyMap[ImGui.Key.DownArrow]  = xx ARROW_DOWN;
    io.KeyMap[ImGui.Key.PageUp]     = xx PAGE_UP;
    io.KeyMap[ImGui.Key.PageDown]   = xx PAGE_DOWN;
    io.KeyMap[ImGui.Key.Home]       = xx HOME;
    io.KeyMap[ImGui.Key.End]        = xx END;
    io.KeyMap[ImGui.Key.Delete]     = xx DELETE;
    io.KeyMap[ImGui.Key.Backspace]  = xx BACKSPACE;
    io.KeyMap[ImGui.Key.Enter]      = xx ENTER;
    io.KeyMap[ImGui.Key.Escape]     = xx ESCAPE;
    io.KeyMap[ImGui.Key.A]          = xx #char "A";
    io.KeyMap[ImGui.Key.C]          = xx #char "C";
    io.KeyMap[ImGui.Key.V]          = xx #char "V";
    io.KeyMap[ImGui.Key.X]          = xx #char "X";
    io.KeyMap[ImGui.Key.Y]          = xx #char "Y";
    io.KeyMap[ImGui.Key.Z]          = xx #char "Z";
}

#scope_file
Input :: #import "Input";
ImGui :: #import "imgui";
