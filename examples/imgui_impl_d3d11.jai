// thanks https://raw.githubusercontent.com/ocornut/imgui/master/backends/imgui_impl_dx11.cpp

UI_State :: struct {
    using ui_state_base: UI_State_Base;

    // win32
    LastMouseCursor:      ImGui.MouseCursor;
    hook: HHOOK;

    // d3d11

    d3dDevice:            *ID3D11Device;
    d3dDeviceContext:     *ID3D11DeviceContext;
    Factory:              *IDXGIFactory;
    VB:                   *ID3D11Buffer;
    IB:                   *ID3D11Buffer;
    VertexShader:         *ID3D11VertexShader;
    InputLayout:          *ID3D11InputLayout;
    VertexConstantBuffer: *ID3D11Buffer;
    PixelShader:          *ID3D11PixelShader;
    FontSampler:          *ID3D11SamplerState;
    FontTextureView:      *ID3D11ShaderResourceView;
    RasterizerState:      *ID3D11RasterizerState;
    BlendState:           *ID3D11BlendState;
    DepthStencilState:    *ID3D11DepthStencilState;
    VertexBufferSize: s32 = 5000;
    IndexBufferSize:  s32 = 10000;
}

VERTEX_CONSTANT_BUFFER :: struct {
    mvp: [4][4]float;
}


