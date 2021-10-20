//
// A basic example showing the ImGui demo window using
// Jai's Window_Creation module and OpenGL.
//

ImGui :: #import "imgui"()(LINK_STATIC=true);

state: struct {
    ui: UI_State;

    quit: bool;
    demo_window_open: bool = true;
    mouse_did_move := false;
    manual_redraws := 2;
};

frame :: (window: Window_Type) -> did_render: bool {
    need_to_render := false;

    for events_this_frame {
        need_to_render |= ImGui_Impl_ProcessEvent(*state.ui, it);
        if it.type == {
            case .QUIT;
                state.quit = true;
        }
    }

    need_to_render |= state.mouse_did_move;
    state.mouse_did_move = false;

    if state.manual_redraws > 0 {
        state.manual_redraws -= 1;
        need_to_render = true;
    }

    if need_to_render
        render(window);

    return need_to_render;
}

render :: (window: Window_Type) {
    w, h := get_window_size(window);

    ImGui_Impl_NewFrame(*state.ui, window, w, h);
    if state.demo_window_open
        ImGui.ShowDemoWindow(*state.demo_window_open);
    ImGui.Render();

    glViewport(0, 0, xx w, xx h);
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    ImGui_Impl_RenderDrawData(*state.ui, ImGui.GetDrawData());
}

main :: () {
    window := create_window(1200, 800, "ImGui OpenGL Test");
    setup_mousemove_hook();

    gl_create_context(window, 3, 2);
    gl_load(*gl);

    ImGui_Impl_CreateContext(*state.ui, set_default_allocators=true);
    ImGui.StyleColorsLight();
    ImGui_Impl_Init(*state.ui, window);

    while !state.quit {
        update_window_events();
        reset_temporary_storage();
        if frame(window)
            swap_buffers(window);
    }

    print("OK!\n");
}

get_window_size :: (window: Window_Type) -> s32, s32 {
    #if OS == .WINDOWS {
        rect: RECT;
        GetClientRect(window, *rect);
        return rect.right, rect.bottom;
    }
}

#if OS == .WINDOWS {
    // Jai's stdlib lacks mouse move events. Install a Windows "Hook" and catch them.
    //
    // Hopefully in the future it will be easier to provide custom WindowProc functionality
    // through Jai's windows impl.
    HHOOK :: HANDLE;
    HOOKPROC :: #type (code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #c_call;
    WH_MOUSE :: 7;
    user32 :: #foreign_system_library "user32";

    CallNextHookEx    :: (hhk: HHOOK, code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #foreign user32;
    SetWindowsHookExA :: (id_hook: s32, hook_fn: HOOKPROC, hmod: HINSTANCE, thread_id: DWORD) -> HHOOK #foreign user32;

    HookProc :: (code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #c_call {
        state.mouse_did_move = true;
        return CallNextHookEx(null, code, wparam, lparam);
    }

    hook: HHOOK;

    setup_mousemove_hook :: () {
        if SetWindowsHookExA(WH_MOUSE, HookProc, null, GetCurrentThreadId()) == null {
            print("SetWindowsHookExA error: %\n", GetLastError());
            assert(false);
        }
    }
}

#scope_file
#import "imgui_impl_gl"; // note this #imports ImGui for us

#import "Window_Creation";
#import "Input";
#import "GL";
#import "Basic";
#if OS == .WINDOWS #import "Windows";

