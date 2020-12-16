//
// This is a non-graphical example program using the ImGui library from Jai.
//

ImGui :: #import "imgui"(LINK_STATIC=true);
#import "Basic";

imgui_alloc_context: Context;

c_alloc :: (sz: u64, userdata: *void) -> *void #c_call {
    push_context << cast(*Context)userdata { return alloc(cast(s64)sz); }
}

c_free :: (ptr: *void, userdata: *void) #c_call {
    push_context << cast(*Context)userdata { free(ptr); }
}

main :: () {
    // Have ImGui use our context's allocator.
    imgui_alloc_context = context;
    ImGui.SetAllocatorFunctions(c_alloc, c_free, *imgui_alloc_context);

    // Create the ImGui "context," which stores all the library's internal state.
    ctx := ImGui.CreateContext();
    defer ImGui.DestroyContext(ctx);

    io := ImGui.GetIO();
    tex_w, tex_h: s32;
    tex_pixels: *u8;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *tex_pixels, *tex_w, *tex_h);

    f: float;

    for n: 0..20-1 {
        print("NewFrame() %\n", n);
        io.DisplaySize = ImGui.ImVec2.{1920, 1080};
        io.DeltaTime = 1.0 / 60.0;
        ImGui.NewFrame();

        ImGui.Text("Hello, world!");
        ImGui.SliderFloat("float", *f, 0, 1);
        ImGui.Text("Application average %.3f ms/frame (%.1f FPS)", 1000.0 / io.Framerate, io.Framerate);
        ImGui.ShowDemoWindow(null);

        ImGui.Render();
    }

    print("OK!\n");
}

