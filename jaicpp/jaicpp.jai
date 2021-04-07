//
// Generates Jai wrappers for C++ headers.
//

// a TODO for those of your feeling entrepreneurial: this could probably just
// leverage the built-in Program_Print/Compiler modules now, and generate
// things with a tree of Code_Nodes. That would make the entire set of
// Declaration/Struct/Typedef/etc structs obsolete, and all of this
// shorter/more future-proof.

#load "generated_clang.jai";
#import "Basic";
#import "Hash_Table";
#import "File";
#import "File_Utilities";
#import "String";

#if OS == .MACOS || OS == .LINUX {
    #import "POSIX";
}

Hash :: #import "Hash_Table";

#if OS == .WINDOWS {
    time_t :: s64;
    size_t :: u64;
    #import "Windows";
    #import "Windows_Utf8";
}

Number_Flags :: enum_flags {
    None;
    _8BIT;
    _16BIT;
    _32BIT;
    _64BIT;

    SIGNED;
    FLOAT;
}

CType :: struct {
    hardcoded_jai_string: string;
    pointer_to: *CType;
    type_of_enum: *Enum;
    type_of_typedef: *Typedef;
    type_of_struct: *Struct;
    array_element_type: *CType;
    array_element_count := -1;
    array_element_count_ref: string;

    function_argument_types: [..] *CType;
    function_return_type: *CType = null;

    number_flags: Number_Flags;
    size: s64 = -1;
}

C_Kind :: enum {
    None;
    DECLARATION;
    FUNCTION;
    ENUM;
    TYPEDEF;
    STRUCT;
    NAMESPACE;

    LITERAL;
}

Expression :: struct {
    kind: C_Kind;
}

Literal :: struct {
    using _expression: Expression;
    kind = .LITERAL;

    literal_kind: enum int {
        NULL    :: 0;
        INTEGER :: 1;
        FLOAT   :: 2;
        STRING  :: 3;
        RAW_CPP_TOKENS :: 4;
    };

    union {
        int_value:    s64;
        float_value:  float64;
        string_value: string;
        raw_cpp_tokens_value:   string;
    }
}

Declaration :: struct {
    using _expression: Expression;
    kind = .DECLARATION;
    name: string;
    output_name: string;
    outputted_jai_name: string;
    type: *CType;
    expression: *Expression;
    parent_namespace: *Namespace;

    qualifer_using := false;
    bitfield_width := -1;

    storage_class: CX_StorageClass = .CX_SC_None;
    decl_flags: Declaration_Flags;
}

Declaration_Flags :: enum_flags {
    Needs_Argument_Wrapper;
    Pointer_To_Value; // TODO: rename this to "Reference_Argument" or something
    Omit_From_Output;
    Needs_Default_Argument_Cast;
}

Function :: struct {
    using declaration: Declaration;
    kind = .FUNCTION;

    arguments: [..] *Declaration;
    return_type: *CType;
    is_variadic := false;
    is_virtual := false;

    body: *Block;
    library: *Library_Info;

    foreign_function_name: string; // read: mangled name for linkage

    is_objc_binding := false;
    is_objc_class_method := false;
    objc_class_method_struct: *Struct;

    is_cpp_method := false;
    is_constructor := false;
}


// @Note Typedef.type is the type that this typedef binds to
Typedef :: struct {
    using declaration: Declaration;
    kind = .TYPEDEF;
}


// @Note Enum.type is the internal integer type of the enum
Enum :: struct {
    using declaration: Declaration;
    kind = .ENUM;

    Enumerate :: struct {
        name: string;
        value: u64;
    }
    enumerates: [..] Enumerate;
}

Type_Parameter :: struct {
    name: string;
    type: *CType;
}

Struct :: struct {
    using declaration: Declaration;
    kind = .STRUCT;

    vtable: [..] *Declaration;
    declarations: [..] *Declaration;
    template_type_params: [..] Type_Parameter;
    template_instantiation_params: [..] Type_Parameter; // TODO: can these be one list?
    do_not_print_anon: bool; // set when a declaration is typed an unnamed struct/union, so we don't try to emit the unnamed struct/union as an anonymous struct/union 
    flags: enum_flags {
        None;
        IS_ANON;
        IS_UNION;
        HAS_CONSTRUCTOR;
    };
}

Namespace :: struct {
    using declaration: Declaration;
    kind = .NAMESPACE;

    declarations: [..] *Declaration;
}

Block :: struct {
    parent: *Block;
    members: [..] *Declaration;
    // statements: [] *Expression;
}

Library_Info :: struct {
    name: string;
    path: string; // This should be just what the user has passed to us via -l, I think
    is_system: bool;

    static_path: string;
    static_depends_on_libs: [..]string;

    #if OS == .WINDOWS {
        handle: HMODULE;
    } else #if OS == .LINUX || OS == .MACOS {
        handle: *void;
    }
}


Declaration_Visit_Result :: enum {
    Stop;
    Recurse;
}

Declaration_Visitor :: #type (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result;

visit_declarations :: (visitor: Declaration_Visitor, decl: *Declaration, parent: *Declaration = null, depth := 0) {
    assert(decl != null);

    if visitor(decl, parent) == .Stop
        return;

    verbose :: false;
    if decl.kind == {
        case .FUNCTION;
            func := cast(*Function)decl;
            if verbose { for i: 1..depth print("  "); print("func: %\n", <<func); }
            for func.arguments visit_declarations(visitor, it, func, depth + 1);
            if func.body {
                for func.body.members
                    visit_declarations(visitor, it, func, depth + 1);
            }
        case .NAMESPACE;
            ns := cast(*Namespace)decl;
            if verbose { for i: 1..depth print("  "); print("namespace: %\n", <<ns); }
            for ns.declarations visit_declarations(visitor, it, ns, depth + 1);
        case .STRUCT;
            str := cast(*Struct)decl;
            if verbose { for i: 1..depth print("  "); print("struct: %\n", <<str); }
            for str.vtable visit_declarations(visitor, it, str, depth + 1);
            for str.declarations visit_declarations(visitor, it, str, depth + 1);
    }
}

TAB_STRING :: "    ";

Arg_Print_Mode :: enum {
    Outer_Wrapper;
    Foreign_Func_Declaration;
    Inner_Wrapper_Call;
}

_default_get_func_args_for_printing :: (func: *Function, mode: Arg_Print_Mode) -> []*Declaration {
    return func.arguments;
}

Get_Function_Arguments_For_Printing_Func :: #type (func: *Function, mode: Arg_Print_Mode) -> []*Declaration;

#add_context opts: Generate_Bindings_Options;

#add_context compiler: *struct {
    global_scope: Block;

    pointer_size: s64; // TODO: this should probably be queried from target info?
    anon_counter := 0;

    type_def_void: *CType;
    type_def_bool: *CType;

    type_def_u8: *CType;
    type_def_u16: *CType;
    type_def_u32: *CType;
    type_def_u64: *CType;

    type_def_s8: *CType;
    type_def_s16: *CType;
    type_def_s32: *CType;
    type_def_s64: *CType;

    type_def_float32: *CType;
    type_def_float64: *CType;

    type_def_ptr_void: *CType;

    type_def_objc_class: *CType;
    type_def_objc_selector: *CType;

    type_def_jai_string: *CType;

    // cxtype_to_type_table: Table(CXType, *CType);
    cursor_to_decl_table: Table(CXCursor, *Declaration, get_hash_cxcursor, compare_cxcursors);

    unique_objc_selectors: [..] string;

    libraries: [..] *Library_Info;

    translation_unit: CXTranslationUnit;

    // for printing functions
    tab_depth := 0;

    counts: struct {
        functions: u32;
        structs: u32;
        enums: u32;
    };
};


Strip_Flags :: enum_flags {
    Constructors;
    Destructors;
    Functions_With_Bodies;
    Functions_With_valist;
    Functions_With_Unknown_Foreign_Libs;
}

create_pointer_to :: (pointee: *CType) -> *CType {
    assert(pointee != null, "create_pointer_to passed a null *CType");
    out := New(CType);
    out.size = context.compiler.pointer_size;
    out.pointer_to = pointee;
    return out;
}

