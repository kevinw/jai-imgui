#scope_export

Struct_Looks_Like :: enum {
    None      :: 0;
    Float2    :: 2;
    Float3    :: 3;
    Float4    :: 4;
    Matrix4x4 :: 16;

    Int2      :: 102; // TODO: return these from categorize_ti_struct
    Int3      :: 103;
    Int4      :: 104;

    Color_Float4 :: 1004;
    Color_Byte4  :: 1104;

    Has_Custom_Control :: 9999;
}

should_display_struct_member :: (member: *Type_Info_Struct_Member) -> bool {
    if member.flags & .CONSTANT != 0
        return false;

    for member.notes
        if it == "noui"
            return false;

    return true;
}

categorize_ti_struct :: (ti_struct: *Type_Info_Struct, categorize_type_func: Categorize_Type_Func) -> Struct_Looks_Like {

    if categorize_type_func != null {
        user_categorization := categorize_type_func(ti_struct);
        if user_categorization != .None
            return user_categorization;
    }

    // @Speed @Memoize

    num_floats: int;
    for uniquely_placed_members(ti_struct) {
        if it.type.type == {
            case .FLOAT; num_floats += 1;
            // case .INTEGER;  // TODO: do integer sizes 32, 64???
            case; return .None;
        }
    }

    if num_floats == {
        case 2;  return .Float2;
        case 3;  return .Float3;
        case 4;  return .Float4;
        case 16; return .Matrix4x4;
    }
}

#assert(categorize_ti_struct(cast(*Type_Info_Struct)type_info(Vector3), null) == .Float3);

Show_Node_Func :: #type (name: *u8, data: *void, info: *Type_Info) -> bool;
Categorize_Type_Func :: #type (ti: *Type_Info) -> Struct_Looks_Like;
Custom_Ctrl_Func :: #type (name: string, data: *void, ti_info: *Type_Info);

inspect :: inline (name: *u8, t: *$T, show_node_func: Show_Node_Func = null, categorize_type_func: Categorize_Type_Func = null, custom_ctrl: Custom_Ctrl_Func = null) {
    inspect(name, t, type_info(T), show_node_func, categorize_type_func, custom_ctrl);
}

