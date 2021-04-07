#import "Basic";
#import "Compiler";

#run () {
    opts := get_build_options();
    opts.output_type = .NO_OUTPUT;
    set_build_options(opts);

    #load "jaicpp/jaicpp.jai";
    generate_imgui_bindings();
}();

generate_imgui_bindings :: () {
    imgui_data: ImGui_Bindings_Gen_Data;

    opts: Generate_Bindings_Options;
    {
        using opts;
        array_add(*libpaths,      "./win/dll");
        array_add(*libnames,      "imgui");
        array_add(*include_paths, "./imgui");
        array_add(*source_files,  "./jai-imgui.cpp");
        array_add(*flatten_namespaces, "ImGui");
        strip_prefix             = "ImGui";
        omit_global_declarations = true;
        output_filename          = "imgui.jai";
        user_data                = *imgui_data;
        preamble                 = imgui_preamble;
        print_foreign_library_declarations = false;
        will_print_bindings = () {
            // we'll also walk all the declarations recursively, making some
            // changes. see imgui_visitor below.
            for context.compiler.global_scope.members
                visit_declarations(imgui_visitor, it);
        };
        get_func_args_for_printing = imgui_get_function_arg_for_printing;
    }

    has_error := generate_bindings(opts);
    if !has_error
        show_jaicc_results();
}

ImGui_Bindings_Gen_Data :: struct {
    begin_end_string_args: [..]*Declaration;
}

imgui_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    // ImGui has "typedef ints" for each enum. but we want to just use the enums directly,
    // so we get nice type safety, and .unary dots, etc.
    //
    // Look for declarations inside functions (i.e., arguments) or structs (i.e., fields)
    get_associated_enum_name :: (name: string) -> string {
        if name.count > 1 && name[name.count - 1] != #char "_"
            return tprint("%_", name);
        return name;
    }

    imgui_data := cast(*ImGui_Bindings_Gen_Data)context.opts.user_data;

    // Look for function arguments with "typedef" types.
    if parent_decl && 
        (parent_decl.kind == .FUNCTION || parent_decl.kind == .STRUCT) && 
        decl.kind == .DECLARATION && decl.type.type_of_typedef != null
    {
        old_name := decl.type.type_of_typedef.name;
        new_name := get_associated_enum_name(old_name);
        if !new_name return .Recurse;

        //print("% -> %\n", old_name, new_name);

        for context.compiler.global_scope.members {
            if it.kind != .ENUM  || it.name != new_name
                continue;

            en := cast(*Enum)it;

            // Don't output the integer typedef
            decl.type.type_of_typedef.decl_flags |= .Omit_From_Output;

            // Make sure the enums like "FocusedFlags_" get outputted as "FocusFlags"
            if en.name.count > 2 && en.name[en.name.count - 1] == #char "_" {
                en.output_name = copy_string(en.name);
                en.output_name.count -= 1;
            }

            // swap in the enum for the typedef
            decl.type.type_of_typedef = null;
            decl.type.type_of_enum = en;
            
            // we'll also need to output a cast, like "cast(EnumType)5" for the default argument
            decl.decl_flags |= .Needs_Default_Argument_Cast;

            break;
        }
    }

    // ImGui also has functions with pairs of arguments like "text_begin" and "text_end"
    // for the pointers to the beginning and end of a string. We'll generate wrappers for
    // those function which take a jai string.
    //
    // Here we collect pointers to "_begin" arguments, and use them in
    // get_func_args_for_printing below.
    if decl.kind == .FUNCTION {
        func := cast(*Function)decl;
        for func.arguments {
            if it_index == 0 || !ends_with(it.name, "_end")
                continue;

            name_part := slice(it.name, 0, it.name.count - "_end".count);
            if !name_part
                continue;

            // the first arg may appear as "text_begin" or just "text"
            name_part_with_begin := tprint("%_begin", name_part);
            prev_arg := func.arguments[it_index - 1];
            if prev_arg.name == name_part || prev_arg.name == name_part_with_begin {
                array_add(*imgui_data.begin_end_string_args, prev_arg);
                func.decl_flags |= .Needs_Argument_Wrapper;
            }
        }
    }

    return .Recurse;
}