create_dummy_string_type :: (cur: CXType, array_count: int) -> *CType {
    out := New(CType);
    s := as_str(cur);
    orig := copy_string(s);

    while array_count > 0 {
        right_idx := last_index_of_char(s, #char "]");
        left_idx := last_index_of_char(s, #char "[");
        if left_idx != -1 && right_idx != -1 && left_idx < right_idx {
            s = slice(s, 0, left_idx - 1);
            array_count -= 1;
        }
    }

    handle :: (in_: string) -> string {
        in := in_;
        in = replace(in, "ImWchar", "u16"); // TODO: check IMGUI_USE_WCHAR32
        in = replace(in, "ImWchar16", "u16");
        in = replace(in, "ImWchar32", "u32");
        in = replace(in, "const char",   "u8");
        in = replace(in, "unsigned char", "u8");
        in = replace(in, "char",          "s8");

        while true {
            namespace_idx := index_of_string(in, "::");
            if namespace_idx == -1 break;

            in = tprint("%.%", 
                handle(slice(in, 0, namespace_idx)), 
                handle(slice(in, namespace_idx + 2, 10000)));
        }
        
        _, found := find_last(in, " *");
        if found {
            in = tprint("*%", stripped_name(slice(in, 0, in.count - 2)));
        } else {
            in = stripped_name(in);
        }
        return in;
    }

    left_idx  := index_of_char(s, #char "<");
    right_idx := last_index_of_char(s, #char ">");
    while left_idx != -1 && right_idx != -1 {
        left_part   := slice(s, 0, left_idx);
        middle_part := slice(s, left_idx + 1, right_idx - left_idx - 1);
        right_part: string;
        if s.count - right_idx > 0 {
            right_part = slice(s, right_idx + 1, s.count - right_idx);
        }

        new_s := handle(middle_part);
        s = handle(tprint("%1(%2)%3", left_part, new_s, right_part));
        left_idx  = index_of_char(new_s, #char "<");
        right_idx = last_index_of_char(new_s, #char ">");
    }

    out.hardcoded_jai_string = s;
    //print("FINISHED: '%' from '%'\n", s, orig);

    return out;
}

create_type :: (ty: CXType, cur: CXCursor, loc := #caller_location, array_count := 0) -> *CType {
    //print("create_type(ty=%, cur=%)\n", ty, cur);

    kind := ty.kind;

    if kind == {
        case CXType_ObjCObjectPointer; #through;
        case CXType_Pointer;
            pointee := create_type(clang_getPointeeType(ty), cur, loc=loc);
            return ifx !pointee then null else create_pointer_to(pointee);
        case CXType_LValueReference;
            pointee := create_type(clang_getPointeeType(ty), cur, loc=loc);
            if !pointee return null;
            
            out := New(CType);
            out.size = context.compiler.pointer_size;
            out.pointer_to = pointee;
            return out;
        case CXType_Void;
            return context.compiler.type_def_void;
        case CXType_Bool;
            return context.compiler.type_def_bool;

        case CXType_Char_S; #through;
        case CXType_Char_U; #through;
        case CXType_UChar; #through;
        case CXType_Char16; #through;
        case CXType_Char32; #through;
        case CXType_UShort; #through;
        case CXType_UInt; #through;
        case CXType_ULong; #through;
        case CXType_ULongLong; #through;
        case CXType_UInt128;
            size := clang_Type_getSizeOf(ty);
            if size == {
                case 1; return context.compiler.type_def_u8;
                case 2; return context.compiler.type_def_u16;
                case 4; return context.compiler.type_def_u32;
                case 8; return context.compiler.type_def_u64;
            }

            error("Unhandled int size: %\n", size);
        case CXType_SChar; #through;
        case CXType_WChar; #through;
        case CXType_Short; #through;
        case CXType_Int; #through;
        case CXType_Long; #through;
        case CXType_LongLong; #through;
        case CXType_Int128;
            size := clang_Type_getSizeOf(ty);
            if size == {
                case 1; return context.compiler.type_def_s8;
                case 2; return context.compiler.type_def_s16;
                case 4; return context.compiler.type_def_s32;
                case 8; return context.compiler.type_def_s64;
            }

            error("Unhandled uint size: %\n", size);
        case CXType_Float; #through;
        case CXType_Double; #through;
        case CXType_LongDouble;
            size := clang_Type_getSizeOf(ty);
            if size == 4 return context.compiler.type_def_float32;
            else if size == 8 return context.compiler.type_def_float64;
            error("Unhandled float size: %\n", size);

            return null;
        case CXType_Elaborated;
            return create_type(clang_Type_getNamedType(ty), cur, loc=loc);
        case CXType_Enum;
            decl_cur := clang_getTypeDeclaration(ty);
            en := create_enum(decl_cur, true);

            out := New(CType);
            out.type_of_enum = en;
            out.size = clang_Type_getSizeOf(ty);
            return out;
        case CXType_Typedef;
            decl_cur := clang_getTypeDeclaration(ty);
            en := create_typedef(decl_cur, true);
            if !en return null;
            
            out := New(CType);

            out.type_of_typedef = en;
            out.size = clang_Type_getSizeOf(clang_getCanonicalType(ty));
            return out;

        case CXType_ObjCObject; #through;
        case CXType_Record;
            decl_cur := clang_getTypeDeclaration(ty);
            en := create_struct(decl_cur, true);

            out := New(CType);
            out.type_of_struct = en;
            out.size = clang_Type_getSizeOf(ty);
            if out.size == -2 out.size = 0;
            return out;
        case CXType_ObjCInterface;
            decl_cur := clang_getTypeDeclaration(ty);
            en := create_objc_interface(decl_cur, true);

            out := New(CType);
            out.type_of_struct = en;
            out.size = clang_Type_getSizeOf(ty);
            if out.size == -2 out.size = 0;
            return out;
        case CXType_ConstantArray;
            ele := create_type(clang_getArrayElementType(ty), cur, loc=loc, array_count=array_count + 1);
            if !ele return null;

            num_ele := clang_getNumElements(ty);

            out := New(CType);
            out.array_element_type = ele;
            out.array_element_count = num_ele;
            out.size = clang_Type_getSizeOf(ty);
            return out;
        case CXType_IncompleteArray;
            ele := create_type(clang_getArrayElementType(ty), cur, loc=loc, array_count=array_count + 1);
            if !ele return null;
            // num_ele := clang_getNumElements(ty);

            out := New(CType);
            out.array_element_type = ele;
            out.size = clang_Type_getSizeOf(ty);
            return out;
        case CXType_DependentSizedArray;
            ele := create_type(clang_getArrayElementType(ty), cur, loc=loc, array_count=array_count + 1);
            if !ele return null;

            // TODO: make this a utility function
            Find_Context :: struct {
                ctx: Context;
                cur: CXCursor;
            }
            find_context: Find_Context;
            find_context.ctx = context;
            visitor :: (cur: CXCursor, parent: CXCursor, data: CXClientData) -> CXChildVisitResult #c_call {
                find_context := cast(*Find_Context)data;
                find_context.cur = cur;
                return .CXChildVisit_Break;
            }
            clang_visitChildren(cur, visitor, *find_context);

            out := New(CType);
            out.array_element_type = ele;
            if find_context.cur.kind == .CXCursor_DeclRefExpr
                out.array_element_count_ref = as_str(find_context.cur);
            else {
                // in this case, we're going to just assume there's like a
                // binary operator full of constants, so for now let's just
                // dump the C++ tokens into the Jai file.
                //
                // More robust would be to properly generate complex literals
                // with operators and constants.
                out.array_element_count_ref = raw_tokens_string_from_cursor(find_context.cur);
            }
            //print("type of inner cursor (% %): %\n", find_context.cur.kind, out.array_element_count_ref, as_str(clang_getCursorType(find_context.cur)));
            out.size = clang_Type_getSizeOf(ty);
            return out;

            
        case CXType_FunctionProto;
            arg_count := clang_getNumArgTypes(ty);

            out := New(CType);
            for 0..arg_count-1 {
                mem := create_type(clang_getArgType(ty, cast(u32) it), cur, loc=loc);
                if !mem {
                    array_reset(*out.function_argument_types);
                    free(out);
                    return null;
                }

                array_add(*out.function_argument_types, mem);
            }
            out.function_return_type = create_type(clang_getResultType(ty), cur, loc=loc);

            if !out.function_return_type {
                array_reset(*out.function_argument_types);
                free(out);
                return null;
            }
            return out;

        case CXType_ObjCId;
            return context.compiler.type_def_ptr_void;

        case CXType_ObjCClass;
            return context.compiler.type_def_objc_class;

        case CXType_ObjCSel;
            return context.compiler.type_def_objc_selector;

        case CXType_Unexposed;
            // here we need to handle structs with template parameters, i.e. "template<typename T> struct Foo"
            // and also fields with template instantiation parameters, i.e., "Foo<int> myFoo;"
            Name_Context :: struct { name: string; jai_ctx: *Context; }
            template_type_spelling_context: Name_Context;
            my_visitor :: (cur: CXCursor, parent: CXCursor, client_data: CXClientData) -> CXChildVisitResult #c_call {
                name_context := cast(*Name_Context)client_data;
                push_context (<<name_context.jai_ctx) {
                    if name_context.name.count == 0
                        name_context.name = as_str(cur);
                }
                return .CXChildVisit_Recurse;
            }

            name_context: Name_Context;
            ctx := context;
            name_context.jai_ctx = *ctx;
            clang_visitChildren(cur, my_visitor, *name_context);

            if name_context.name.count == 0
                return null;

            type_decl := clang_getCursorType(cur);

            //print("got template type name: '%' for cursor '%'\n", name_context.name, as_str(cur));
            //print("  type decl is %\n", as_str(type_decl));

            out: *CType;
            if starts_with(as_str(clang_getCanonicalType(type_decl)), "type-parameter") { // TODO: yeah there's probably a less error-prone way to detect this. I think the cursor kind
                out = New(CType);
                out.type_of_struct = New(Struct);
                out.type_of_struct.name = name_context.name; // TODO: dedupe?
            } else {
                out = create_dummy_string_type(type_decl, array_count=array_count);
                out.type_of_struct = New(Struct); // TODO: skip the block below if we do this...then we don't need to New type_of_struct
            }

            // get template instantiation parameters
            {
                num_template_args := clang_Type_getNumTemplateArguments(type_decl);
                alt_num_template_args := clang_Cursor_getNumTemplateArguments(cur);
                //error(cur, "gathering template instantiation parameters: % vs %\n", num_template_args, alt_num_template_args);
                //print("       num template args for '%': %\n", name_context.name, num_template_args);
                assert(out.type_of_struct != null);
                for i: 0..num_template_args - 1 {
                    template_arg_type := clang_Type_getTemplateArgumentAsType(type_decl, cast(u32)i);
                    entry := array_add(*out.type_of_struct.template_instantiation_params);
                    entry.name = as_str(template_arg_type);

                    temp_t := as_str(template_arg_type);
                    if temp_t == "T" { // TODO: need a better way to short-circuit the recursion that happens without this block...
                                        // I think the problem is that we're calling create_type below with the same cursor as we got called with?
                                        // basically we need a way to see that T is unexposed on its own...
                        print("type T\n");
                        t := New(CType);
                        t.type_of_struct = New(Struct);
                        t.type_of_struct.name = temp_t;
                        t.size = clang_Type_getSizeOf(template_arg_type);
                        entry.type = t;
                    } else {
                        entry.type = create_type(template_arg_type, cur);
                    }
                }
            }

            return out;

        case CXType_Invalid;
            error(cur, tprint("create_type: encountered CXType_Invalid (cursor is '%')\n", as_str(cur)));
            //assert(false);
            return null;
    }

    error("Unhandled CXTypeKind from %: %\n", loc, kind);
    return null;
}

print_indentation :: (builder: *String_Builder) {
    for 1..context.compiler.tab_depth append(builder, TAB_STRING);
}

print_type_to_builder :: (builder: *String_Builder, ty: *CType, flags: Print_Decl_Flags = 0) {
    assert(ty != null, "passed a null type to print_type_to_builder");

    if ty.hardcoded_jai_string.count > 0 {
        append(builder, ty.hardcoded_jai_string);
        return;
    }

    if ty.number_flags {
        using Number_Flags;
        flags := ty.number_flags;

        if flags & FLOAT {
            append(builder, "float");
            //if flags & _32BIT append(builder, "32"); // in jai, 'float' is a shorter alias for 'float32'
            if flags & _64BIT append(builder, "64");
        } else {
            if flags & SIGNED append(builder, "s");
            else append(builder, "u");

            if flags & _8BIT append(builder, "8");
            else if flags & _16BIT append(builder, "16");
            else if flags & _32BIT append(builder, "32");
            else if flags & _64BIT append(builder, "64");
        }

        return;
    }

    if ty == context.compiler.type_def_bool {
        append(builder, "bool");
        return;
    }

    if ty == context.compiler.type_def_void {
        append(builder, "void");
        return;
    }

    if ty.pointer_to {
        // reduce a level of indirection and use the #type keyword!
        if ty.pointer_to.function_return_type {
            append(builder, "#type ");
        } else {
            append(builder, "*");
        }
        print_type_to_builder(builder, ty.pointer_to);
        return;
    }

    if ty.type_of_enum {
        if ty.type_of_enum.name {
            append(builder, stripped_name(ty.type_of_enum));
        } else {
            en := ty.type_of_enum;
            is_signed := (en.type.number_flags & Number_Flags.SIGNED);
            type_str := type_to_string(en.type);
            defer free(type_str);
            print_to_builder(builder, "enum % {\n", type_str);
            context.compiler.tab_depth += 1;
            for en.enumerates {
                print_indentation(builder);
                if is_signed print_to_builder(builder, "% :: %;\n", stripped_name(it.name), cast(s64) it.value);
                else print_to_builder(builder, "% :: %;\n", stripped_name(it.name), cast(u64) it.value);
            }
            context.compiler.tab_depth -= 1;

            print_indentation(builder);
            append(builder, "}");
        }

        return;
    }

    if ty.type_of_struct {
        if ty.type_of_struct.name && !(ty.type_of_struct.flags & ty.type_of_struct.flags.IS_ANON) {
            name := replace_typename(ty.type_of_struct.name);
            name = stripped_name(name);

            num_template_args := ty.type_of_struct.template_instantiation_params.count;

            if ty.type_of_struct.parent_namespace {
                assert(ty.type_of_struct.parent_namespace.name.count > 0);
                append(builder, ty.type_of_struct.parent_namespace.name);
                append(builder, ".");
            }

            append(builder, name);

            // print any template instantiation parameters in parens
            if num_template_args > 0 {
                append(builder, "(");
                defer print_to_builder(builder, ") /* template params (orig type_of_struct.name '%') */", ty.type_of_struct.name);

                for templ_arg: ty.type_of_struct.template_instantiation_params {
                    append(builder, type_to_string(templ_arg.type));
                    if it_index < ty.type_of_struct.template_instantiation_params.count - 1
                        append(builder, ", ");
                }
            }
        } else {
            str := ty.type_of_struct;

            type_name := "struct";
            if (str.flags & str.flags.IS_UNION) type_name = "union";

            print_to_builder(builder, "% {\n", type_name);
            context.compiler.tab_depth += 1;
            for str.declarations {
                print_declaration_to_builder(builder, it, flags=.In_Struct);
            }
            context.compiler.tab_depth -= 1;

            append(builder, "\n");
            print_indentation(builder);
            append(builder, "}");
        }

        return;
    }

    if ty.array_element_type {
        if !ty.array_element_count_ref && ty.array_element_count == - 1 {
            // incomplete array (in a function paramter <type>[]) so we transform this into *<type>
            append(builder, "*");
            print_type_to_builder(builder, ty.array_element_type);
        } else {
            if flags & .In_Function_Args
                append(builder, "*");

            append(builder, "[");
            if ty.array_element_count != -1 {
                print_to_builder(builder, "%", ty.array_element_count);
            } else if ty.array_element_count_ref {
                append(builder, ty.array_element_count_ref);
            } else {
                assert(false, "Handle -1 array_element_count");
            }
            append(builder, "] ");

            print_type_to_builder(builder, ty.array_element_type);
        }
        return;
    }

    if ty.function_return_type {
        append(builder, "(");
        
        for ty.function_argument_types {
            type_str := type_to_string(it);
            defer free(type_str);

            print_to_builder(builder, "a%: %", it_index, type_str);
            if it_index < ty.function_argument_types.count-1 append(builder, ", ");
        }

        return_str := type_to_string(ty.function_return_type);
        defer free(return_str);
        print_to_builder(builder, ") -> % #c_call", return_str);
        return;
    }

    if ty.type_of_typedef {
        if ty.type_of_typedef.parent_namespace {
            assert(ty.type_of_typedef.parent_namespace.name.count > 0);
            append(builder, ty.type_of_typedef.parent_namespace.name);
            append(builder, ".");
        }
        append(builder, stripped_name(ty.type_of_typedef));
        return;
    }

    assert(false, "CType did not have any of its fields filled...we cannot recognize what kind of type it is.");
}

type_to_string :: (ty: *CType, flags: Print_Decl_Flags = 0) -> string {
    builder: String_Builder;
    print_type_to_builder(*builder, ty, flags);
    return builder_to_string(*builder);
}

as_str :: (cur: CXCursor, all_info := false) -> string {
    spelling := copy_and_dispose(clang_getCursorSpelling(cur));
    if all_info
        return tprint("<Cursor kind='%' type='%' spelling='%'>", clang_getCursorKind(cur), clang_getCursorType(cur), spelling);
    else
        return spelling;
}
as_str :: (ty: CXType)    -> string { return copy_and_dispose(clang_getTypeSpelling(ty)); }

assign_from_integer_lit :: (decl: *Declaration, cur: CXCursor, parent_cur: CXCursor, verbose := false) {
    decl.expression = create_literal(cur);
    if verbose {
        print("decl.type: %\n", <<decl.type);
    }
    if !decl.expression && decl.type && is_pointer(decl.type) {
        // this is a hack. the llvm capi cannot tell us when we have a null pointer in an
        // argument default: https://bugs.llvm.org/show_bug.cgi?id=36576
        // but by reading the raw tokens we can "see" the null
        raw_tokens := raw_tokens_string_from_cursor(parent_cur);
        if verbose {
            print("raw_tokens: '%'\n", raw_tokens);
        }
        if ends_with(raw_tokens, "=NULL")
            decl.expression = create_literal("null");
    }
}

is_pointer :: (ty: *CType) -> bool {
    if ty.pointer_to
        return true;
    else if ty.type_of_typedef
        return is_pointer(ty.type_of_typedef.type);
    else
        return false;
}


// variable or parameters
create_variable_declaration :: (cur: CXCursor, parent: CXCursor, parent_func: *Function = null) -> *Declaration {
    kind := clang_getCursorKind(cur);
    assert(kind == CXCursor_ParmDecl || kind == CXCursor_VarDecl || kind == CXCursor_FieldDecl || kind == CXCursor_ObjCIvarDecl);

    decl_type := create_type(clang_getCursorType(cur), cur);
    decl := _create_declaration(copy_and_dispose(clang_getCursorSpelling(cur)), decl_type);
    decl.bitfield_width = clang_getFieldDeclBitWidth(cur);

    children := get_children(cur);

    if parent_func {
        cur_type := clang_getCursorType(cur);
        //recursive_print_anything_under_cursor(cur);
        if cur_type.kind == .CXType_LValueReference &&
            !begins_with(decl.name, "out_") // TODO: remove this ImGui hack
        {
            parent_func.decl_flags |= .Needs_Argument_Wrapper;
            decl.decl_flags |= .Pointer_To_Value;
        }
    }

    verbose := parent_func && array_find(context.opts.inspect_entities_named, parent_func.name);
    if verbose {
        recursive_print_anything_under_cursor(cur);
    }

    if children.count == 1 {
        value := create_literal(children[0]);
        if value decl.expression = value;
    } 

    if !decl.expression && parent_func {
        // What follows are some very suspiciously hacky gymnastics to attemp
        // to read common types of defaults. If we see things like binary
        // expressions, we just dump the token text in the hope that it's also
        // valid Jai. The real path forward here is to build up data types for
        // those types of clang cursors as well.
        while children.count > 0 {
            if children[0].kind == .CXCursor_TypeRef || children[0].kind == .CXCursor_ParmDecl {
                children.data += 1;
                children.count -= 1;
                continue;
            }

            if children.count == 1 && children[0].kind == .CXCursor_FirstExpr {
                children = get_children(children[0]);
                continue;
            }

            break;
        }

        if children.count == 1 {
            first_child := children[0];
            if first_child.kind == {
                case .CXCursor_IntegerLiteral;
                    assign_from_integer_lit(decl, first_child, cur, verbose=verbose);
                case .CXCursor_CXXNullPtrLiteralExpr;
                    decl.expression = create_literal("null");
                case .CXCursor_TemplateRef;
                    // nothing
                case;
                    decl.expression = create_literal(first_child);
                    if decl.expression == null {
                        if verbose {
                            print("-----\n%\n", as_str(cur));
                            print("calling get_decl_arg_from_tokens for kind %\n", first_child.kind);
                        }
                        decl.expression = get_decl_arg_from_tokens(first_child, decl, decl_type, parent_func);
                        if decl.expression && verbose
                            print("   ...got %\n", (cast(*Literal)decl.expression).raw_cpp_tokens_value);
                    }
            }
        } else if children.count > 1 {
            //print("ignoring, more than one child: % % %\n", as_str(cur), cur, cur.kind);
        }
    }

    if !decl.type {
        error(cur, "could not create type for declaration. Discarding '%'.\n", copy_and_dispose(clang_getCursorSpelling(cur)));
        free(decl);
        return null;
    }

    type_of_struct := decl.type.type_of_struct;
    if type_of_struct && (type_of_struct.flags & type_of_struct.flags.IS_ANON) {
        type_of_struct.do_not_print_anon = true;
    }

    //print("Type: %\n", type_to_string(decl.type));
    return decl;
}

get_decl_arg_from_tokens :: (cur: CXCursor, decl: *Declaration, decl_type: *CType, parent_func: *Function) -> *Expression {
    //recursive_print_anything_under_cursor(cur);
    raw_tokens_str := raw_tokens_string_from_cursor(cur);
    if raw_tokens_str.count == 0
        return null;

    if raw_tokens_str[0] == #char "=" && raw_tokens_str.count > 1 {
        raw_tokens_str.count -= 1;
        raw_tokens_str.data += 1;
    }

    // turn '0 ' into '0 '
    for 0..raw_tokens_str.count-2
        if is_digit(raw_tokens_str[it]) && raw_tokens_str[it + 1] == #char "f"
            raw_tokens_str[it + 1] = #char " ";

    // turn ImVec2(0, 0) into ImVec2.{0, 0}
    for 0..raw_tokens_str.count-2 {
        if is_alnum(raw_tokens_str[it]) && raw_tokens_str[it + 1] == #char "(" {
            replace_chars(raw_tokens_str, "(", #char "{");
            replace_chars(raw_tokens_str, ")", #char "}");
            elems := split(raw_tokens_str, "{");
            if elems.count != 2 {
                print("elems.count != 2: %\n", raw_tokens_str);
                return null;
            }

            raw_tokens_str = tprint("%.{%", elems[0], elems[1]);
            // Jai cannot refer to the address of constant values in function signatures,
            // so in this case we need to create a wrapper function
            if parent_func && decl_type.pointer_to {
                parent_func.decl_flags |= .Needs_Argument_Wrapper;
                decl.decl_flags |= .Pointer_To_Value;
            }
            break;
        }
    }

    
    return create_literal(raw_tokens_str);
}

_create_declaration :: (name: string, type: *CType) -> *Declaration {
    decl := New(Declaration);
    decl.name = name;
    decl.type = type;
    return decl;
}

create_literal :: (raw_tokens_str: string) -> *Literal {
    // A hack to just put a raw string into the Jai output
    lit := New(Literal);
    lit.literal_kind = .RAW_CPP_TOKENS;
    lit.raw_cpp_tokens_value = raw_tokens_str;
    return lit;
}

create_literal :: (cur: CXCursor, verbose := false) -> *Literal {
    cursor_kind := clang_getCursorKind(cur);

    eval := clang_Cursor_Evaluate(cur);
    defer clang_EvalResult_dispose(eval);

    eval_kind := clang_EvalResult_getKind(eval);

    if eval_kind == {
        case CXEval_Int;
            lit := New(Literal);
            lit.literal_kind = .INTEGER;
            lit.int_value = clang_EvalResult_getAsLongLong(eval);
            return lit;

        case CXEval_Float;
            lit := New(Literal);
            lit.literal_kind = .FLOAT;
            lit.float_value = clang_EvalResult_getAsDouble(eval);
            return lit;

        case CXEval_StrLiteral;
            lit := New(Literal);
            lit.literal_kind = .STRING;
            c_str := clang_EvalResult_getAsStr(eval);
            lit.string_value = copy_string(to_string(c_str));
            return lit;

        case;
            // sigh, for whatever reason, nullptr is reported as Unexposed and the CXCursor kind is reported as
            // CXCursor_UnexposedExpr. I believe this is due to Clang using an internal cast to convert the nullptr type
            // to the type of whatever pointer you're assigning it to. Something similar seems to happen with float literals
            // where float a = 1.0; is reported as CXCursor_UnexposedExpr but float a = 1.0f; is reported as CXCursor_FloatLiteral; perhaps
            // there's an implicit cast that isnt exposed via libclang. -josh 5 February 2019
            //
            // an update: some of these cases are handled elsewhere now, see CXCursor_CXXNullPtrLiteralExpr below. -kevinw April 5 2021
    }

    return null;
}


// operates in-place
convert_objc_selector_name_to_function_identifier :: (s: *string) {
    for 0..s.count-1 {
        if s.data[it] == #char ":" {
            s.data[it] = #char "_";
        }
    }

    if s.count && (s.data[s.count-1] == #char "_") {
        s.count -= 1;
    }
}

create_function :: (cur: CXCursor, parent: CXCursor) -> *Function {

    kind := clang_getCursorKind(cur);
    assert(kind == CXCursor_FunctionDecl || kind == CXCursor_CXXMethod
            || kind == CXCursor_Constructor || kind == CXCursor_Destructor
            || kind == CXCursor_ObjCInstanceMethodDecl
            || kind == CXCursor_ObjCClassMethodDecl);

    /*if clang_CXXMethod_isVirtual(cur) {
        // @TODO basically hide this for now because we need to figure out vtable generation
        //return null;
    }*/

    func := New(Function);
    if kind == CXCursor_Constructor {
        func.name = copy_string("Constructor");
        func.is_constructor = true;
    } else if kind == CXCursor_Destructor {
        func.name = copy_string("Destructor");
    } else {
        func.name = copy_and_dispose(clang_getCursorSpelling(cur));
    }

    func.is_cpp_method = (kind == CXCursor_CXXMethod || kind == CXCursor_Constructor || kind == CXCursor_Destructor);

    if kind == CXCursor_ObjCInstanceMethodDecl || kind == CXCursor_ObjCClassMethodDecl {
        func.foreign_function_name = copy_string(func.name);
        convert_objc_selector_name_to_function_identifier(*func.name);
        func.is_objc_binding = true;
        array_add_if_unique(*context.compiler.unique_objc_selectors, func.foreign_function_name);

        if kind == CXCursor_ObjCClassMethodDecl func.is_objc_class_method = true;
    } else {
        func.foreign_function_name = copy_and_dispose(clang_Cursor_getMangling(cur));
        if func.foreign_function_name.count == 0 {
            //error(cur, tprint("could not get mangled function name for cursor '%'\n", as_str(cur)));
            //assert(func.foreign_function_name != "", "could not get mangled function name for cursor %", as_str(cur));
            return null;
        }
    }

    #if OS == .MACOS {
        // On OSX and maybe Linux too, dlsym needs the first underscore to be omitted
        // this affects dynload/jai as well, which is why we're advancing here intead of in find_lib_for_function_name()

        if starts_with(func.foreign_function_name, "_") advance(*func.foreign_function_name);
    }
    func.library = find_lib_for_function_name(func.foreign_function_name);
    // print("Func: %\n", func.foreign_function_name);

    // @TODO this vs clang_Cursor_getArgument ?
    children := get_children(cur);
    defer array_reset(*children);

    if kind == CXCursor_CXXMethod || kind == CXCursor_Constructor || kind == CXCursor_Destructor {
        // add 'this' parameter

        // @TODO if parent is the translation unit then this doesn't work and we need to find the struct
        // that this CXXMethod belongs to and replace the function's member declaration with this definition
        /*
            struct Struct {
                void member(float a);
            };

            void Struct::member(float a) {
    
            }
        */
        parent_type := create_type(clang_getCursorType(parent), cur);
        // TODO: find a better way to skip constructors with bodies
        if parent_type != null {
            var := New(Declaration);
            var.type = create_pointer_to(parent_type);
            var.name = copy_string("this");
            array_add(*func.arguments, var);
        }
    }

    unk_count := 0;
    for children {
        if clang_getCursorKind(it) == CXCursor_ParmDecl {
            var := create_variable_declaration(it, cur, func);
            if !var {
                error(it, "Could not create function parameter declaration. Discarding.\n");
                return null; // @Leak func
            }
            if !var.name {
                var.name = sprint("unk%", unk_count);
                unk_count += 1;
            }
            array_add(*func.arguments, var);
        } else if clang_isStatement(clang_getCursorKind(it)) {
            func.body = New(Block);
            //error(it, "TODO: do statement stuff\n");
            // do statement stuff
        }
    }

    if clang_Cursor_isVariadic(cur) != 0 {
        func.is_variadic = true;
    }
    if clang_CXXMethod_isVirtual(cur) {
        func.is_virtual = true;
    }

    func.return_type = create_type(clang_getCursorResultType(cur), cur);
    // print("Return type: %\n", type_to_string(func.return_type));

    return func;
}

create_typedef :: (cur: CXCursor, resolving_type_only := false) -> *Typedef {
    assert(clang_getCursorKind(cur) == CXCursor_TypedefDecl);

    def: *Typedef;
    decl, success := table_find(context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur));
    if !success {
        def = New(Typedef);
        table_add(*context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur), def);
    } else {
        assert(decl.kind == .TYPEDEF);
        def = cast(*Typedef) decl;
    }

    if !def.name def.name = copy_and_dispose(clang_getCursorSpelling(cur));
    def.type = create_type(clang_getTypedefDeclUnderlyingType(cur), cur);
    if !def.type {
        error(cur, "typedef aliases a non-representable type in jai. Discarding.\n");
        return null;
    }
    if resolving_type_only return def;

    // print("typedef: %: %\n", def.name, type_to_string(def.type));

    return def;
}