inspect :: (name: *u8, data: *void, info:*Type_Info, show_node_func: Show_Node_Func = null, categorize_type_func: Categorize_Type_Func = null, custom_ctrl: Custom_Ctrl_Func = null) {
    using ImGui;

    if show_node_func != null && !show_node_func(name, data, info)
        return;

    default_size:ImVec2;

    PushID(data);
    defer PopID();

    if #complete info.type == {
        case .INTEGER;
            ti_int := cast(*Type_Info_Integer) info;
            data_type: DataType;
            if info.runtime_size == {
                case 1; data_type = ifx ti_int.signed then DataType.S8  else DataType.U8;
                case 2; data_type = ifx ti_int.signed then DataType.S16 else DataType.U16;
                case 4; data_type = ifx ti_int.signed then DataType.S32 else DataType.U32;
                case 8; data_type = ifx ti_int.signed then DataType.S64 else DataType.U64;
                case; assert(false, "don't know how to handle integer with Type_Info.runtime_size of %");
            }
            InputScalar(name, data_type, data);
        case .FLOAT;
            if info.runtime_size == {
                case 4;
                    //DragFloat(name, data, display_format="%.3f");
                    InputFloat(name, data, 0.01, 1.0);
                case 8;
                    x : float = xx <<cast(*float64) data;
                    if InputFloat(name, *x, 0.01, 1.0) { <<cast(*float64) data = x; };
            }
        case .BOOL;
            Checkbox(name, data);
        case .STRING;
            string_data := Reflection.get_string_data(data, xx info);
            string_count := Reflection.get_string_count(data, xx info);
            
            if string_data InputText(name, string_data, xx string_count, InputTextFlags.ReadOnly);    // @@ We could allow editing of strings too.
            else InputText(name, "(null)", 6, InputTextFlags.ReadOnly);
        case .POINTER;
            info_pointer := cast(*Type_Info_Pointer) info;
            assert(info_pointer.relative_pointer_size == 0, "implement relative pointers");

            next_data := <<(cast(**void)data);

            if next_data == null {
                if info_pointer.pointer_to.type == .STRUCT
                    TextUnformatted(tprint("%: (%)null", name, (cast(*Type_Info_Struct)info_pointer.pointer_to).name));
                else
                    TextUnformatted(tprint("%: null", name));
            } else
                inspect(name, next_data, info_pointer.pointer_to, show_node_func, categorize_type_func, custom_ctrl);
        case .PROCEDURE;
            TextUnformatted("TODO: procedure inspect");
        case .VOID;
            TextUnformatted(tprint("%: %", name, data));
        case .CODE;
            TextUnformatted("Code");
        case .STRUCT;
            ti_struct := cast(*Type_Info_Struct) info;

            category := categorize_ti_struct(ti_struct, categorize_type_func);
            if category == .Has_Custom_Control && custom_ctrl != null {
                custom_ctrl(to_string(name), data, ti_struct);
            } else {
                if category == {
                    case .Float2;
                        DragFloat2(name, cast(*[2]float)data);
                    case .Float3;
                        DragFloat3(name, cast(*[3]float)data);
                    case .Float4;
                        DragFloat4(name, cast(*[4]float)data);
                    case .Color_Byte4;
                        bytes := cast(*u8)data;
                        // TODO: no need to round trip to floats here; ImGui supports editing bytes with the .Uint8 flag
                        floats: [4]float;
                        for * floats { (<<it) = cast(float)(<<(bytes + it_index)) / cast(float)255; }
                        if ColorEdit4(name, *floats, ImGui.ColorEditFlags.Float | .NoInputs) {
                            for floats { <<(bytes + it_index) = cast(u8)(floats[it_index] * 255); }
                        }
                    case;
                        tree_node_str:string;
                        if name != null && str_length(name) > 0
                            tree_node_str = tprint("%: %\0", to_string(name), ti_struct.name);
                        else
                            tree_node_str = ti_struct.name;

                        //tree_node_flags := TreeNodeFlags.None;
                        //tree_node_flags := TreeNodeFlags.DefaultOpen;
                        tree_node_flags := TreeNodeFlags.CollapsingHeader | .DefaultOpen;
                        PushStyleColor(.Header, ImVec4.{0, 0, 0, 0});
                        if TreeNodeEx(tree_node_str.data, tree_node_flags) {
                            PopStyleColor();

                            for * member: uniquely_placed_members(ti_struct)
                                if should_display_struct_member(member)
                                    inspect(member.name.data, data + member.offset_in_bytes, member.type, show_node_func, categorize_type_func, custom_ctrl);

                            if tree_node_flags & .NoTreePushOnOpen == 0
                                TreePop();
                        } else {
                            PopStyleColor();
                        }
                }
            }
        case .ARRAY;
            info_array := cast(*Type_Info_Array) info;
            array_count, array_data := Reflection.get_array_count_and_data(data, info_array);
            array_name := to_string(name);
            element_size := info_array.element_type.runtime_size;            
            if TreeNode("% (count = %) ->", array_name, array_count) {
                defer TreePop();
                for 0..array_count-1 {
                    item_name := temp_c_string(tprint("%[%]", array_name, it));
                    inspect(item_name, array_data + it * element_size, info_array.element_type, show_node_func, categorize_type_func, custom_ctrl);
                }
            }
        case .ANY;
            // @@ Display type and inspect value.
            any := cast(*Any)data;
            inspect(name, any.value_pointer, any.type, show_node_func, categorize_type_func, custom_ctrl);
        case .ENUM;
            ti_enum := cast(*Type_Info_Enum)info;
            if ti_enum.enum_type_flags & .Is_Flags {
                // enum_flags
                if ti_enum.internal_type.runtime_size > 4 {
                    TextUnformatted("TODO: 64bit enum_flags");
                } else {
                    //any: Any;
                    //any.value_pointer = data;
                    //any.type = ti_enum;
                    //TextUnformatted(tprint("%: %", to_string(name), any));
                    TextUnformatted(to_string(name));

                    PushPopIndent(GetFrameHeight() * 0.5);
                    PushPopStyleVar(.ItemInnerSpacing, .{0, 0});
                    PushPopStyleVar(.FramePadding, .{0, 0});
                    for ti_enum.values {
                        if it == 0 continue;
                        CheckboxFlags(tprint(" %\0", ti_enum.names[it_index]).data, data, cast(u32)it);
                    }
                }
            } else { // a non-flags enum
                s64_val: s64;
                if ti_enum.internal_type.signed {
                    if ti_enum.internal_type.runtime_size == {
                        case 1; s64_val = <<cast(*s8)data;
                        case 2; s64_val = <<cast(*s16)data;
                        case 4; s64_val = <<cast(*s32)data;
                        case 8; s64_val = <<cast(*s64)data;
                    }
                }
                else {
                    if ti_enum.internal_type.runtime_size == {
                        case 1; s64_val = <<cast(*u8)data;
                        case 2; s64_val = <<cast(*u16)data;
                        case 4; s64_val = <<cast(*u32)data;
                        case 8; s64_val = cast(s64) <<cast(*u64)data;
                    }
                }

                value_name := "Unknown";
                for ti_enum.names
                    if s64_val == ti_enum.values[it_index]
                        value_name = it;

                if BeginCombo(name, to_temp_c_string(value_name)) {
                    defer EndCombo();

                    for ti_enum.names {
                        is_selected := s64_val == ti_enum.values[it_index];

                        if Selectable(to_temp_c_string(it), is_selected, size=default_size) {
                            new_val := ti_enum.values[it_index];
                            if ti_enum.internal_type.signed {
                                if ti_enum.internal_type.runtime_size == {
                                    case 1; <<cast(*s8)data  = xx new_val;
                                    case 2; <<cast(*s16)data = xx new_val;
                                    case 4; <<cast(*s32)data = xx new_val;
                                    case 8; <<cast(*s64)data = new_val;
                                    case; assert(false);
                                }
                            } else {
                                if ti_enum.internal_type.runtime_size == {
                                    case 1; <<cast(*u8)data  = xx new_val;
                                    case 2; <<cast(*u16)data = xx new_val;
                                    case 4; <<cast(*u32)data = xx new_val;
                                    case 8; <<cast(*u64)data = xx new_val;
                                    case; assert(false, "unexpected enum runtime_size: %", ti_enum.internal_type.runtime_size);
                                }
                            }
                        }

                        if is_selected
                            SetItemDefaultFocus();
                    }

                }
            }
            
        case .POLYMORPHIC_VARIABLE;
            // @@ ??
        case .TYPE;
            type_ti := << cast(**Type_Info)data;

            sb: String_Builder;
            sb.allocator = __temporary_allocator;
            print_type_to_builder(*sb, type_ti);
            s := builder_to_string(*sb, __temporary_allocator);

            TextUnformatted(tprint("%: Type %", to_string(name), s));
        case .OVERLOAD_SET;
            // @@
    }

}

#scope_file

uniquely_placed_members :: (ti_struct: *Type_Info_Struct) -> []Type_Info_Struct_Member {
    // skips struct members with #place modifiers
    // that place them at exactly the same byte
    // offset as a previous member.

    unique_members: [..]Type_Info_Struct_Member;
    unique_members.allocator = __temporary_allocator;

    seen_offsets: [..]int;
    seen_offsets.allocator = __temporary_allocator;

    for ti_struct.members
        if array_add_if_unique(*seen_offsets, it.offset_in_bytes)
            array_add(*unique_members, it);
    return unique_members;
}

Reflection :: #import "Reflection";
