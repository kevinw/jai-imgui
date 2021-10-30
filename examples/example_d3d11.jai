//
// A basic example showing the ImGui demo window using
// Jai's Window_Creation module and Direct3D 11.
//

DEBUG :: true;

ImGui :: #import "imgui"()(LINK_STATIC=true);

driver_type := D3D_DRIVER_TYPE_NULL;
feature_level := D3D_FEATURE_LEVEL_11_0;
d3d_device         : *ID3D11Device;
d3d_context        : *ID3D11DeviceContext;
swap_chain         : *IDXGISwapChain;
render_target_view : *ID3D11RenderTargetView;

init_device :: (hwnd: HWND) -> bool { // thanks to Jai's examples\d3d11_example\d3d11_example.jai
    hr : HRESULT = S_OK; 
 
    flags : D3D11_CREATE_DEVICE_FLAGS; 
    #if DEBUG flags |= D3D11_CREATE_DEVICE_DEBUG;
 
    driver_types   := D3D_DRIVER_TYPE.[D3D_DRIVER_TYPE_HARDWARE, D3D_DRIVER_TYPE_WARP, D3D_DRIVER_TYPE_REFERENCE];
    feature_levels := D3D_FEATURE_LEVEL.[D3D_FEATURE_LEVEL_11_1, D3D_FEATURE_LEVEL_11_0, D3D_FEATURE_LEVEL_10_1, D3D_FEATURE_LEVEL_10_0];
 
    for 0..driver_types.count-1 {

        driver_type = driver_types[it]; 
        hr = D3D11CreateDevice(null, driver_type, null, flags, feature_levels.data, feature_levels.count, D3D11_SDK_VERSION, *d3d_device, *feature_level, *d3d_context);
 
        if hr == E_INVALIDARG {
            // DirectX 11.0 platforms will not recognize D3D_FEATURE_LEVEL_11_1 so we need to retry without it.
            hr = D3D11CreateDevice(null, driver_type, null, flags, feature_levels.data + 1, feature_levels.count - 1, D3D11_SDK_VERSION, *d3d_device, *feature_level, *d3d_context);
        }
 
        if SUCCEEDED(hr) break;
    } 
    if FAILED(hr) {
        print("D3D11CreateDevice failed.\n");
        return false;
    }

    assert(d3d_device != null);
    print("Created D3D11 device % with feature level %\n", d3d_device, feature_level);


    // Obtain DXGI factory from device (since we used null for pAdapter above) 
    dxgi_factory : *IDXGIFactory1;
    {
        dxgi_device : *IDXGIDevice;
        hr = d3d_device.QueryInterface(xx d3d_device, *uid(IDXGIDevice.uuid), xx *dxgi_device); 
        if SUCCEEDED(hr) {
            adapter : *IDXGIAdapter;
            hr = dxgi_device.GetAdapter(dxgi_device, *adapter);
            if SUCCEEDED(hr) {
                hr = adapter.GetParent(xx adapter, *uid(IDXGIFactory1.uuid), xx *dxgi_factory); 
                adapter.Release(xx adapter); 
            } 
            dxgi_device.Release(xx dxgi_device); 
        }
        else {
            print("QueryInterface FAILED\n");
        }
    }
    if FAILED(hr) {
        print("GetAdapter failed.\n");
        return false;
    }

    print("Create swap chain\n");

    rc : RECT;
    GetClientRect(hwnd, *rc); 
    width := rc.right - rc.left; 
    height := rc.bottom - rc.top; 

    // Create swap chain 
    /*dxgi_factory2 : *IDXGIFactory2;
    hr = dxgi_factory.QueryInterface(xx dxgi_factory, *uid(IDXGIFactory2.uuid), xx *dxgi_factory2); 
    if dxgi_factory2 {
        // DirectX 11.1 or later 
        hr = d3d_device.QueryInterface(xx d3d_device, *uid(ID3D11Device1.uuid), xx *d3d_device1); 
        if SUCCEEDED(hr) {
            d3d_context.QueryInterface(xx d3d_context, *uid(ID3D11DeviceContext1.uuid), xx *d3d_context); 
        } 
 
        sd : DXGI_SWAP_CHAIN_DESC1; 
        sd.Width = width; 
        sd.Height = height; 
        sd.Format = DXGI_FORMAT_R8G8B8A8_UNORM; 
        sd.SampleDesc.Count = 1; 
        sd.SampleDesc.Quality = 0; 
        sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT; 
        sd.BufferCount = 1; 
 
        hr = dxgi_factory2.CreateSwapChainForHwnd(dxgi_factory2, d3d_device, hwnd, *sd, null, null, *swap_chain1 ); 
        if SUCCEEDED(hr) {
            hr = swap_chain1.QueryInterface(xx swap_chain1, *uid(IDXGISwapChain.uuid), *swap_chain); 
        } 
 
        dxgi_factory2.Release(xx dxgi_factory2); 
    } 
    else*/ {
        // DirectX 11.0 systems 
        sd : DXGI_SWAP_CHAIN_DESC; 
        sd.BufferCount = 1; 
        sd.BufferDesc.Width = xx width; 
        sd.BufferDesc.Height = xx height; 
        sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM; 
        sd.BufferDesc.RefreshRate.Numerator = 60; 
        sd.BufferDesc.RefreshRate.Denominator = 1; 
        sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT; 
        sd.OutputWindow = hwnd; 
        sd.SampleDesc.Count = 1; 
        sd.SampleDesc.Quality = 0; 
        sd.Windowed = BOOL.TRUE; 
 
        hr = dxgi_factory.CreateSwapChain(xx dxgi_factory, xx d3d_device, *sd, *swap_chain); 
    } 
 
    // Note this tutorial doesn't handle full-screen swapchains so we block the ALT+ENTER shortcut 
    dxgi_factory.MakeWindowAssociation(xx dxgi_factory, hwnd, DXGI_MWA_NO_ALT_ENTER); 
    dxgi_factory.Release(xx dxgi_factory); 
 
    if FAILED(hr) return false;
    
 
    print("Create a render target view\n");

    back_buffer : *ID3D11Texture2D; 
    hr = swap_chain.GetBuffer(swap_chain, 0, *uid(ID3D11Texture2D.uuid), xx *back_buffer); 
    if FAILED( hr ) return false;
 
    hr = d3d_device.CreateRenderTargetView(d3d_device, xx back_buffer, null, *render_target_view); 
    back_buffer.Release(xx back_buffer); 
    if FAILED(hr) return false;
 
    d3d_context.OMSetRenderTargets(d3d_context, 1, *render_target_view, null); 
    
    print("Setup the viewport\n");

    vp : D3D11_VIEWPORT; 
    vp.Width = xx width; 
    vp.Height = xx height; 
    vp.MinDepth = 0.0;
    vp.MaxDepth = 1.0;
    vp.TopLeftX = 0;
    vp.TopLeftY = 0;
    d3d_context.RSSetViewports(d3d_context, 1, *vp);

    return true; 
} 