_create_typedef_type :: (name: string, old_type: *CType) -> *CType {
    def := New(Typedef);
    def.name = copy_string(name);
    def.type = old_type;

    type := New(CType);
    type.type_of_typedef = def;
    type.size = def.type.size;
    return type;
}

debug_print_cursor :: (cur: CXCursor) {
    depth := 0;

    child_visitor :: (c: CXCursor, parent: CXCursor, client_data: CXClientData) -> CXChildVisitResult #c_call {
        my_depth    := <<cast(*int)client_data;
        child_depth := my_depth + 1;
        ctx: Context;
        push_context ctx {
            for 1..my_depth print("  ");
            print("Cursor '%' of kind '%'\n", clang_getCursorSpelling(c), copy_and_dispose(clang_getCursorKindSpelling(clang_getCursorKind(c))));
        }
        clang_visitChildren(c, child_visitor, *child_depth);
        return CXChildVisit_Continue;
    }

    clang_visitChildren(cur, child_visitor, *depth);
}

create_struct :: (cur: CXCursor, resolving_type_only := false) -> *Struct {
    str: *Struct;
    decl, success := table_find(context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur));
    if !success {
        str = New(Struct);
        table_add(*context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur), str);
    } else {
        assert(decl.kind == .STRUCT);
        str = cast(*Struct) decl;
    }

    if !str.name {
        str.name = copy_and_dispose(clang_getCursorSpelling(cur));
        if !str.name {
            str.name = sprint("anon_struct_%", context.compiler.anon_counter);
            context.compiler.anon_counter += 1;
        }
    }
    
    is_template_class := false;
    cursor_kind := clang_getCursorKind(cur);
    if cursor_kind == {
        case CXCursor_UnionDecl; str.flags |= str.flags.IS_UNION;
        case CXCursor_ClassTemplate; is_template_class = true;
    }

    if resolving_type_only return str;

    //print("name:  %\n", str.name);

    children := get_children(cur);
    defer array_reset(*children);

    {
        if is_template_class {
            out := New(CType);
            out.type_of_struct = str;
            out.size = 0;
            // TODO
            str.type = out;
        } else {
            str.type = create_type(clang_getCursorType(cur), cur);
        }
    }

    // if this is not the definition then return null (wait for the definition to come through the pipeline)
    // but if the definition for this struct doesn't exist (only a forward declaration does) then process it
    // so we generate a definition for it in print_struct.
    if clang_isCursorDefinition(cur) == 0 && clang_Cursor_isNull(clang_getCursorDefinition(cur)) == 0 return null;

    for it, it_index: children {
        if is_template_class {
            if clang_getCursorKind(it) == {
            case CXCursor_TemplateTypeParameter; #through;
            case CXCursor_NonTypeTemplateParameter;
                entry := array_add(*str.template_type_params);
                entry.name = copy_and_dispose(clang_getCursorSpelling(it));
                entry.type = create_type(clang_getCursorType(it), it);
                continue;
            }
        }
        if clang_getCursorKind(it) == {
            case .CXCursor_CXXBaseSpecifier;
                // handle C++ inheritance like
                // struct B : public A {}
                //
                // this becomes
                // B :: struct { using a: A; }
                // in Jai.
                ty := create_type(clang_getCursorType(it), it);
                name := copy_string(ty.type_of_struct.name);
                to_lower(name);

                decl := _create_declaration(name, ty);
                decl.qualifer_using = true;
                array_add(*str.declarations, decl);
                continue;
        }

        decl := create_declaration(it, cur);
        if decl {
            if decl.kind == .FUNCTION && (cast(*Function)decl).is_constructor {
                str.flags |= .HAS_CONSTRUCTOR;
            }
            if clang_CXXMethod_isVirtual(it) {
                array_add(*str.vtable, decl);
            }
            else {
                decl.storage_class = clang_Cursor_getStorageClass(it);
                array_add(*str.declarations, decl);
            }
        }

        // sigh this only works for anonymous struct declarations within parent structs.
        // this doesn't solve the fact that there doesn't seem to be a way to tell if say an unnamed struct in
        // global scope has varibales instantiated by it (i.e., struct { int x; } my_variable; vs struct { int x; };) 
        if clang_Cursor_isAnonymous(it) {
            assert(decl.kind == .STRUCT);
            str := cast(*Struct) decl;
            str.flags |= str.flags.IS_ANON;
        }
    }

    return str;
}