ImGui_ImplDX11_SetupRenderState :: (using ui_state: *UI_State, draw_data: *ImDrawData) {
    d_ctx := ui_state.d3dDeviceContext;

    // Setup viewport
    vp: D3D11_VIEWPORT;
    vp.Width = draw_data.DisplaySize.x;
    vp.Height = draw_data.DisplaySize.y;
    vp.MinDepth = 0.0;
    vp.MaxDepth = 1.0;
    vp.TopLeftX = 0;
    vp.TopLeftY = 0;
    d_ctx.RSSetViewports(d_ctx, 1, *vp);

    // Setup shader and vertex buffers
    stride:u32 = size_of(ImDrawVert);
    offset:u32;
    d_ctx.IASetInputLayout(d_ctx, InputLayout);
    d_ctx.IASetVertexBuffers(d_ctx, 0, 1, *VB, *stride, *offset);
    idx_buf_type := ifx size_of(ImDrawIdx) == 2 then DXGI_FORMAT_R16_UINT else DXGI_FORMAT_R32_UINT;
    d_ctx.IASetIndexBuffer(d_ctx, IB, idx_buf_type, 0);
    d_ctx.IASetPrimitiveTopology(d_ctx, D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    d_ctx.VSSetShader(d_ctx, VertexShader, null, 0);
    d_ctx.VSSetConstantBuffers(d_ctx, 0, 1, *VertexConstantBuffer);
    d_ctx.PSSetShader(d_ctx, PixelShader, null, 0);
    d_ctx.PSSetSamplers(d_ctx, 0, 1, *FontSampler);
    d_ctx.GSSetShader(d_ctx, null, null, 0);
    d_ctx.HSSetShader(d_ctx, null, null, 0); // In theory we should backup and restore this as well.. very infrequently used..
    d_ctx.DSSetShader(d_ctx, null, null, 0); // In theory we should backup and restore this as well.. very infrequently used..
    d_ctx.CSSetShader(d_ctx, null, null, 0); // In theory we should backup and restore this as well.. very infrequently used..

    // Setup blend state
    blend_factor : [4]float = .[0, 0, 0, 0];
    d_ctx.OMSetBlendState(d_ctx, BlendState, *blend_factor, 0xffffffff);
    d_ctx.OMSetDepthStencilState(d_ctx, DepthStencilState, 0);
    d_ctx.RSSetState(d_ctx, RasterizerState);
}

ImGui_Impl_RenderDrawData :: (using ui_state: *UI_State, draw_data: *ImGui.ImDrawData) -> bool {
    // Avoid rendering when minimized
    if draw_data.DisplaySize.x <= 0 || draw_data.DisplaySize.y <= 0
        return false;

    d_ctx := ui_state.d3dDeviceContext;

    // Create and grow vertex/index buffers if needed
    if !VB || VertexBufferSize < draw_data.TotalVtxCount {
        if VB != null { VB.Release(xx VB); VB = null; }
        VertexBufferSize = draw_data.TotalVtxCount + 5000;
        desc := D3D11_BUFFER_DESC.{
            Usage          = .D3D11_USAGE_DYNAMIC,
            BindFlags      = .D3D11_BIND_VERTEX_BUFFER,
            CPUAccessFlags = .D3D11_CPU_ACCESS_WRITE,
        };
        desc.ByteWidth = cast(u32)(VertexBufferSize * size_of(ImDrawVert));
        if d3dDevice.CreateBuffer(d3dDevice, *desc, null, *VB) < 0 {
            logprint("imgui_d3d11", "Error creating the vertex buffer");
            return false;
        }
    }

    if !IB || IndexBufferSize < draw_data.TotalIdxCount {
        if IB != null { IB.Release(xx IB); IB = null; }
        IndexBufferSize = draw_data.TotalIdxCount + 10000;
        desc := D3D11_BUFFER_DESC.{
            Usage = .D3D11_USAGE_DYNAMIC,
            BindFlags = .D3D11_BIND_INDEX_BUFFER,
            CPUAccessFlags = .D3D11_CPU_ACCESS_WRITE,
        };
        desc.ByteWidth = cast(u32)(IndexBufferSize * size_of(ImDrawIdx));
        if d3dDevice.CreateBuffer(d3dDevice, *desc, null, *IB) < 0 {
            logprint("imgui_d3d11", "Error creating the index buffer");
            return false;
        }
    }

    // Upload vertex/index data into a single contiguous GPU buffer
    vtx_resource, idx_resource: D3D11_MAPPED_SUBRESOURCE;
    if d_ctx.Map(xx d_ctx, xx VB, 0, .D3D11_MAP_WRITE_DISCARD, 0, *vtx_resource) != S_OK
        return false;
    if d_ctx.Map(xx d_ctx, xx IB, 0, .D3D11_MAP_WRITE_DISCARD, 0, *idx_resource) != S_OK
        return false;

    vtx_dst := cast(*ImDrawVert)vtx_resource.pData;
    idx_dst := cast(*ImDrawIdx)idx_resource.pData;
    for n: 0..draw_data.CmdListsCount - 1 {
        cmd_list := draw_data.CmdLists[n];
        memcpy(vtx_dst, cmd_list.VtxBuffer.Data, cmd_list.VtxBuffer.Size * size_of(ImDrawVert));
        memcpy(idx_dst, cmd_list.IdxBuffer.Data, cmd_list.IdxBuffer.Size * size_of(ImDrawIdx));
        vtx_dst += cmd_list.VtxBuffer.Size;
        idx_dst += cmd_list.IdxBuffer.Size;
    }
    d_ctx.Unmap(xx d_ctx, xx VB, 0);
    d_ctx.Unmap(xx d_ctx, xx IB, 0);

    // Setup orthographic projection matrix into our constant buffer
    // Our visible imgui space lies from draw_data.DisplayPos (top left) to draw_data.DisplayPos+data_data.DisplaySize (bottom right). DisplayPos is (0,0) for single viewport apps.
    {
        mapped_resource: D3D11_MAPPED_SUBRESOURCE;
        if d_ctx.Map(xx d_ctx, xx VertexConstantBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, *mapped_resource) != S_OK
            return false;

        constant_buffer := cast(*VERTEX_CONSTANT_BUFFER)mapped_resource.pData;
        L:float = draw_data.DisplayPos.x;
        R:float = draw_data.DisplayPos.x + draw_data.DisplaySize.x;
        T:float = draw_data.DisplayPos.y;
        B:float = draw_data.DisplayPos.y + draw_data.DisplaySize.y;
        make_float4 :: (a: float, b: float, c: float, d: float) -> [4]float {
            f: [4]float = ---;
            f[0] = a;
            f[1] = b;
            f[2] = c;
            f[3] = d;
            return f;
        }
        mvp: [4][4]float;
        mvp[0] = make_float4(2.0/(R-L),   0.0,           0.0,       0.0 );
        mvp[1] = make_float4(0.0,         2.0/(T-B),     0.0,       0.0 );
        mvp[2] = make_float4(0.0,         0.0,           0.5,       0.0 );
        mvp[3] = make_float4((R+L)/(L-R),  (T+B)/(B-T),  0.5,       1.0 );
        memcpy(*constant_buffer.mvp, mvp[0].data, size_of(type_of(mvp)));
        d_ctx.Unmap(xx d_ctx, xx VertexConstantBuffer, 0);
    }

    // Backup DX state that will be modified to restore it afterwards (unfortunately this is very ugly looking and verbose. Close your eyes!)
    BACKUP_DX11_STATE :: struct {
        ScissorRectsCount: u32;
        ViewportsCount: u32;
        ScissorRects: [D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE]D3D11_RECT;
        Viewports: [D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE]D3D11_VIEWPORT;
        RS: *ID3D11RasterizerState;
        BlendState: *ID3D11BlendState;
        BlendFactor: [4]float;
        SampleMask: u32;
        StencilRef: u32;
        DepthStencilState: *ID3D11DepthStencilState;
        PSShaderResource: *ID3D11ShaderResourceView;
        PSSampler: *ID3D11SamplerState;
        PS: *ID3D11PixelShader;
        VS: *ID3D11VertexShader;
        GS: *ID3D11GeometryShader;
        PSInstancesCount: u32;
        VSInstancesCount: u32;
        GSInstancesCount: u32;
        PSInstances: [256]*ID3D11ClassInstance;
        VSInstances: [256]*ID3D11ClassInstance;
        GSInstances: [256]*ID3D11ClassInstance;   // 256 is max according to PSSetShader documentation
        PrimitiveTopology: D3D11_PRIMITIVE_TOPOLOGY;
        IndexBuffer: *ID3D11Buffer;
        VertexBuffer: *ID3D11Buffer;
        VSConstantBuffer: *ID3D11Buffer;
        IndexBufferOffset: u32;
        VertexBufferStride: u32;
        VertexBufferOffset: u32;
        IndexBufferFormat: DXGI_FORMAT;
        InputLayout: *ID3D11InputLayout;
    };

    old: BACKUP_DX11_STATE;
    old.ScissorRectsCount = D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE;
    old.ViewportsCount = D3D11_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE;
    d_ctx.RSGetScissorRects(d_ctx, *old.ScissorRectsCount, old.ScissorRects.data);
    d_ctx.RSGetViewports(d_ctx, *old.ViewportsCount, old.Viewports.data);
    d_ctx.RSGetState(d_ctx, *old.RS);
    d_ctx.OMGetBlendState(d_ctx, *old.BlendState, *old.BlendFactor, *old.SampleMask);
    d_ctx.OMGetDepthStencilState(d_ctx, *old.DepthStencilState, *old.StencilRef);
    d_ctx.PSGetShaderResources(d_ctx, 0, 1, *old.PSShaderResource);
    d_ctx.PSGetSamplers(d_ctx, 0, 1, *old.PSSampler);
    old.PSInstancesCount = 256;
    old.VSInstancesCount = 256;
    old.GSInstancesCount = 256;
    d_ctx.PSGetShader(d_ctx, *old.PS, old.PSInstances.data, *old.PSInstancesCount);
    d_ctx.VSGetShader(d_ctx, *old.VS, old.VSInstances.data, *old.VSInstancesCount);
    d_ctx.VSGetConstantBuffers(d_ctx, 0, 1, *old.VSConstantBuffer);
    d_ctx.GSGetShader(d_ctx, *old.GS, old.GSInstances.data, *old.GSInstancesCount);

    d_ctx.IAGetPrimitiveTopology(d_ctx, *old.PrimitiveTopology);
    d_ctx.IAGetIndexBuffer(d_ctx, *old.IndexBuffer, *old.IndexBufferFormat, *old.IndexBufferOffset);
    d_ctx.IAGetVertexBuffers(d_ctx, 0, 1, *old.VertexBuffer, *old.VertexBufferStride, *old.VertexBufferOffset);
    d_ctx.IAGetInputLayout(d_ctx, *old.InputLayout);

    // Setup desired DX state
    ImGui_ImplDX11_SetupRenderState(ui_state, draw_data);

    // Render command lists
    // (Because we merged all buffers into a single one, we maintain our own offset into them)
    global_idx_offset:u32;
    global_vtx_offset:u32;
    clip_off := draw_data.DisplayPos;
    for n: 0..draw_data.CmdListsCount - 1 {
        cmd_list := draw_data.CmdLists[n];
        for cmd_i: 0..cmd_list.CmdBuffer.Size - 1 {
            pcmd := *cmd_list.CmdBuffer.Data[cmd_i];
            if pcmd.UserCallback != null {
                // User callback, registered via ImDrawList::AddCallback()
                // (ImDrawCallback_ResetRenderState is a special callback value used by the user to request the renderer to reset render state.)
                ImDrawCallback_ResetRenderState :: -1;
                if cast(int)cast(*void)pcmd.UserCallback == ImDrawCallback_ResetRenderState
                    ImGui_ImplDX11_SetupRenderState(ui_state, draw_data);
                else
                    pcmd.UserCallback(cmd_list, pcmd);
            } else {
                // Apply scissor/clipping rectangle
                r: D3D11_RECT;
                r.left   = cast(s32)(pcmd.ClipRect.x - clip_off.x);
                r.top    = cast(s32)(pcmd.ClipRect.y - clip_off.y);
                r.right  = cast(s32)(pcmd.ClipRect.z - clip_off.x);
                r.bottom = cast(s32)(pcmd.ClipRect.w - clip_off.y);
                d_ctx.RSSetScissorRects(d_ctx, 1, *r);

                // Bind texture, Draw
                texture_srv := cast(*ID3D11ShaderResourceView)pcmd.TextureId;
                d_ctx.PSSetShaderResources(d_ctx, 0, 1, *texture_srv);
                d_ctx.DrawIndexed(d_ctx, pcmd.ElemCount, pcmd.IdxOffset + global_idx_offset, cast(s32)(pcmd.VtxOffset + global_vtx_offset));
            }
        }
        global_idx_offset += cast(u32)cmd_list.IdxBuffer.Size;
        global_vtx_offset += cast(u32)cmd_list.VtxBuffer.Size;
    }

    // Restore modified DX state
    d_ctx.RSSetScissorRects(d_ctx, old.ScissorRectsCount, old.ScissorRects.data);
    d_ctx.RSSetViewports(d_ctx, old.ViewportsCount, old.Viewports.data);
    d_ctx.RSSetState(d_ctx, old.RS); Release(old.RS);
    d_ctx.OMSetBlendState(d_ctx, old.BlendState, *old.BlendFactor, old.SampleMask); Release(old.BlendState);
    d_ctx.OMSetDepthStencilState(d_ctx, old.DepthStencilState, old.StencilRef); Release(old.DepthStencilState);
    d_ctx.PSSetShaderResources(d_ctx, 0, 1, *old.PSShaderResource); Release(old.PSShaderResource);
    d_ctx.PSSetSamplers(d_ctx, 0, 1, *old.PSSampler); Release(old.PSSampler);
    d_ctx.PSSetShader(d_ctx, old.PS, old.PSInstances.data, old.PSInstancesCount); Release(old.PS);
    if old.PSInstancesCount > 0
        for i: 0..old.PSInstancesCount - 1
            Release(old.PSInstances[i]);
    d_ctx.VSSetShader(d_ctx, old.VS, old.VSInstances.data, old.VSInstancesCount); Release(old.VS);
    d_ctx.VSSetConstantBuffers(d_ctx, 0, 1, *old.VSConstantBuffer); Release(old.VSConstantBuffer);
    d_ctx.GSSetShader(d_ctx, old.GS, old.GSInstances.data, old.GSInstancesCount); Release(old.GS);
    if old.VSInstancesCount > 0
        for i: 0..old.VSInstancesCount - 1
            Release(old.VSInstances[i]);
    d_ctx.IASetPrimitiveTopology(d_ctx, old.PrimitiveTopology);
    d_ctx.IASetIndexBuffer(d_ctx, old.IndexBuffer, old.IndexBufferFormat, old.IndexBufferOffset); Release(old.IndexBuffer);
    d_ctx.IASetVertexBuffers(d_ctx, 0, 1, *old.VertexBuffer, *old.VertexBufferStride, *old.VertexBufferOffset); Release(old.VertexBuffer);
    d_ctx.IASetInputLayout(d_ctx, old.InputLayout); Release(old.InputLayout);

    return true;
}

ImGui_ImplDX11_CreateFontsTexture :: (using ui_state: *UI_State) {
    // Build texture atlas
    io := ImGui.GetIO();
    pixels: *u8;
    width, height: s32;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *width, *height);

    // Upload texture to graphics system
    {
        desc := D3D11_TEXTURE2D_DESC.{
            MipLevels = 1,
            ArraySize = 1,
            Format    = .DXGI_FORMAT_R8G8B8A8_UNORM,
            Usage     = .D3D11_USAGE_DEFAULT,
            BindFlags = .D3D11_BIND_SHADER_RESOURCE,
        };
        desc.Width  = cast(u32)width;
        desc.Height = cast(u32)height;
        desc.SampleDesc.Count = 1;

        pTexture: *ID3D11Texture2D;
        subResource: D3D11_SUBRESOURCE_DATA;
        subResource.pSysMem = pixels;
        subResource.SysMemPitch = desc.Width * 4;
        subResource.SysMemSlicePitch = 0;
        d3dDevice.CreateTexture2D(d3dDevice, *desc, *subResource, *pTexture);

        // Create texture view
        srvDesc: D3D11_SHADER_RESOURCE_VIEW_DESC ;
        srvDesc.Format = .DXGI_FORMAT_R8G8B8A8_UNORM;
        srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
        srvDesc.Texture2D.MipLevels = desc.MipLevels;
        srvDesc.Texture2D.MostDetailedMip = 0;
        d3dDevice.CreateShaderResourceView(d3dDevice, xx pTexture, *srvDesc, *FontTextureView);
        Release(pTexture);
    }

    // Store our identifier
    io.Fonts.TexID = cast(ImTextureID)FontTextureView;

    // Create texture sampler
    {
        desc := D3D11_SAMPLER_DESC.{
            Filter = .D3D11_FILTER_MIN_MAG_MIP_LINEAR,
            AddressU = .D3D11_TEXTURE_ADDRESS_WRAP,
            AddressV = .D3D11_TEXTURE_ADDRESS_WRAP,
            AddressW = .D3D11_TEXTURE_ADDRESS_WRAP,
            ComparisonFunc = .D3D11_COMPARISON_ALWAYS,
        };
        d3dDevice.CreateSamplerState(d3dDevice, *desc, *FontSampler);
    }
}