// Modify function with _begin and _end string arguments as they get printed.
// See the note above about "text_begin".
imgui_get_function_arg_for_printing :: (func: *Function, mode: Arg_Print_Mode) -> []*Declaration {
    args: [..]*Declaration;
    imgui_data := cast(*ImGui_Bindings_Gen_Data)context.opts.user_data;
    for func.arguments {
        if array_find(imgui_data.begin_end_string_args, it) {
            if mode == {
                case .Outer_Wrapper;
                    // For the outer wrapper, remove any "_begin" part of the argument, and
                    // change its type to a jai string
                    arg_copy := New(Declaration);
                    (<<arg_copy) = <<it;
                    arg_copy.type = context.compiler.type_def_jai_string;
                    if ends_with(arg_copy.name, "_begin")
                        arg_copy.name = slice(arg_copy.name, 0, arg_copy.name.count - "_begin".count);
                    array_add(*args, arg_copy);

                    it_index += 1; // skip the next argument-we collpase the _begin and _end args into one string arg

                    continue;
                case .Inner_Wrapper_Call;
                    // For the inner wrapper function call, we pass the incoming arg
                    // as two arguments: "jai_string.data, jai_string.count" -- corresponding
                    // to the _begin and _end parts.
                    arg_copy := New(Declaration);
                    (<<arg_copy) = <<it;
                    if ends_with(arg_copy.name, "_begin")
                        arg_copy.name = slice(arg_copy.name, 0, arg_copy.name.count - "_begin".count);
                    base_arg_name := arg_copy.name;
                    arg_copy.name = tprint("%.data", arg_copy.name);
                    array_add(*args, arg_copy);

                    arg_copy_2 := New(Declaration);
                    (<<arg_copy_2) = <<it;
                    arg_copy_2.name = tprint("%.data + %.count", base_arg_name, base_arg_name);
                    array_add(*args, arg_copy_2);

                    it_index += 1; // skip the next arg, since we already added a second one above 
                    continue;
            }
        }

        array_add(*args, it);
    }

    return args;
}

// Extra Jai code for the bindings
imgui_preamble := #string END

#module_parameters(LINK_STATIC := false);

#if LINK_STATIC {
    user32 :: #foreign_system_library "user32";
    imgui :: #foreign_library,no_dll "./win/static/imgui";
} else {
    imgui :: #foreign_library "./win/dll/imgui";
}

make_ImVec2 :: inline (a: float, b: float) -> ImVec2 {
    v: ImVec2 = ---;
    v.x = a;
    v.y = b;
    return v;
}

TreeNode :: (fmt: string, args: ..Any) -> bool {
    fmt_z := tprint("%\0", fmt);
    txt := tprint(fmt_z, ..args);
    return TreeNode(txt.data);
}

#if Preprocessor_Defines.USE_BGRA_PACKED_COLOR {
    IM_COL32_R_SHIFT :: 16;
    IM_COL32_G_SHIFT :: 8;
    IM_COL32_B_SHIFT :: 0;
    IM_COL32_A_SHIFT :: 24;
    IM_COL32_A_MASK  :: 0xFF000000;
} else {
    IM_COL32_R_SHIFT  ::  0;
    IM_COL32_G_SHIFT  ::  8;
    IM_COL32_B_SHIFT  ::  16;
    IM_COL32_A_SHIFT  ::  24;
    IM_COL32_A_MASK   ::  0xFF000000;
}
// This is a C preprocessor macro, should it be a Jai macro?
make_col32 :: (R : u32, G: u32, B: u32, A: u32) -> u32 {
    return cast(u32)((A<<IM_COL32_A_SHIFT) | (B<<IM_COL32_B_SHIFT) | 
        (G<<IM_COL32_G_SHIFT) | (R<<IM_COL32_R_SHIFT));
}
make_col32 :: (c: ImVec4) -> u32 {
    return make_col32(xx(c.x * 255), xx(c.y * 255), xx(c.z * 255), xx(c.w * 255));
}

END;