create_namespace :: (cur: CXCursor) -> *Namespace {
    ns: *Namespace;
    decl, success := table_find(context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur));
    if !success {
        ns = New(Namespace);
        table_add(*context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur), ns);
    } else {
        assert(decl.kind == .NAMESPACE);
        ns = cast(*Namespace) decl;
    }

    if !ns.name {
        ns.name = copy_and_dispose(clang_getCursorSpelling(cur));
    }

    children := get_children(cur);
    defer array_reset(*children);

    //space.type = create_type(clang_getCursorType(cur));

    for children {
        decl := create_declaration(it, cur);
        if !decl continue;

        decl.parent_namespace = ns;
        array_add(*ns.declarations, decl);
    }

    return ns;
}

create_enum :: (cur: CXCursor, resolving_type_only := false) -> *Enum {
    assert(clang_getCursorKind(cur) == CXCursor_EnumDecl);

    en: *Enum;
    decl, success := table_find(context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur));
    if !success {
        en = New(Enum);
        table_add(*context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur), en);
    } else {
        assert(decl.kind == .ENUM);
        en = cast(*Enum) decl;
    }

    if !en.name {
        en.name = copy_and_dispose(clang_getCursorSpelling(cur));
        if !en.name {
            en.name = sprint("anon_enum_%", context.compiler.anon_counter);
            context.compiler.anon_counter += 1;
        }
    }
    
    en.type = create_type(clang_getEnumDeclIntegerType(cur), cur);
    if resolving_type_only return en;

    // print("ENUM NAME: %\n", en.name);


    children := get_children(cur);
    defer array_reset(*children);

    for children {
        kind := clang_getCursorKind(it);
        if kind != CXCursor_EnumConstantDecl {
            // error(it, "Skipping unexposed attribute cursor in enum declaration: %\n", kind);


            continue;
        }
        // assert(kind == CXCursor_EnumConstantDecl);

        e: Enum.Enumerate;
        if en.type.number_flags & en.type.number_flags.SIGNED {
            e.value = cast(u64) clang_getEnumConstantDeclValue(it);
        } else {
            e.value = clang_getEnumConstantDeclUnsignedValue(it);
        }
        e.name = copy_and_dispose(clang_getCursorSpelling(it));
        array_add(*en.enumerates, e);
    }

    return en;
}