state: struct {
    ui: UI_State;
    quit: bool;
    demo_window_open: bool = true;
};

frame :: (window: Window_Type) {
    ImGui_Impl_ProcessInputEvents(*state.ui, events_this_frame);

    for events_this_frame {
        if it.type == {
            case .QUIT;
                state.quit = true;

        }
    }

    w, h := get_window_size(window);
    ImGui_Impl_NewFrame(*state.ui, window, w, h);
    if state.demo_window_open
        ImGui.ShowDemoWindow(*state.demo_window_open);
    ImGui.Render();
    ImGui_Impl_RenderDrawData(*state.ui, ImGui.GetDrawData());
}

main :: () {
    window := create_window(1200, 800, "ImGui Direct3D 11 Test");
    device_init_succeeded := init_device(window);
    assert(device_init_succeeded);

    ui := *state.ui;
    ui.d3dDevice = d3d_device;
    ui.d3dDeviceContext = d3d_context;

    ImGui_Impl_CreateContext(ui);
    ImGui.StyleColorsDark();
    ImGui_Impl_Init(ui, window);
    ImGui_Impl_SetupInputModuleKeymap(ui);

    while !state.quit {
        reset_temporary_storage();
        update_window_events();
        frame(window);
        swap_chain.Present(cast(*IDXGISwapChain)swap_chain, 1, 0);
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

#scope_file
#import "d3d11";
#import "dxgi";
#import "imgui_impl_d3d11";
#import "Window_Creation";
#import "Input";
#import "Basic";
#if OS == .WINDOWS #import "Windows";

