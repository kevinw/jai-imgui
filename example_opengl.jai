#import "Window_Creation";
#import "Input";
#import "GL";
#import "Basic";
#import "Render";
#import "Basic";

#scope_file
#if OS == .WINDOWS {
	#import "Windows";
}
#scope_module

#import "imgui_impl_gl";

state: struct {
    ui: UI_State;

    quit: bool;
    demo_window_open: bool = true;
};

mouse_did_move := false;

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
        mouse_did_move = true;
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

manual_redraws := 2;

frame :: (window: Window_Type) -> did_render: bool {
    need_to_render := false;

    for events_this_frame {
        need_to_render |= ImGui_Impl_ProcessEvent(*state.ui, it);
        if it.type == {
            case .QUIT;
                state.quit = true;
        }
    }

    need_to_render |= mouse_did_move;
    mouse_did_move = false;

    if manual_redraws > 0 {
        manual_redraws -= 1;
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

_imgui_alloc_context: Context;

c_alloc :: (sz: u64, userdata: *void) -> *void #c_call {
    push_context << cast(*Context)userdata { return alloc(cast(s64)sz); }
}

c_free :: (ptr: *void, userdata: *void) #c_call {
    push_context << cast(*Context)userdata { free(ptr); }
}

main :: () {
    window := create_window(1200, 800, "ImGui OpenGL Test");
    setup_mousemove_hook();

    gl_create_context(window, 3, 2);
    gl_load(*gl);

    _imgui_alloc_context = context;
    ImGui.SetAllocatorFunctions(c_alloc, c_free, *_imgui_alloc_context);
    ImGui_Impl_CreateContext(*state.ui);
    ImGui.StyleColorsDark();
    ImGui_Impl_Init(*state.ui, window);

    while !state.quit {
        update_window_events();
        reset_temporary_storage();
        if frame(window)
            swap_buffers(window);
    }

    print("OK!\n");
}