create_objc_interface :: (cur: CXCursor, resolving_type_only := false) -> *Struct {
    // this is going to just setup a struct with the correct things that we want
    str: *Struct;
    decl, success := table_find(context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur));
    if !success {
        str = New(Struct);
        table_add(*context.compiler.cursor_to_decl_table, clang_getCanonicalCursor(cur), str);
    } else {
        assert(decl.kind == .STRUCT);
        str = cast(*Struct) decl;
    }

    if !str.name {
        str.name = copy_and_dispose(clang_getCursorSpelling(cur));
        if !str.name {
            str.name = sprint("anon_struct_%", context.compiler.anon_counter);
            context.compiler.anon_counter += 1;
        }
    }

    if clang_getCursorKind(cur) == CXCursor_UnionDecl {
        str.flags |= str.flags.IS_UNION;
    }

    if resolving_type_only return str;

    // print("name:  %\n", str.name);

    children := get_children(cur);
    defer array_reset(*children);

    if clang_getCursorKind(cur) == CXCursor_ObjCProtocolDecl {
        // set the type here since technically protocol's are not types in ObjC
        // and thus clang_getCursorType() returns CXType_Invalid.
        out := New(CType);
        out.type_of_struct = str;
        out.size = 0;

        str.type = out;
    } else {
        str.type = create_type(clang_getCursorType(cur), cur);
    }

    // if this is not the definition then return null (wait for the definition to come through the pipeline)
    // but if the definition for this struct doesn't exist (only a forward declaration does) then process it
    // so we generate a definition for it in print_struct.
    if clang_isCursorDefinition(cur) == 0 && clang_Cursor_isNull(clang_getCursorDefinition(cur)) == 0 return null;

    for children {
        kind := clang_getCursorKind(it);
        if kind == CXCursor_ObjCClassRef {
            // this is a reference to our parent class, so we drop
            // a struct member in this slot.
            ty := create_type(clang_getCursorType(it), it);
            name := copy_string(ty.type_of_struct.name);
            to_lower(name);

            decl := _create_declaration(name, ty);
            decl.qualifer_using = true;
            array_add(*str.declarations, decl);
            continue;
        } else if kind == CXCursor_ObjCProtocolRef {
            // skip these for now since they dont contribute to the struct.
            // we may want to, at some point, do 'using ProcolName;' in order to
            // bring in any objc functions that lie within the protocol.

            // actually do the same thing here that we do with ObjCClassRef
            // since we do want to import these things. We have to construct the protocol type 
            prot := create_objc_interface(clang_getCursorReferenced(it), false);
            name := copy_string(prot.type.type_of_struct.name);
            to_lower(name);

            decl := _create_declaration(name, prot.type);
            decl.qualifer_using = true;
            array_add(*str.declarations, decl);
            continue;
        } else if kind == CXCursor_ObjCPropertyDecl {
            // We actually dont need to do anything here since clang generates a CXCursor_ObjCInstanceMethodDecl
            // cursor for both the getter and setter (if exists) of each property.

            /*
            attrs := cast(CXObjCPropertyAttrKind) clang_Cursor_getObjCPropertyAttributes(it, 0);
            {
                getter := New(Function);
                getter.foreign_function_name = copy_and_dispose(clang_Cursor_getObjCPropertyGetterName(it));
                getter.name = copy_string(getter.foreign_function_name);
                getter.is_objc_binding = true;

                getter.return_type = create_type(clang_getCursorType(it), it);
                assert(getter.return_type != null);
                array_add(*getter.arguments, _create_declaration(copy_string("self"), create_pointer_to(str.type))); // add self parameter
                array_add(*str.declarations, getter);
                // print("Added getter: %\n", getter.name);

                array_add_if_unique(*context.compiler.unique_objc_selectors, getter.foreign_function_name);
            }

            if !(attrs & CXObjCPropertyAttr_readonly) {
                setter := New(Function);
                setter.foreign_function_name = copy_and_dispose(clang_Cursor_getObjCPropertySetterName(it));
                setter.name = copy_string(setter.foreign_function_name);
                assert(setter.name.count >= 1);
                setter.name.count -= 1; // remove colon

                setter.is_objc_binding = true;
                setter.return_type = context.compiler.type_def_void;
                array_add(*setter.arguments, _create_declaration(copy_string("self"), create_pointer_to(str.type))); // add self parameter
                array_add(*setter.arguments, _create_declaration(copy_string("value"), create_type(clang_getCursorType(it), it)));

                array_add(*str.declarations, setter);
                // print("Added setter: %\n", setter.name);
                array_add_if_unique(*context.compiler.unique_objc_selectors, setter.foreign_function_name);
            }
            */
            continue;
        } else if kind == CXCursor_ObjCInstanceMethodDecl {
            func := create_function(it, cur);
            if !func continue;

            array_insert_at(*func.arguments, _create_declaration(copy_string("self"), create_pointer_to(str.type)), 0);

            array_add(*str.declarations, func);
            continue;
        } else if kind == CXCursor_ObjCClassMethodDecl {
            func := create_function(it, cur);
            if !func continue;

            func.objc_class_method_struct = str;

            array_add(*str.declarations, func);
            continue;
        }

        decl := create_declaration(it, cur);
        if decl {
            if clang_CXXMethod_isVirtual(it) {
                array_add(*str.vtable, decl);
            }
            else {
                array_add(*str.declarations, decl);
            }
        }

        // sigh this only works for anonymous struct declarations within parent structs.
        // this doesn't solve the fact that there doesn't seem to be a way to tell if say an unnamed struct in
        // global scope has varibales instantiated by it (i.e., struct { int x; } my_variable; vs struct { int x; };) 
        if clang_Cursor_isAnonymous(it) {
            assert(decl.kind == .STRUCT);
            str := cast(*Struct) decl;
            str.flags |= str.flags.IS_ANON;
        }
    }

    return str;
}

create_declaration :: (cur: CXCursor, parent: CXCursor) -> *Declaration {
    kind := clang_getCursorKind(cur);

    if kind == {
        case CXCursor_FunctionDecl; #through;
        case CXCursor_CXXMethod;    #through;
        case CXCursor_Constructor;  #through;
        case CXCursor_Destructor;   #through;
        case CXCursor_ObjCInstanceMethodDecl;
            return create_function(cur, parent);

        case CXCursor_EnumDecl;
            return create_enum(cur);
        case CXCursor_TypedefDecl;
            return create_typedef(cur);

        case CXCursor_VarDecl;   #through;
        case CXCursor_FieldDecl; #through;
        case CXCursor_ObjCIvarDecl;
            return create_variable_declaration(cur, parent);

        case CXCursor_StructDecl; #through;
        case CXCursor_UnionDecl; #through;
        case CXCursor_ClassTemplate;
            return create_struct(cur);

        case CXCursor_Namespace;
            return create_namespace(cur);
        case CXCursor_ObjCInterfaceDecl;
            return create_objc_interface(cur);
        case CXCursor_ObjCProtocolDecl;
            return cast(*Declaration) create_objc_interface(cur);

        case CXCursor_FunctionTemplate;
            // @TODO
            error(cur, "Function templates are unsupported right now. Discarding.\n");
            return null;
        case CXCursor_ConversionFunction;
            // @TODO
            error(cur, "Conversion functions are unsupported right now. Discarding.\n");
            return null;
        case CXCursor_UnexposedDecl;
            name := copy_and_dispose(clang_getCursorSpelling(cur));
            //print("name: %\n", name);
    }

    error(cur, "Unhandled cursor kind: %\n", kind);
    print_stack_trace(context.stack_trace);
    return null;
}

handle_toplevel_cursors :: (cur: CXCursor, parent: CXCursor, client_data: CXClientData) -> CXChildVisitResult #c_call {
    // I think it makes sense that we only handle input from files the user passes on the commandline
    // if clang_Location_isFromMainFile(clang_getCursorLocation(cur)) == 0
    //     return CXChildVisit_Continue;

    _ctx := cast(*Context) client_data;
    push_context <<_ctx {

        if clang_Location_isInSystemHeader(clang_getCursorLocation(cur)) != 0 return CXChildVisit_Continue;

        // extern "C"
        // just dop the cursor on the floor and evaluate its children because
        // clang_Cursor_getMangling will do the right thing for us anyways
        if clang_getCursorKind(cur) == CXCursor_LinkageSpec {
            return CXChildVisit_Recurse;
        }

        // if clang_Cursor_isAnonymous(cur) {
        //     print("skipping anon cursor: %\n", clang_getCursorKind(cur));
        //     return CXChildVisit_Continue;
        // }

        decl := create_declaration(cur, parent);
        if decl array_add_if_unique(*context.compiler.global_scope.members, decl);

        return CXChildVisit_Continue; // go to the next child in the list! we don't want to recurse here!
    }
}

size_from_number_flags :: (flags: Number_Flags) -> u32 {
    if flags & ._8BIT return 1;
    if flags & ._16BIT return 2;
    if flags & ._32BIT return 4;
    if flags & ._64BIT return 8;

    return 0;
}

init_compiler_context :: (con: *Context) {
    using con.compiler;

    pointer_size = 8; // @PointerSize
    type_def_void = New(CType);
    type_def_ptr_void = create_pointer_to(type_def_void);

    type_def_bool = New(CType);
    type_def_bool.size = 1;

    make_number_type :: (flags: Number_Flags) -> *CType {
        size := size_from_number_flags(flags);
        ty := New(CType);
        ty.size = size;
        ty.number_flags = flags;
        return ty;
    }

    type_def_u8  = make_number_type(._8BIT);
    type_def_u16 = make_number_type(._16BIT);
    type_def_u32 = make_number_type(._32BIT);
    type_def_u64 = make_number_type(._64BIT);

    type_def_s8 = make_number_type(Number_Flags._8BIT | .SIGNED);
    type_def_s16 = make_number_type(Number_Flags._16BIT | .SIGNED);
    type_def_s32 = make_number_type(Number_Flags._32BIT | .SIGNED);
    type_def_s64 = make_number_type(Number_Flags._64BIT | .SIGNED);

    type_def_float32 = make_number_type(Number_Flags._32BIT | .FLOAT);
    type_def_float64 = make_number_type(Number_Flags._64BIT | .FLOAT);

    type_def_objc_class = _create_typedef_type("Class", type_def_ptr_void);
    type_def_objc_selector = _create_typedef_type("Selector", type_def_ptr_void);

    type_def_jai_string = New(CType);
    type_def_jai_string.hardcoded_jai_string = "string";
}

print_literal_to_builder :: (builder: *String_Builder, lit: *Literal, for_argument_type: *CType = null) -> (did_print_unary_enum: bool) {
    if lit.literal_kind == {
        case .NULL;    append(builder, "null");
        case .INTEGER;
            if for_argument_type == context.compiler.type_def_bool {
                print_to_builder(builder, ifx lit.int_value == 0 then "false" else "true");
            } else {
                // For enums, we try to search through the enum's values and
                // see if our literal matches one of them. It might be better
                // to just preserve the original tokens from the C++ literal...
                if for_argument_type.type_of_enum {
                    en := for_argument_type.type_of_enum;
                    assert(en.kind == .ENUM);

                    for en.enumerates {
                        if cast(s64)it.value == lit.int_value {
                            name := get_enum_value_name(en, it);
                            if name {
                                print_to_builder(builder, ".%", name); // use ".Value" unary enum selector
                                return true;
                            }
                        }
                    }
                }

                print_to_builder(builder, "%", lit.int_value);
            }
        case .FLOAT;   print_to_builder(builder, "%", formatFloat(lit.float_value, zero_removal=.ONE_ZERO_AFTER_DECIMAL));
        case .STRING;  print_to_builder(builder, "\"%\"", lit.string_value);
        case .RAW_CPP_TOKENS; append(builder, lit.raw_cpp_tokens_value);
    }

    return false;
}