ImGui_ImplDX11_CreateDeviceObjects :: (using ui_state: *UI_State) -> bool {
    if !d3dDevice return false;
    if ui_state.FontSampler ImGui_ImplDX11_InvalidateDeviceObjects(ui_state);

    // By using D3DCompile() from <d3dcompiler.h> / d3dcompiler.lib, we introduce a dependency to a given version of d3dcompiler_XX.dll (see D3DCOMPILER_DLL_A)
    // If you would like to use this DX11 sample code but remove this dependency you can:
    //  1) compile once, save the compiled shader blobs into a file or source code and pass them to CreateVertexShader()/CreatePixelShader() [preferred solution]
    //  2) use code to detect any version of the DLL and grab a pointer to D3DCompile from the DLL.
    // See https://github.com/ocornut/imgui/pull/638 for sources and details.

    // Create the vertex shader
    {
        vertexShader :: #string END
cbuffer vertexBuffer : register(b0)
{
  float4x4 ProjectionMatrix;
};
struct VS_INPUT
{
  float2 pos : POSITION;
  float4 col : COLOR0;
  float2 uv  : TEXCOORD0;
};

struct PS_INPUT
{
  float4 pos : SV_POSITION;
  float4 col : COLOR0;
  float2 uv  : TEXCOORD0;
};

PS_INPUT main(VS_INPUT input)
{
  PS_INPUT output;
  output.pos = mul( ProjectionMatrix, float4(input.pos.xy, 0.f, 1.f));
  output.col = input.col;
  output.uv  = input.uv;
  return output;
}
END;

#if GRAPHICS_LAYER_DEBUG {
        vertexShaderBlob: *ID3DBlob;
        logprint("imgui_d3d11", "compiling imgui shader % (%)", "main", "vs_4_0");
        if S_OK != D3DCompile(vertexShader.data, vertexShader.count, null, null, null, "main", "vs_4_0", 0, 0, *vertexShaderBlob, null)
            return false; // NB: Pass ID3DBlob* pErrorBlob to D3DCompile() to get error showing in (const char*)pErrorBlob->GetBufferPointer(). Make sure to Release() the blob!
        defer Release(vertexShaderBlob);

        blob_data := vertexShaderBlob.GetBufferPointer(vertexShaderBlob);
        blob_size := vertexShaderBlob.GetBufferSize(vertexShaderBlob);
} else {
        blob :: #run run_fxc_on_string(vertexShader, .Vertex, "vs_4_0", "main");
        blob_data := blob.data;
        blob_size := cast(u64)blob.count;
}

        if d3dDevice.CreateVertexShader(d3dDevice, blob_data, blob_size, null, *VertexShader) != S_OK
            return false;

        // TODO: detect #define IMGUI_USE_BGRA_PACKED_COLOR or not and use BGRA or RGBA as necessary...
        // the imgui bindings should probably have a constant for this.

        // Create the input layout
        local_layout := D3D11_INPUT_ELEMENT_DESC.[
            .{ "POSITION", 0, .DXGI_FORMAT_R32G32_FLOAT,   0, cast(u32)#run offset_of(ImDrawVert, "pos"), .D3D11_INPUT_PER_VERTEX_DATA, 0 },
            .{ "TEXCOORD", 0, .DXGI_FORMAT_R32G32_FLOAT,   0, cast(u32)#run offset_of(ImDrawVert, "uv"),  .D3D11_INPUT_PER_VERTEX_DATA, 0 },
            .{ "COLOR",    0, .DXGI_FORMAT_B8G8R8A8_UNORM, 0, cast(u32)#run offset_of(ImDrawVert, "col"), .D3D11_INPUT_PER_VERTEX_DATA, 0 },
        ];
        if d3dDevice.CreateInputLayout(d3dDevice, local_layout.data, local_layout.count, blob_data, blob_size, *InputLayout) != S_OK
            return false;

        // Create the constant buffer
        {
            desc := D3D11_BUFFER_DESC.{
                Usage          = .D3D11_USAGE_DYNAMIC,
                BindFlags      = .D3D11_BIND_CONSTANT_BUFFER,
                CPUAccessFlags = .D3D11_CPU_ACCESS_WRITE,
                ByteWidth      = size_of(VERTEX_CONSTANT_BUFFER),
            };
            d3dDevice.CreateBuffer(d3dDevice, *desc, null, *VertexConstantBuffer);
        }
    }

    // Create the pixel shader
    {
        pixelShader :: #string END
struct PS_INPUT
{
    float4 pos : SV_POSITION;
    float4 col : COLOR0;
    float2 uv  : TEXCOORD0;
};
sampler sampler0;
Texture2D texture0;

float4 main(PS_INPUT input) : SV_Target
{
    float4 out_col = input.col * texture0.Sample(sampler0, input.uv);
    return out_col;
}
END;

#if GRAPHICS_LAYER_DEBUG {
        pixelShaderBlob: *ID3DBlob;
        logprint("imgui_d3d11", "compiling imgui shader % (%)", "main", "ps_4_0");
        if D3DCompile(pixelShader.data, pixelShader.count, null, null, null, "main", "ps_4_0", 0, 0, *pixelShaderBlob, null) < 0
            return false; // NB: Pass ID3DBlob* pErrorBlob to D3DCompile() to get error showing in (const char*)pErrorBlob->GetBufferPointer(). Make sure to Release() the blob!
        defer Release(pixelShaderBlob);
        blob_data := pixelShaderBlob.GetBufferPointer(pixelShaderBlob);
        blob_size := pixelShaderBlob.GetBufferSize(pixelShaderBlob);
} else {
        blob :: #run run_fxc_on_string(pixelShader, .Fragment, "ps_4_0", "main");
        blob_data := blob.data;
        blob_size := cast(u64)blob.count;
}

        if d3dDevice.CreatePixelShader(d3dDevice, blob_data, blob_size, null, *PixelShader) != S_OK
            return false;
    }

    // Create the blending setup
    {
        desc: D3D11_BLEND_DESC ;
        desc.AlphaToCoverageEnable                 = cast(BOOL)false;
        desc.RenderTarget[0].BlendEnable           = cast(BOOL)true;
        desc.RenderTarget[0].SrcBlend              = .D3D11_BLEND_SRC_ALPHA;
        desc.RenderTarget[0].DestBlend             = .D3D11_BLEND_INV_SRC_ALPHA;
        desc.RenderTarget[0].BlendOp               = .D3D11_BLEND_OP_ADD;
        desc.RenderTarget[0].SrcBlendAlpha         = .D3D11_BLEND_INV_SRC_ALPHA;
        desc.RenderTarget[0].DestBlendAlpha        = .D3D11_BLEND_ZERO;
        desc.RenderTarget[0].BlendOpAlpha          = .D3D11_BLEND_OP_ADD;
        desc.RenderTarget[0].RenderTargetWriteMask = cast(u8)D3D11_COLOR_WRITE_ENABLE_ALL;
        d3dDevice.CreateBlendState(d3dDevice, *desc, *BlendState);
    }

    // Create the rasterizer state
    {
        desc: D3D11_RASTERIZER_DESC;
        desc.FillMode = D3D11_FILL_SOLID;
        desc.CullMode = D3D11_CULL_NONE;
        desc.ScissorEnable = BOOL.TRUE;
        desc.DepthClipEnable = BOOL.TRUE;
        d3dDevice.CreateRasterizerState(d3dDevice, *desc, *RasterizerState);
    }

    // Create depth-stencil State
    {
        desc: D3D11_DEPTH_STENCIL_DESC;
        desc.DepthEnable    = BOOL.FALSE;
        desc.DepthWriteMask = .D3D11_DEPTH_WRITE_MASK_ALL;
        desc.DepthFunc      = .D3D11_COMPARISON_ALWAYS;
        desc.StencilEnable  = BOOL.FALSE;
        desc.FrontFace.StencilFailOp      = .D3D11_STENCIL_OP_KEEP;
        desc.FrontFace.StencilDepthFailOp = .D3D11_STENCIL_OP_KEEP;
        desc.FrontFace.StencilPassOp      = .D3D11_STENCIL_OP_KEEP;
        desc.FrontFace.StencilFunc        = .D3D11_COMPARISON_ALWAYS;
        desc.BackFace = desc.FrontFace;
        d3dDevice.CreateDepthStencilState(d3dDevice, *desc, *DepthStencilState);
    }

    ImGui_ImplDX11_CreateFontsTexture(ui_state);

    return true;
}


ImGui_ImplDX11_InvalidateDeviceObjects :: (using ui_state: *UI_State) {
    if !d3dDevice
        return;

    Release_And_Set_Null(*FontSampler);
    Release_And_Set_Null(*FontTextureView);
    ImGui.GetIO().Fonts.TexID = null; // We copied g_pFontTextureView to io.Fonts->TexID so let's clear that as well.
    Release_And_Set_Null(*IB);
    Release_And_Set_Null(*VB);

    Release_And_Set_Null(*BlendState);
    Release_And_Set_Null(*DepthStencilState);
    Release_And_Set_Null(*RasterizerState);
    Release_And_Set_Null(*PixelShader);
    Release_And_Set_Null(*VertexConstantBuffer);
    Release_And_Set_Null(*InputLayout);
    Release_And_Set_Null(*VertexShader);
}

// Hopefully in the future it will be easier to provide custom WindowProc functionality
// through Jai's windows impl.
HHOOK :: HANDLE;
HOOKPROC :: #type (code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #c_call;

CWPRETSTRUCT :: struct {
    lResult: LRESULT;
    lParam:  LPARAM;
    wParam:  WPARAM;
    message: u32;
    hwnd:    HWND;
}
user32 :: #foreign_system_library "user32";

CallNextHookEx      :: (hhk: HHOOK, code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #foreign user32;
SetWindowsHookExA   :: (id_hook: s32, hook_fn: HOOKPROC, hmod: HINSTANCE, thread_id: DWORD) -> HHOOK #foreign user32;
UnhookWindowsHookEx :: (hhk: HHOOK) -> BOOL #foreign user32;

HookProc :: (code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #c_call {
    HTCLIENT :: 1;
    TRUE :: 1;

    if code >= 0 {

        if wparam == 0 {
            cwp_ret := cast(*CWPRETSTRUCT)lparam;
            if cast,trunc(u16)(cwp_ret.lParam) == HTCLIENT {
                ImGui_ImplWin32_UpdateMouseCursor();
                return TRUE;
            }
        }
    }

    return CallNextHookEx(null, code, wparam, lparam);
}

setup_set_cursor_hook :: (using ui_state: *UI_State) {
    WH_CALLWNDPROCRET :: 12;

    // unhook a previous one
    if hook != null
        if 0 == cast(int)UnhookWindowsHookEx(hook)
            print("Error in UnhookWindowsHookEx: %", GetLastError());

    // hook up the new callback
    hook = SetWindowsHookExA(WH_CALLWNDPROCRET, HookProc, null, GetCurrentThreadId());
    if hook == null
        print("SetWindowsHookExA error: %\n", GetLastError());
}


ImGui_Impl_Init :: (using ui_state: *UI_State, native_window_handle: *void) -> bool {
    // Setup backend capabilities flags
    io := ImGui.GetIO();
    io.BackendRendererName = "imgui_impl_dx11_jai";
    io.BackendFlags_ |= .RendererHasVtxOffset;  // We can honor the ImDrawCmd::VtxOffset field, allowing for large meshes.
    io.BackendFlags_ |= .HasMouseCursors;       // We have mouse cursors

    setup_set_cursor_hook(ui_state);

    // Get factory from device
    pDXGIDevice:   *IDXGIDevice;
    pDXGIAdapter:  *IDXGIAdapter;
    pFactory:      *IDXGIFactory;

    assert(d3dDevice != null, "must set d3dDevice in UI_State before calling ImGui_Impl_Init in the d3d11 backend");
    assert(d3dDeviceContext != null, "must set d3dDeviceContext in UI_State before calling ImGui_Impl_Init in the d3d11 backend");

    if d3dDevice.QueryInterface(xx d3dDevice, *uid(IDXGIDevice.uuid), cast(**void)*pDXGIDevice) == S_OK
        if pDXGIDevice.GetParent(xx pDXGIDevice, *uid(IDXGIAdapter.uuid), cast(**void)*pDXGIAdapter) == S_OK
            if pDXGIAdapter.GetParent(xx pDXGIAdapter, *uid(IDXGIFactory.uuid), cast(**void)*pFactory) == S_OK
            {
                Factory = pFactory;
            }

    assert(Factory != null);

    Release(pDXGIDevice);
    Release(pDXGIAdapter);

    d3dDevice.AddRef(xx d3dDevice);
    d3dDeviceContext.AddRef(xx d3dDeviceContext);

    return true;
}

ImGui_Impl_DidReloadDLL :: (ui_state: *UI_State) {
    setup_set_cursor_hook(ui_state);
}


#if OS == .WINDOWS {

Win32 :: #import "Windows";
last_point: Win32.POINT;
get_client_mouse_pos :: (window: *void) -> (x: s32, y: s32) {
    user32 :: #foreign_system_library "user32";
    MapWindowPoints :: (hwnd1: *void, hwnd2: *void, points: *POINT, point_count: u32) -> s32 #foreign user32;

    assert(window != null);
    
    point: Win32.POINT;
    Win32.GetCursorPos(*point);
    MapWindowPoints(null, window, *point, 1);
    return point.x, point.y;
}

}

ImGui_Impl_NewFrame :: (using ui_state: *UI_State, native_window_handle: *void, display_width: s32, display_height: s32) {
    io := ImGui.GetIO();

    // Setup display size (every frame to accommodate for window resizing)
    io.DisplaySize.x = cast(float)display_width;
    io.DisplaySize.y = cast(float)display_height;
    io.DisplayFramebufferScale = ImGui.ImVec2.{2, 2};

    // Setup time step
    current_time := get_time();
    if Time > 0.0 io.DeltaTime = xx (current_time - Time);
    else io.DeltaTime = (1.0/60.0);
    Time = current_time;

    // Setup inputs
    mx, my := get_client_mouse_pos(native_window_handle);
    io.MousePos = ImGui.make_ImVec2(xx mx, xx my);
    for 0..2 io.MouseDown[it] = MousePressed[it];
    io.MouseWheel = MouseWheel;

    if FontSampler == null
        ImGui_ImplDX11_CreateDeviceObjects(ui_state);

    // Update OS mouse cursor with the cursor requested by imgui
    mouse_cursor := ifx io.MouseDrawCursor then ImGui.MouseCursor.None else ImGui.GetMouseCursor();
    if LastMouseCursor != mouse_cursor {
        LastMouseCursor = mouse_cursor;
        ImGui_ImplWin32_UpdateMouseCursor();
    }


    ImGui.NewFrame();
}

#load "imgui_impl_common.jai";

#scope_file

ImGui_ImplWin32_UpdateMouseCursor :: () -> bool #c_call {
    IDC_ARROW    :: 32512;
    IDC_HAND     :: 32649;
    IDC_IBEAM    :: 32513;
    IDC_NO       :: 32648;
    IDC_SIZEALL  :: 32646;
    IDC_SIZENESW :: 32643;
    IDC_SIZENS   :: 32645;
    IDC_SIZENWSE :: 32642;
    IDC_SIZEWE   :: 32644;

    SetCursor :: (hCursor: HCURSOR) -> HCURSOR #foreign user32;

    io := ImGui.GetIO();
    if io.ConfigFlags_ & .NoMouseCursorChange
        return false;

    imgui_cursor := ImGui.GetMouseCursor();

    if imgui_cursor == .None || io.MouseDrawCursor {
        // Hide OS mouse cursor if imgui is drawing it or if it wants no cursor
        SetCursor(null);
    } else {
        // Show OS mouse cursor
        win32_cursor:s64 = IDC_ARROW;
        if imgui_cursor == {
            case .Arrow;        win32_cursor = IDC_ARROW;
            case .TextInput;    win32_cursor = IDC_IBEAM;
            case .ResizeAll;    win32_cursor = IDC_SIZEALL;
            case .ResizeEW;     win32_cursor = IDC_SIZEWE;
            case .ResizeNS;     win32_cursor = IDC_SIZENS;
            case .ResizeNESW;   win32_cursor = IDC_SIZENESW;
            case .ResizeNWSE;   win32_cursor = IDC_SIZENWSE;
            case .Hand;         win32_cursor = IDC_HAND;
            case .NotAllowed;   win32_cursor = IDC_NO;
        }
        SetCursor(LoadCursorW(null, cast(*u8)win32_cursor));
    }
    return true;
}


ImDrawVert  :: ImGui.ImDrawVert;
ImDrawData  :: ImGui.ImDrawData;
ImDrawIdx   :: ImGui.ImDrawIdx;
ImTextureID :: ImGui.ImTextureID;

Release :: inline (ptr: *$T) {
    if ptr != null
        ptr.Release(cast(*IUnknown)ptr);
}

Release_And_Set_Null :: inline (ptr_address: **$T) {
    assert(ptr_address != null);

    ptr := <<ptr_address;

    if ptr != null {
        ptr.Release(cast(*IUnknown)ptr);
        <<ptr_address = null;
    }
}

offset_of :: ($T: Type, $member: string) -> s64 {
    #insert #run sprint(BODY, member);
    BODY :: #string DONE
        dummy: T = ---;
        return cast(*void) (*dummy.%) - cast(*void) *dummy;
    DONE
}

#import "d3d11";
#import "dxgi";
#import "D3dcompiler";
#import "Windows";

#import "d3d11_shader";
S_OK :: 0;