function_has_a_valist_arg :: (func: *Function) -> bool {
    for func.arguments {
        if it.type && it.type.type_of_typedef && it.type.type_of_typedef.name == "va_list" {
            return true;
        }
    }
    return false;
}

Print_Decl_Flags :: enum_flags {
    No_Semicolon;
    No_Indent;
    In_Struct;
    In_Function_Args;
    Is_Global;
    No_Argument_Defaults;
    Keep_Pointer_to_Value;
}

print_declaration_to_builder :: (builder: *String_Builder, decl: *Declaration, flags: Print_Decl_Flags = 0, bitfield_context: *Bitfield_Info = null) {
    if !(flags & .No_Indent) print_indentation(builder);

    if decl.kind == .FUNCTION {
        func := cast(*Function)decl;
        for context.compiler.global_scope.members {
            if it.kind == .STRUCT {
                // print("str: %, decl: ^%\n", it.name, decl.name);
                if it.name == decl.name {
                    print("renaming: %\n", decl.name);
                    decl.name = sprint("_%", decl.name); // @HACK
                    break;
                }
            }
        }

        // Comment out "stripped" functions in the output
        close_comment := true;
        if context.opts.strip_flags & .Functions_With_Bodies && func.body {
            append(builder, "/* (jaicc: omitted inline function)\n");
            print_indentation(builder);
        } else if context.opts.strip_flags & .Functions_With_valist && function_has_a_valist_arg(func) {
            append(builder, "/* (jaicc: omitted function with valist)\n");
            print_indentation(builder);
        } else if context.opts.strip_flags & .Functions_With_Unknown_Foreign_Libs && function_is_missing_foreign_library(func) {
            append(builder, "/* (jaicc: function missing foreign lib)\n");
            print_indentation(builder);
        } else {
            context.compiler.counts.functions += 1;
            close_comment = false;
        }

        print_function(builder, func);

        if close_comment {
            append(builder, "\n");
            print_indentation(builder);
            append(builder, "*/\n");
        }

    }
    else if decl.kind == .ENUM print_enum(builder, cast(*Enum) decl);
    else if decl.kind == .TYPEDEF print_typedef(builder, cast(*Typedef) decl);
    else if decl.kind == .STRUCT {
        print_struct(builder, cast(*Struct) decl);
        context.compiler.counts.structs += 1;
    }
    else if decl.kind == .NAMESPACE print_namespace(builder, cast(*Namespace) decl);
    else if decl.kind == .DECLARATION {
        if flags & .Is_Global && context.opts.omit_global_declarations {
            // Skip global declarations if we were asked to.
            return;
        }

        // If we are generating a "defaults wrapper", and the argument type is a C++ reference,
        // we change the Jai facing wrapper function to a value, which can have a default value.
        // the inner function then takes a pointer to that value. This preserves the ability
        // to have defaults for reference arguments.
        type_to_print := decl.type;
        if decl.decl_flags & .Pointer_To_Value && decl.type.pointer_to && !(flags & .Keep_Pointer_to_Value)
            type_to_print = decl.type.pointer_to;

        // @Hack we may need a higher level contruct to handle translating names that conflict with non-overridable keywords
        if      decl.name == "context"         decl.name = "_context";
        else if decl.name == "null"            decl.name = "_null";
        else if decl.name == "type_info"       decl.name = "_type_info";
        else if decl.name == "cast"            decl.name = "_cast";

        if decl.qualifer_using append(builder, "using ");

        decl_name := decl.name;

        // Fields cannot have the same name as their type, so here we
        // append a _ character to the field name if we find that case.
        //
        // TODO: there should probably be some kind of place for the user
        // to resolve this conflict here instead?
        for context.compiler.global_scope.members {
            if stripped_name(it) == decl_name {
                decl_name = tprint("%_", decl_name);
                break;
            }
        }
        decl.outputted_jai_name = decl_name;

        // Handle bitfields by emitting "#place" before declarations. This will at least preserve
        // the correct size of structs.
        //
        // TODO: we should rename the fields so that Jai consumers of the
        // library don't use the full-width variable instead. Perhaps we could
        // also automatically generate getters and setters? Or one getter and
        // setter with an enum_flag?
        place := "";
        if bitfield_context != null {
            using bitfield_context;
            if decl.bitfield_width != -1 {
                //print("bitfield_width is % in %\n", decl.bitfield_width, decl_name);
                assert(decl.bitfield_width != 0, "TODO: implement zero-width bitfields");

                types_match :: (a: *CType, b: *CType) -> bool {
                    if a == b return true;
                    if a.type_of_typedef && b.type_of_typedef return a.type_of_typedef == b.type_of_typedef;
                    if a.hardcoded_jai_string && b.hardcoded_jai_string return a.hardcoded_jai_string == b.hardcoded_jai_string;
                    return false;
                }

                if watermark != -1 && first_decl && types_match(first_decl.type, decl.type) && decl.bitfield_width + watermark <= first_decl.type.size * 8 {
                    place = tprint("#place %; /*bitfield %*/ ", bitfield_context.first_decl.outputted_jai_name, bitfield_context.watermark);
                    watermark += decl.bitfield_width;
                } else {
                    watermark = decl.bitfield_width;
                    first_decl = decl;
                }
            } else {
                bitfield_context.watermark = -1;
                bitfield_context.first_decl = null;
            }
        }

        if place.count > 0 {
            append(builder, place);
            print_indentation(builder);
        }

        type_str := type_to_string(type_to_print, flags);
        defer free(type_str);
        print_to_builder(builder, "%: %", decl_name, type_str);

        if !(flags & .No_Argument_Defaults) && decl.expression {
            append(builder, " = ");

            temp_builder: String_Builder;
            temp_builder.allocator = __temporary_allocator;
            did_print_unary_enum := print_literal_to_builder(*temp_builder, cast(*Literal) decl.expression, decl.type);

            if decl.decl_flags & .Needs_Default_Argument_Cast && !did_print_unary_enum {
                append(builder, "cast(");
                print_type_to_builder(builder, decl.type);
                append(builder, ")");
            }

            append(builder, builder_to_string(*temp_builder, __temporary_allocator));
        }
        if !(flags & .No_Semicolon) append(builder, ";");
    } else {
        print("Unhandled type in print_declaration_to_builder: %\n", decl.kind);
    }
}

print_objc_selector_identifier :: (builder: *String_Builder, ident: string) {
    arr: [] u8;
    arr.data = ident.data;
    arr.count = ident.count;
    for arr {
        if it == #char ":" {
            append(builder, "_");
        } else {
            s: string;
            s.data = *it;
            s.count = 1;
            append(builder, s);
        }
    }
}

function_is_missing_foreign_library :: (func: *Function) -> bool {
    return !func.is_virtual && !func.body && !func.is_objc_binding && func.library == null;
}

print_block :: (builder: *String_Builder, block: *Block) {
    // TODO
}

print_function :: (builder: *String_Builder, func: *Function) {
    name := stripped_name(func);
    replace_chars(name, " ", #char "_");

    // We optionally allow the user to override what the arguments to functions look like.
    get_func_args_for_printing := context.opts.get_func_args_for_printing;
    if !get_func_args_for_printing
        get_func_args_for_printing = _default_get_func_args_for_printing;

    omit_function_defaults := false;
    if func.decl_flags & .Needs_Argument_Wrapper {
        // Here we generate a wrapper around the actual foreign function, so
        // that we can preserve the defaults from the original source.  This is
        // a workaround until Jai default values can be pointers to constant
        // things.
        print_to_builder(builder, "% :: (", name);

        wrapper_args := get_func_args_for_printing(func, .Outer_Wrapper);
        for wrapper_args {
            print_declaration_to_builder(builder, it, flags=Print_Decl_Flags.No_Semicolon | .No_Indent | .In_Function_Args);
            if (it_index < wrapper_args.count - 1) || func.is_variadic append(builder, ", ");
        }
        if func.is_variadic
            append(builder, "__args: ..Any");

        if func.return_type != context.compiler.type_def_void {
            return_str := type_to_string(func.return_type);
            defer free(return_str);
            print_to_builder(builder, ") -> % ", return_str);
            append(builder, "{\n");
        } else {
            append(builder, ") {\n");
        }

        context.compiler.tab_depth += 1;
        print_indentation(builder);

        // change the #foreign function name to something we'll call only
        // inside this wrapper function. TODO: actually find a unique name
        name = tprint("%_internal", name);
        omit_function_defaults = true;
    }
    defer {
        // close out the function wrapper after we output the "real" library
        // function
        if func.decl_flags & .Needs_Argument_Wrapper {
            append(builder, "\n");
            print_indentation(builder);
            if func.return_type != context.compiler.type_def_void {
                append(builder, "return ");
            }
            print_to_builder(builder, "%(", name);
            inner_wrapper_args := get_func_args_for_printing(func, .Inner_Wrapper_Call);
            for inner_wrapper_args {
                if it.decl_flags & .Pointer_To_Value
                    append(builder, "*");
                append(builder, it.name);
                if it_index != inner_wrapper_args.count - 1 append(builder, ", ");
            }
            append(builder, ");\n");
            context.compiler.tab_depth -= 1;
            print_indentation(builder);
            append(builder, "}");
        }
    }

    if func.is_virtual
        print_to_builder(builder, "% : (", name);
    else
        print_to_builder(builder, "% :: (", name);

    print_arg_flags := Print_Decl_Flags.No_Semicolon | .No_Indent | .In_Function_Args;
    if omit_function_defaults {
        print_arg_flags |= .No_Argument_Defaults;
        print_arg_flags |= .Keep_Pointer_to_Value; // insde the wrapper, the foreign function needs to print it's original type.
    }

    foreign_func_args := get_func_args_for_printing(func, .Foreign_Func_Declaration);
    for foreign_func_args {
        print_declaration_to_builder(builder, it, flags=print_arg_flags);
        if (it_index < foreign_func_args.count - 1) || func.is_variadic append(builder, ", ");
    }

    if func.is_variadic
        append(builder, "__args: ..Any");


    return_str := type_to_string(func.return_type);
    defer free(return_str);
    print_to_builder(builder, ") -> % ", return_str);

    if func.is_virtual {
        // This is a function pointer, so no need to specify the binding.
        append(builder, "#cpp_method;\n");
    } else if func.body {
        if   func.is_cpp_method append(builder, "#cpp_method");
        else                    append(builder, "#c_call");

        append(builder, " {\n");
        context.compiler.tab_depth += 1;
        print_block(builder, func.body);
        context.compiler.tab_depth -= 1;

        print_indentation(builder);
        append(builder, "}");
    } else if func.is_objc_binding {
        // this is an intrinsic to call objc_msgSend
        print_to_builder(builder, "{\n");
        context.compiler.tab_depth += 1;
        print_indentation(builder);
        print_to_builder(builder, "_func: (obj: *void, selector: *void");

        if !func.is_objc_class_method {
            if (func.arguments.count-1) > 0 append(builder, ", ");

            for func.arguments {
                if it_index == 0 continue; // skip the self parameter

                print_declaration_to_builder(builder, it, Print_Decl_Flags.No_Semicolon | .No_Indent);

                if (it_index < func.arguments.count-1) || func.is_variadic append(builder, ", ");
            }
        } else {
            if func.arguments.count > 0 append(builder, ", ");

            for func.arguments {
                print_declaration_to_builder(builder, it, Print_Decl_Flags.No_Semicolon | .No_Indent);


                if (it_index < func.arguments.count-1) || func.is_variadic append(builder, ", ");
            }
        }

        // @TODO figure out when to use objc_msgSend or objc_msgSend_fpret, or whatever, maybe libclang has facility for this?
        print_to_builder(builder, ") -> % #foreign;\n", return_str);
        print_indentation(builder); print_to_builder(builder, "_func = xx objc_msgSend;\n");

        print_indentation(builder);
        if func.return_type != context.compiler.type_def_void {
            print_to_builder(builder,  "return ");
        }

        if !func.is_objc_class_method {
            print_to_builder(builder, "_func(%, __selectors.", func.arguments[0].name);
        } else {
            print_to_builder(builder, "_func(objc_getClass(\"%\"), __selectors.", func.objc_class_method_struct.name);
        }
        print_objc_selector_identifier(builder, func.foreign_function_name);
        // forward function parameters
        if !func.is_objc_class_method {
            if (func.arguments.count-1) > 0 append(builder, ", ");

            for func.arguments {
                if it_index == 0 continue;

                print_to_builder(builder, it.name);
                if (it_index < func.arguments.count-1) || func.is_variadic append(builder, ", ");
            }
        } else {
            if func.arguments.count > 0 append(builder, ", ");
            for func.arguments {
                print_to_builder(builder, it.name);
                if (it_index < func.arguments.count-1) || func.is_variadic append(builder, ", ");
            }
        }
        print_to_builder(builder, ");\n");

        context.compiler.tab_depth -= 1;
        print_indentation(builder); print_to_builder(builder, "}\n");

    } else {
        lib_name := "__UnknownLib";
        if func.library {
            lib_name = func.library.name;
        } else {
            // TODO: a lot of these are functions defined as static, I think.
            // static as in private, not as in "instance-less."
            // we could know that and skip them, and avoid the verbose error
            // messages.
            error("Could not find library for function % (%)\n", func.name, func.foreign_function_name);
        }

        calling_conv := "#foreign";
        if func.is_cpp_method
            calling_conv = "#cpp_method #foreign";
        else if func.return_type != context.compiler.type_def_void {
            // For functions returning structs with constructors, we need to have the Jai compiler know via a directive,
            // since it changes the calling convention. Google "C++ Return Value Optimization" for details.
            if func.return_type.type_of_struct && func.return_type.type_of_struct.flags & .HAS_CONSTRUCTOR {
                calling_conv = "#cpp_return_type_is_non_pod #foreign";
            }
        }

        print_to_builder(builder, "% %", calling_conv, lib_name);

        if func.foreign_function_name && name != func.foreign_function_name {
            print_to_builder(builder, " \"%\"", func.foreign_function_name);
        }
        append(builder, ";");
    }
}

get_enum_value_name :: (en: *Enum, it: Enum.Enumerate) -> string {
    name := it.name;

    if context.opts.strip_enum_values_with_suffix.count > 0
        if ends_with(name, context.opts.strip_enum_values_with_suffix)
            return "";

    for context.opts.strip_enum_value_prefixes if it[0] == en.name
        if begins_with(name, it[1])
            advance(*name, it[1].count);

    if context.opts.strip_enum_prefixes && begins_with(name, en.name) {
        advance(*name, en.name.count);
        if begins_with(name, "_")
            advance(*name, 1);
    }

    return name;
}

print_enum :: (builder: *String_Builder, en: *Enum) {
    if context.opts.c_enum_emulation
        append(builder, "using ");

    type_str := type_to_string(en.type);
    defer free(type_str);
    print_to_builder(builder, "% :: enum % {\n", stripped_name(en), type_str);
    is_signed := en.type.number_flags & Number_Flags.SIGNED;
    context.compiler.tab_depth += 1;
    for en.enumerates {
        name := get_enum_value_name(en, it);
        if !name continue;
        print_indentation(builder);
        if is_signed print_to_builder(builder, "% :: %;\n", name, cast(s64) it.value);
        else print_to_builder(builder, "% :: %;\n", name, cast(u64) it.value);
    }
    context.compiler.tab_depth -= 1;
    context.compiler.counts.enums += 1;
    print_indentation(builder);
    append(builder, "}");
}

replace_typename :: (name: string) -> string {
    for context.opts.type_replacements if it[0] == name
        return it[1];

    return name;
}

stripped_name :: (decl: *Declaration) -> string {
    assert(decl != null);
    if decl.output_name return stripped_name(decl.output_name);
    return stripped_name(decl.name);
}

stripped_name :: (name: string) -> string {
    if context.opts.strip_prefix.count == 0 || name.count == 0 || name.count <= context.opts.strip_prefix.count
        return name;

    stripped := name;
    if begins_with(name, context.opts.strip_prefix) {
        advance(*stripped, context.opts.strip_prefix.count);
        
        if stripped.count > 0 && stripped[0] == #char "_"
            advance(*stripped, 1);
    }

    return stripped;
}

print_struct :: (builder: *String_Builder, str: *Struct) {
    struct_type := "struct";
    if str.flags & str.flags.IS_UNION struct_type = "union";

    name := stripped_name(str.name);

    if str.template_type_params.count > 0 {
        template_types: [..]string;
        template_types.allocator = __temporary_allocator;
        for str.template_type_params {
            type_string := "Type";
            if it.type {
                //print("name: %, type: %\n", it.name, <<it.type);
                type_string = type_to_string(it.type);
            }

            array_add(*template_types, tprint("%: %", it.name, type_string));
        }

        struct_type = tprint("%(%)", struct_type, join(..template_types, separator=", "));
    }

    if name && !(str.flags & str.flags.IS_ANON) {
        print_to_builder(builder, "% :: % {\n", name, struct_type);
    } else {
        assert((str.flags & str.flags.IS_ANON) == str.flags.IS_ANON);
        if (str.do_not_print_anon) return;

        print_to_builder(builder, "% {\n", struct_type);
    }


    context.compiler.tab_depth += 1;

    if str.vtable {
        print_indentation(builder);
        print_to_builder(builder, "using vtable : * struct {\n");
        context.compiler.tab_depth += 1;
        for str.vtable {
            print_declaration_to_builder(builder, it, .In_Struct);
            append(builder, "\n");
        }
        context.compiler.tab_depth -= 1;
        print_indentation(builder);
        print_to_builder(builder, "};\n");
    }

    bitfield_info: Bitfield_Info;
    printed_count := 0;
    for str.declarations {
        if (context.opts.strip_flags & .Constructors) && it.kind == .FUNCTION && (cast(*Function)it).is_constructor {
            continue;
        }
        if it.storage_class == .CX_SC_Static {
            //print("skipping static field %\n", it.name);
            continue;
        }
        print_declaration_to_builder(builder, it, .In_Struct, *bitfield_info);
        append(builder, "\n");
        printed_count += 1;
    }

    if printed_count == 0 && str.type.size == 1 {
        append(builder,  "__empty_struct_padding: u8; // C++ makes empty structs have length 1\n");
    }

    context.compiler.tab_depth -= 1;
    print_indentation(builder);
    append(builder, "}");

    if str.name && str.template_type_params.count == 0 && !(str.flags & .IS_ANON) {
        append(builder, "\n");
        if !context.opts.generate_static_struct_size_checks
            append(builder, "// ");
        print_to_builder(builder, "#run check_size(%, %);", stripped_name(str.name), str.type.size);
    }
}

Bitfield_Info :: struct {
    first_decl: *Declaration;
    watermark: int = -1;
}

print_namespace :: (builder: *String_Builder, ns: *Namespace) {
    should_flatten := array_find(context.opts.flatten_namespaces, ns.name);

    if should_flatten append(builder, "// ");
    print_to_builder(builder, "% :: struct {", ns.name);
    if should_flatten append(builder, " // this namespace was flattened by '--flatten-namespace'");

    append(builder, "\n");

    context.compiler.tab_depth += 1;
    for ns.declarations {
        print_declaration_to_builder(builder, it);
        append(builder, "\n");
    }
    context.compiler.tab_depth -= 1;

    print_indentation(builder);

    if should_flatten append(builder, "// ");
    append(builder, "}");
}

print_typedef :: (builder: *String_Builder, def: *Typedef) {
    type_str := type_to_string(def.type);
    defer free(type_str);
    
    // filter out cases where the typedef is the same name as the struct/enum/etc:
    // typedef struct My_Struct {...} My_Struct;
    if stripped_name(def.name) == type_str return;

    print_to_builder(builder, "% :: %;", stripped_name(def.name), type_str);
}

error :: (msg: string, args: ..Any) {
    print(msg, ..args);
}

error :: (cur: CXCursor, msg: string, args: ..Any) {
    loc := clang_getCursorLocation(cur);
    file: CXFile;
    line: u32;
    column: u32;
    offset: u32; // byte offset into file ??
    clang_getSpellingLocation(loc, *file, *line, *column, *offset);

    filename := copy_and_dispose(clang_getFileName(file));
    defer free(filename);
    print("%:%:%: ", filename, line, column);
    error(msg, ..args);
}

#if OS == .WINDOWS {
    DLL_SUFFIX :: ".dll";
    PATH_SEPARATOR_STRING :: "\\";
} else #if OS == .LINUX {
    DLL_SUFFIX :: ".so";
    PATH_SEPARATOR_STRING :: "/";
} else #if OS == .MACOS {
    DLL_SUFFIX :: ".dylib";
    PATH_SEPARATOR_STRING :: "/";
}

os_load_library_helper :: (paths_in: [] string, name: string) -> type_of(Library_Info.handle) {
    handle: type_of(Library_Info.handle);

    paths := paths_in;
    if paths.count == 0 {
        paths = string.["."];
    }

    for paths {
        tpath := concatenate(it, PATH_SEPARATOR_STRING, name, "\0");
        print("full path: %\n", tpath);
        wide_path_data, success, w_len := utf8_to_wide(tpath);
        assert(success);

        #if OS == .WINDOWS {
            buffer: [MAX_PATH] u16;
            length := GetFullPathNameW(wide_path_data, buffer.count, xx buffer.data, null);
            free(tpath);
            handle = LoadLibraryExW(buffer.data, null, 0);
        } else #if OS == .LINUX || OS == .MACOS {
            rpath := realpath(tpath.data, null);
            defer free(rpath);
            if rpath handle = dlopen(rpath, RTLD_LAZY);
        }

        if handle break;
    }

    return handle;
}

os_load_library :: (paths: [] string, name: string) -> type_of(Library_Info.handle), is_system: bool {
    suf := concatenate(name, DLL_SUFFIX);
    defer free(suf);

    handle := os_load_library_helper(paths, suf);
    if handle return handle, false;

    // if !handle {
    //     #if OS == .WINDOWS {
    //         handle = LoadLibraryW(utf8_to_wide(name));
    //     } else #if OS == .LINUX || OS_MACOSX {
    //         handle = dlopen(to_c_string(name), RTLD_LAZY); // @Leak ?
    //     }

    //     print("% is system\n", name);
    //     return handle, true;
    // }

    print("Could not load dynamic library: '%'\n", name);
    exit(1);
    dummy: type_of(Library_Info.handle);
    return dummy, false;
}

os_symbol_exists_in_library :: (lib: *Library_Info, name: string) -> bool {
    str := to_c_string(name);
    defer free(str);
    #if OS == .WINDOWS {
        proc := GetProcAddress(lib.handle, str);
    } else #if OS == .LINUX || OS == .MACOS {
        proc := dlsym(lib.handle, str);
    }
    return proc != null;
}

find_lib_for_function_name :: (name: string) -> *Library_Info {
    for context.compiler.libraries {
        if os_symbol_exists_in_library(it, name) return it;
    }
    return null;
}

make_valid_identifer :: (str: string) -> string {
    s := copy_string(str);
    replace_chars(s, "-", #char "_");
    return s;
}

Generate_Bindings_Options :: struct {
    // ## What jai file to generate
    output_filename := "out.jai";

    // ## Input options for clang
    libraries: [..]Library_Info;
    libnames: [..]string;
    libpaths: [..]string;
    include_paths: [..]string;
    source_files: [..]string;
    extra_clang_arguments: [..]string;


    // ## Options to change the generated output.

    // A list of namespaces to flatten. Normally namespace become structs with
    // functions, but any namespaces in this list will have their functions
    // just become global declarations.
    flatten_namespaces:            [..]string;

    // A common prefix to strip from functions and structs.
    strip_prefix:                  string;

    strip_enum_prefixes            := true;
    strip_enum_values_with_suffix: string;
    strip_enum_value_prefixes:     [..][2]string;

    // Jai cannot currently link to global variables declared in libraries. When true, any global variables will be omitted.
    omit_global_declarations       := true;

    type_replacements:             [..][2]string;

    strip_flags := Strip_Flags.Constructors | .Destructors |
        .Functions_With_Bodies | .Functions_With_valist |
        .Functions_With_Unknown_Foreign_Libs;
    print_foreign_library_declarations := true;

    // Any extra code to include.
    preamble := "";

    c_enum_emulation := false; // use 'using' on each enum declaration to bring all its members into scope
    generate_static_struct_size_checks := false;

    //
    // Optionally give it whatever data you like. Will be passed to callback functions.
    //
    user_data: *void;

    // ## Callback functions

    get_func_args_for_printing: Get_Function_Arguments_For_Printing_Func;
    will_print_bindings: #type ();

    // debug
    inspect_entities_named: [..]string;
}

generate_bindings :: (opts: Generate_Bindings_Options) -> (has_error: bool) {
    has_error := false;
    if context.compiler free(context.compiler);
    context.compiler = New(type_of(<<context.compiler));
    init_compiler_context(*context);
    context.opts = opts;

    //print("OPTS:\n%\n", formatStruct(context.opts, use_newlines_if_long_form=true));

    //assert(*context.global_scope.members == *context.compiler.global_scope.members); // Jai compiler bug
    //print("first global_scope.members: %\n", *context.compiler.global_scope.members);

    for context.opts.libraries {
        ptr := New(Library_Info);
        (<<ptr) = it;
        ptr.handle, ptr.is_system = os_load_library(.[], ptr.path);
        array_add(*context.compiler.libraries, ptr);
    }

    for context.opts.libnames {
        lib := New(Library_Info);
        lib.name = make_valid_identifer(it);
        lib.path = it;
        lib.handle, lib.is_system = os_load_library(context.opts.libpaths, lib.path);
        if !lib.handle {
            print("Could not load library: '%'\n", lib.name);
            continue;
        }
        array_add(*context.compiler.libraries, lib);
    }

    index := clang_createIndex(0, 0);
    defer clang_disposeIndex(index);
 
    // assemble an array of c-string arguments to pass to clang
    argv: [..]*u8;
    {
        for opts.include_paths         array_add(*argv, to_c_string(tprint("-I%", it)));
        for opts.extra_clang_arguments array_add(*argv, to_c_string(it));
        for opts.source_files          array_add(*argv, to_c_string(it));
    }

    tu: CXTranslationUnit;
    err := clang_parseTranslationUnit2(index, null, argv.data, xx argv.count, null, 0, 0, *tu);
    defer clang_disposeTranslationUnit(tu);

    if err != 0 {
        print("Clang returned errror code %\n", err);
        has_error = true;
    }

    for 1..clang_getNumDiagnostics(tu) {
        diag := clang_getDiagnostic(tu, it - 1);

        severity := clang_getDiagnosticSeverity(diag);
        if severity == .CXDiagnostic_Error || severity == .CXDiagnostic_Fatal {
            has_error = true;
        }
        str := clang_formatDiagnostic(diag, clang_defaultDiagnosticDisplayOptions());
        msg := to_string(clang_getCString(str));
        print("%", msg);
        clang_disposeString(str);
    }

    if !has_error {
        cursor := clang_getTranslationUnitCursor(tu);
        context.compiler.translation_unit = tu;
        jai_ctx := context;
        clang_visitChildren(cursor, handle_toplevel_cursors, *jai_ctx);

        if context.opts.will_print_bindings
            context.opts.will_print_bindings();

        builder: String_Builder;
        print_to_builder(*builder, #string END
//
// This file was autogenerated.
//
END);
        append(*builder, context.opts.preamble);
        append(*builder, "\n\n");
        print_to_builder(*builder, #string END
#scope_file

#import "Basic";
// TODO: these manual types shouldn't be necessary
size_t   :: u64;
FILE     :: struct { opaque: *void; }
FLT_MIN  :: 0h00800000;
FLT_MAX  :: 0h7F7FFFFF;

check_size :: ($T: Type, expected_size_in_bytes: int, loc := #caller_location) {
    size_of_struct := size_of(T);
    Compiler :: #import "Compiler";
    if size_of_struct != expected_size_in_bytes {
        msg := tprint("expected struct '%%' to be %% bytes, but it was %% instead.", T, expected_size_in_bytes, size_of_struct);
        Compiler.compiler_report(msg, loc=loc);
    }
}

#scope_export
END);
        if context.opts.print_foreign_library_declarations {
            for context.compiler.libraries {
                if it.is_system print_to_builder(*builder, "% :: #foreign_system_library \"%\";\n", it.name, it.path);
                else print_to_builder(*builder, "% :: #foreign_library \"%\";\n", it.name, it.path);
            }
        }

        print("printing % global scope members...\n", context.compiler.global_scope.members.count);
        for context.compiler.global_scope.members {
            if it.decl_flags & .Omit_From_Output continue;
            print_declaration_to_builder(*builder, it, flags=.Is_Global);
            append(*builder, "\n\n");
        }

        if context.compiler.unique_objc_selectors.count {
            append(*builder, "#scope_file\n\n");
            append(*builder, "_Generated_Selectors :: struct {\n");
            context.compiler.tab_depth += 1;
            for context.compiler.unique_objc_selectors {
                print_indentation(*builder);
                print_objc_selector_identifier(*builder, it);
                append(*builder, ": *void = ---;\n");
            }

            print_indentation(*builder);
            append(*builder, "#constructor (this: *_Generated_Selectors) {\n");
            context.compiler.tab_depth += 1;
            for context.compiler.unique_objc_selectors {
                print_indentation(*builder);
                append(*builder, "this.");
                print_objc_selector_identifier(*builder, it);
                print_to_builder(*builder, " = sel_registerName(\"%\");\n", it);
            }
            context.compiler.tab_depth -= 1;
            print_indentation(*builder); append(*builder, "};\n");

            context.compiler.tab_depth += -1;
            append(*builder, "}\n");
            append(*builder, "__selectors: _Generated_Selectors;\n");
        }

        // write_builder(*builder);

        file, success := file_open(opts.output_filename, true);
        if !success {
            error("Error: Could not open file for output: '%'\n", opts.output_filename);
            has_error = true;
        } else {
            str := builder_to_string(*builder);
            file_write(*file, str);
            file_close(*file);
            free(str);
        }
    }

    return has_error;
}

show_jaicc_results :: () {
    using context;
    print("\nOK! generated '%' from %\n", opts.output_filename, join(..opts.source_files, separator=", "));
    {
        print("    % functions\n", compiler.counts.functions);
        print("    % structs\n",   compiler.counts.structs);
        print("    % enums\n",     compiler.counts.enums);
    }
}

raw_tokens_string_from_cursor :: (cur: CXCursor, separator := "") -> string {
    //
    // Return the raw tokens as a string from a cursor's range.
    //
    range := clang_getCursorExtent(cur);
    tokens: *CXToken;
    num_tokens: u32;
    clang_tokenize(context.compiler.translation_unit, range, *tokens, *num_tokens);
    if tokens == null {
        //error(cur, tprint("could not tokenize '%' %\n", as_str(cur), cur));
        return "";
    }
    token_sb: String_Builder;
    for tt: 0..num_tokens - 1 {
        spelling := clang_getTokenSpelling(context.compiler.translation_unit, tokens[tt]);
        append(*token_sb, to_string(clang_getCString(spelling)));
        if separator.count && tt != num_tokens - 1
            append(*token_sb, separator);
        clang_disposeString(spelling);
    }

    return builder_to_string(*token_sb);
}

#scope_file
copy_and_dispose :: (str: CXString) -> string {
    copy := copy_string(to_string(clang_getCString(str)));
    clang_disposeString(str);
    return copy;
}

get_children :: (cur: CXCursor) -> [..] CXCursor {
    Visitor_Data :: struct {
        arr: [..]CXCursor;
        jai_context: Context;
    }

    child_visitor :: (cur: CXCursor, parent: CXCursor, client_data: CXClientData) -> CXChildVisitResult #c_call {
        visitor_data := cast(*Visitor_Data)client_data;
        push_context visitor_data.jai_context {
            array_add(*visitor_data.arr, cur);
            return CXChildVisit_Continue;
        }
    }

    visitor_data: Visitor_Data;
    visitor_data.jai_context = context;
    clang_visitChildren(cur, child_visitor, *visitor_data);
    return visitor_data.arr;
}

get_hash_cxcursor :: (cur: CXCursor) -> u32 {
    return clang_hashCursor(cur);
}

compare_cxcursors :: (cur0: CXCursor, cur1: CXCursor) -> bool {
    return clang_equalCursors(cur0, cur1) != 0;
}

show_cursor_info :: (cur: CXCursor, parent: CXCursor) {
    ref_cursor := clang_getCursorDefinition(cur);
    _cur_type := clang_getCursorType(cur);
    is_pointer := clang_getPointeeType(_cur_type);
    is_const_ref := false;
    if is_pointer.kind
        is_const_ref = !!clang_isConstQualifiedType(is_pointer);

    print("parent '%' meet child '%' with kind % ref name % is_const % is_reference % is_volatile % is_pointer % is_const_ref %\n",
        as_str(parent), as_str(cur), clang_getCursorKind(cur),
        as_str(ref_cursor), clang_isConstQualifiedType(_cur_type),
        _cur_type.kind == CXType_LValueReference,
        clang_isVolatileQualifiedType(_cur_type), is_pointer, is_const_ref);

    tee_template_arg_num := clang_Type_getNumTemplateArguments(is_pointer);
    if tee_template_arg_num != -1 {
        print("pointee % is template\n", is_pointer);
        for i: 0..tee_template_arg_num-1 {
            print("pointee template arg %  has type %\n", i, as_str(clang_Type_getTemplateArgumentAsType(is_pointer, cast(u32)i)));
        }
    }

    template_arg_num := clang_Type_getNumTemplateArguments(_cur_type);
    if template_arg_num != -1 {
        print("% is template\n", as_str(_cur_type));
        for i: 0..template_arg_num-1 {
            print("template arg % has type %\n", i, as_str(clang_Type_getTemplateArgumentAsType(_cur_type, cast(u32)i)));
        }
    }
}

recursive_print_anything_under_cursor :: (_in_cursor: CXCursor) {
    ctx := context;
    visitor(_in_cursor, .{}, *ctx);
	clang_visitChildren(_in_cursor, visitor, *ctx);
    visitor :: (cur: CXCursor, parent: CXCursor, data: CXClientData) -> CXChildVisitResult #c_call {
        push_context <<cast(*Context)data {
            show_cursor_info(cur, parent);
            return .CXChildVisit_Recurse;
        }
	}
}

