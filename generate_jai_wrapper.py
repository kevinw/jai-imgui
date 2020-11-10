'''

Generates Jai bindings for imgui from the JSON emitted by the cimgui project.


TODO: RVO functions are failing. see http://www.cplusplus.com/forum/general/228878/

'''

import ast
import json
import sys
import operator as op
import os.path
import re
import subprocess
import itertools
import traceback

from collections import defaultdict, namedtuple
from pprint import pformat, pprint

OUTPUT_BINDINGS_JAI_FILE = "imgui.jai"
PATH_TO_IMGUI_DLL        = "win\\imgui.dll"
PATH_TO_CIMGUI           = "cimgui"
IMGUI_USE_WCHAR32        = False
SKIP_INTERNAL            = True
SKIP_PRIVATE_ENUMS       = True
STRIP_IMGUI_PREFIX       = True # If True, this generator will remove 'ImGui' from the beginning of all identifiers.
                                # note that Im like in `ImVector` remains.
ENUM_TYPE = "s32"               # all imgui enums are c ints

allow_internal = frozenset(["ImDrawListSharedData"])
skip_structs_for_size = frozenset(["ImGuiTextRange", "ImGuiStoragePair"])
diagnose_funcnames = frozenset(sys.argv[1:]) # pass additional args on the commandline to print extra info for structs or functions which are missing

exports_file = "imgui_exports.txt"

ArgInfo = namedtuple("ArgInfo", "name jai_arg_type default_str wrapper_arg_type call_arg_value meta")

# a regex for function pointers
fn_ptr_matcher = re.compile(r"(.+)\((?:__cdecl)?\*(\w+)?\)\s*\(([^\)]*)\)")

assert fn_ptr_matcher.match("foo (*)(bar)")
assert fn_ptr_matcher.match("foo(__cdecl*)(bar)")
assert fn_ptr_matcher.match("*void(*alloc_func)(int bar)")
assert fn_ptr_matcher.match("bool(*items_getter)(void* data,int idx,const char** out_text)")

# a regex for extracting DLL symbol names from the output of the Microsoft
# Visual Studio command line tool dumpbin.exe
export_line_regex = re.compile(r"(\d+)\s+([\da-fA-F]+)\s+([\da-fA-F]+)\s+([^ ]+) = ([^ ]+) \((.*)\)$")

# for extracting the array size from a field type like "TempBuffer[1024*3+1]"
arr_part_re = re.compile(r"(\w+)(?:\[([^\]]+)\])?")

# parses windows demangled symbol names from dumpbin.exe /exports
function_pattern = re.compile(r"""
^                                       # beginning of the string
(?:(?P<visibility>\w+):\ )?             # visibility like "public: "
(?P<retval>.*)                          # return value
(?:\ __cdecl\ )                         # calling convention
(?:(?P<nspace_or_stname>[\w\<\> ]+)::)? # namespace or struct name
(?P<fname>[\w\<\>~=\+\-\\\* ]+)         # function name
\(                                      # arguments in parentheses
    (?P<args>.*)
\)
(?P<const>const)?
$
""", re.VERBOSE)

jai_typedefs = dict(
    ImPoolIdx    = "s32",
    ImTextureID  = "*void",
    ImDrawIdx    = "u16",
    ImFileHandle = "*void",
    ImGuiID      = "u32",
    ID           = "u32", # TODO: don't repeat ID like this

    ImDrawCallback    = "#type (parent_list: *ImDrawList, cmd: *ImDrawCmd) #c_call",
    InputTextCallback = "#type (data: *InputTextCallbackData) -> s32 #c_call",
    SizeCallback      = "#type (data: *SizeCallbackData) #c_call",

    ImWchar16 = "u16",
    ImWchar32 = "u32",

)
def load_structs_and_enums():
    return json.load(open(f"{PATH_TO_CIMGUI}/generator/output/structs_and_enums.json", "r"))
def load_definitions():
    return json.load(open(f"{PATH_TO_CIMGUI}/generator/output/definitions.json", "r"))

inline_functions = dict(
    Viewport = [
        ("GetCenter",   ":: (using self: *Viewport) -> ImVec2 { return make_ImVec2(Pos.x + Size.x * 0.5, Pos.y + Size.y * 0.5); }"),
        ("GetWorkPos",  ":: (using self: *Viewport) -> ImVec2 { return make_ImVec2(Pos.x + WorkOffsetMin.x, Pos.y + WorkOffsetMin.y); }"),
        ("GetWorkSize", ":: (using self: *Viewport) -> ImVec2 { return make_ImVec2(Size.x - WorkOffsetMin.x + WorkOffsetMax.x, Size.y - WorkOffsetMin.y + WorkOffsetMax.y); } // This not clamped"),
    ]
)

extra_code = """
Context :: struct { data: *void; }

ImVector :: struct(T: Type) {
    Size:     s32;
    Capacity: s32;
    Data:     *T;
}

ImPool :: struct(T: Type) {
    Buf: ImVector(T);
    Map: ImGuiStorage;
    FreeIdx: ImPoolIdx;
}

ImChunkStream :: struct(T: Type) {
    Buf: ImVector(s8);
}

<type_definitions>

IMGUI_USE_WCHAR32 :: <IMGUI_USE_WCHAR32>; // TODO: Module parameter

#if IMGUI_USE_WCHAR32
    ImWchar :: ImWchar32;
else
    ImWchar :: ImWchar16;

make_ImVec2 :: inline (a: float, b: float) -> ImVec2 {
    v: ImVec2 = ---;
    v.x = a;
    v.y = b;
    return v;
}

TreeNode :: (fmt: string, args: ..Any) -> bool {
    fmt_z := tprint("%\\0", fmt);
    txt := tprint(fmt_z, ..args);
    return TreeNode(txt.data);
}



#scope_file

#import "Basic";

FLT_MAX :: 0h7F7FFFFF;

#if OS == .WINDOWS
    imgui_lib :: #foreign_library "win/imgui";
else
    #assert(false);

""".replace("ImGui", "" if STRIP_IMGUI_PREFIX else "ImGui")\
   .replace("<IMGUI_USE_WCHAR32>", "true" if IMGUI_USE_WCHAR32 else "false")\
   .replace("<type_definitions>", "\n".join(f"{key} :: {value};" for key, value in jai_typedefs.items()))

inline_functions_skipped = []
functions_skipped = []
stats = defaultdict(int)
ctx = dict()

type_replacements = [
    ("char const* *", "**u8"),
    ("unsigned char**", "**u8"),
    ("char const*", "*u8"),
    ("const char*", "*u8"),
    ("char*", "*u8"),
    ("unsigned short", "u16"),
    ("unsigned __int64", "u64"),
    ("short", "s16"),
    ("size_t", "u64"),
    ("signed char", "s8"),
    ("const char", "u8"),
    ("const ", ""),
    ("unsigned short", "u16"),
    ("unsigned int", "u32"),
    ("unsigned char", "u8"),
    ("char *", "*u8"),
    ("char", "s8"),
    ("long", "s32"),
    ("double", "float64"),
    ("int", "s32"),

    ("ImS8", "s8"),
    ("ImU8", "u8"),
    ("ImS16", "s16"),
    ("ImU16", "u16"),
    ("ImS32", "s32"),
    ("ImU32", "u32"),
    ("ImS64", "s64"),
    ("ImU64", "u64"),
]

def is_trivial_type_replacement(s):
    for cpp, jai in type_replacements:
        if cpp == s:
            return jai

def replace_types(s):
    for c_type, jai_type in type_replacements:
        s = re.sub(r"\b" + c_type.replace("*", "\\*") + r"\b", jai_type, s)
    return s

# supported operators
operators = {ast.Add: op.add, ast.Sub: op.sub, ast.Mult: op.mul,
             ast.Div: op.truediv, ast.Pow: op.pow, ast.BitXor: op.xor,
             ast.USub: op.neg}

def eval_expr(expr):
    """
    >>> eval_expr('2^6')
    4
    >>> eval_expr('2**6')
    64
    >>> eval_expr('1 + 2*3**(4^5) / (6 + -7)')
    -5.0
    """
    try:
        return eval_(ast.parse(expr, mode='eval').body)
    except TypeError:
        print("error parsing expression: " + expr, file=sys.stderr)
        raise

def eval_(node):
    if isinstance(node, ast.Num): # <number>
        return node.n
    elif isinstance(node, ast.BinOp): # <left> <operator> <right>
        return operators[type(node.op)](eval_(node.left), eval_(node.right))
    elif isinstance(node, ast.UnaryOp): # <operator> <operand> e.g., -1
        return operators[type(node.op)](eval_(node.operand))
    else:
        raise TypeError(node)

def size_of_type(type):
    if type == "bool": return 32;
    elif type == "unsigned int": return 32
    else: assert false, str(type)

def get_jai_field(field, field_idx, fields):
    place = ''

    bitfield = field.get("bitfield", None)
    if bitfield is not None:
        bitfield = int(bitfield)
        prev_field = fields[field_idx - 1] if field_idx > 0 else None
        # TODO: flesh this out
        if prev_field is not None and bitfield == 1 and prev_field.get("bitfield", None) == "31":
            place = f"#place {prev_field['name']}; "

    template_type = field.get("template_type", None)
    if template_type is not None:
        expect_ptr = False
        if template_type.endswith("*"):
            expect_ptr = True
            template_type = template_type[:-1]

        postfix = "_" + template_type.replace(" ", "_")
        postfix_ptr = "_" + template_type.replace(" ", "_") + "Ptr"

        is_pointer = False
        if expect_ptr and field['type'].endswith(postfix_ptr):
            container_name = field['type'][:-len(postfix_ptr)] 
            is_pointer = True
        elif not expect_ptr and field['type'].endswith(postfix):
            container_name = field['type'][:-len(postfix)]
            is_pointer = False
        else:
            assert False, f"expected field type {field['type']} to end with '{postfix}' (or Ptr)"

        template_type = ("*" if is_pointer else "") + strip_im_prefixes(template_type)
        field['type'] = f"{container_name}({template_type})"

    jai_type = to_jai_type(field['type'])
    size = field.get("size", -1)
    arr_match = arr_part_re.match(field["name"])

    code_size = None
    if arr_match and arr_match.groups()[1] is not None:
        shortened_name, code_size = arr_match.groups()
        if re.match(r"[a-zA-Z_]+", code_size):
            # May be an enum constant like "ImGuiKey_Count". we'll keep the reference to the actual
            # enum value, for better understanding.
            code_size = strip_im_prefixes(code_size)
            code_size = code_size.replace("_", ".", 1)
        else:
            # It's a string expression for a number. we want to just pass the expression
            # through to jai, since it's valuable information to keep the numeric constant
            # factored out (i.e., like keeping 1024*4 instead of 4096)
            assert eval_expr(code_size) == field["size"]

        jai_type = f"[{code_size}]{jai_type}"
    else:
        shortened_name = field["name"]

    if field["name"].endswith("Fn"):
        # Special case for fields with function pointer types.
        #
        # we already handled it above
        pass
    else:
        jai_type = handle_pointers(jai_type)
        if shortened_name == jai_type.replace("*", ""):
            # Uh oh...jai doesn't let us have the name and the type name be the same.
            # so in this case we'll postfix the field name with an underscore.
            shortened_name = f"{shortened_name}_"

    return place, shortened_name, jai_type

def get_jai_func_ptr(jai_type):
    match = re.match(r"([^\(]+)\(([^\)]+)\)\((.*)\)", jai_type)
    # print("--->", match.groups(), "from --- ", jai_type)

    # Plugin_Deinit_Func      :: #type (ctx: *Context, shutting_down: bool) -> *void #c_call;

    if not match:
        assert False, "did not match func ptr regex: " + jai_type

    ret_type, star, args_str = match.groups()
    assert star == "*"

    jai_args_string = ""

    args_str_split = split_args(args_str)
    for i, arg in enumerate(args_str_split):
        jai_arg = is_trivial_type_replacement(arg)
        if jai_arg is not None:
            arg_type = jai_arg
            arg_name = f"unnamed{i}"
            
        else:
            elems = arg.rsplit(" ", 1)
            if len(elems) == 1:
                arg_type = elems[0]
                arg_name = f"unnamed{i}"
            else:
                assert len(elems) == 2
                arg_type, arg_name = elems

        arg_type = to_jai_type(arg_type)

        jai_args_string += f"{arg_name}: {arg_type}"
        if i != len(args_str_split) - 1:
            jai_args_string += ", "


    ret_type = handle_pointers(strip_im_prefixes(replace_types(ret_type)))
    if ret_type == "void":
        ret_type_with_arrow = ""
    else:
        ret_type_with_arrow = f" -> {ret_type}"
    
    return f"({jai_args_string}){ret_type_with_arrow} #c_call"

def handle_pointers(t):
    # turn void** c-style pointer declarations into jai-style **void 

    output_t = ""
    while True:
        t = t.strip()
        if t.endswith("*") or t.endswith("&"):
            output_t += "*"
            t = t[:-1]
        elif t.endswith("[]"):
            output_t += "[]"
            t = t[:-2]
        else:
            output_t += t
            break

    return output_t

def p(*a, **k):
    # a shortcut for printing to an output file
    k["file"] = k.get("file", ctx.get("output_file", None))
    print(*a, **k)

def p_aligned(row_tuples, prefix=''):
    # Prints tabulated data aligned

    if not row_tuples: return

    assert all(len(row) == len(row_tuples[0]) for row in row_tuples)

    max_columns = [0] * len(row_tuples[0])

    for row in row_tuples:
        for column in range(len(row)):
            max_columns[column] = max(len(row[column]), max_columns[column])

    for row in row_tuples:
        for column, elem in enumerate(row):
            justified = elem.ljust(max_columns[column]) if column < len(row)-1 else elem
            p(prefix + justified, end="")
        p("", end="\n") # newline
            
def print_section(name):
    p(f"\n//\n// section: {name}\n//\n")

def get_windows_symbols(dll_filename):
    # use dumpbin to export all the symbols from imgui.dll
    if os.path.isfile(exports_file):
        os.remove(exports_file)
    os.system(f"dumpbin /nologo /exports {dll_filename} > {exports_file}")
    assert os.path.isfile(exports_file)

    started = False
    count = 0
    symbols = []
    for line in open(exports_file, "r"):
        line = line.strip()
        if not line: continue
        if not started and line.startswith("ordinal"):
            # find the first line describing exports
            started = True

        if not started:
            continue

        match = export_line_regex.match(line)
        if match is None: continue

        symbols.append(SymbolEntry(*match.groups()))

    print(f"matched {len(symbols)} total symbols from {dll_filename}.")
    return symbols

SymbolEntry = namedtuple("SymbolEntry", 'ordinal hint rva name1 name2 demangled')

def split_args(args_str):
    # a complicated example from 
        # void __cdecl ImGui::SetAllocatorFunctions(void * (__cdecl*)(unsigned __int64,void *),void (__cdecl*)(void *,void *),void *)
    # the arguments:
        # void * (__cdecl*)(unsigned __int64,void *),void (__cdecl*)(void *,void *),void *

    args_str = args_str.strip()

    level = 0
    start_index = 0
    args = []
    if not args_str:
        return args

    for i, ch in enumerate(args_str):
        if ch == "(": level += 1
        elif ch == ")": level -= 1
        elif ch == "," and level == 0:
            args.append(args_str[start_index:i])
            start_index = i + 1

    # the rest
    args.append(args_str[start_index:])

    return args

assert split_args("int foo,const char* bar") == ["int foo", "const char* bar"]
assert split_args("") == []
assert split_args("void * (__cdecl*)(unsigned __int64,void *),void (__cdecl*)(void *,void *),void *") == [
    "void * (__cdecl*)(unsigned __int64,void *)",
    "void (__cdecl*)(void *,void *)",
    "void *",
]

def group_symbols(symbols):
    missed_count = 0

    symbols_grouped_by_function_name = defaultdict(list)

    for symbol in symbols:
        mangled   = symbol.name1.strip()
        demangled = symbol.demangled.strip()

        if "__cdecl" not in demangled:
            print("skipping because no __cdecl:", demangled)
            continue

        # sanity check: we expect a function like thing now
        is_function = "(" in demangled and ")" in demangled
        assert is_function, demangled

        match = function_pattern.match(demangled)
        if match is None:
            print("no match: " + demangled + "")
            missed_count += 1
            continue

        symbol_info = match.groupdict()
        symbol_info.update(
            mangled = mangled,
            demangled = demangled,
            args = [normalize_types(arg) for arg in split_args(symbol_info["args"])],
            retval = normalize_types(symbol_info["retval"]),
        )

        if symbol_info["args"] == ["void"]:
            symbol_info["args"] = []

        assert(symbol_info["fname"])
        symbols_grouped_by_function_name[symbol_info["fname"]].append(symbol_info)

    print(f"missed {missed_count} out of {len(symbols)}")

    return symbols_grouped_by_function_name

def normalize_types(cpp_type):
    # remove 'struct '
    cpp_type = cpp_type.replace("struct ", "")

    # normalize  'Thing *' into 'Thing*'
    cpp_type = re.sub(r"(\w) \*", r"\1*", cpp_type)

    return cpp_type

def to_jai_func_ptr(desc):
    assert desc.get("func", False)
    args = ", ".join(
            f"{a['name']}: {to_jai_type(a['type'])}"
            for a in desc["args"])

    ret_with_arrow = ""
    retval = desc.get("retval", "void")
    if retval != "void":
        ret_with_arrow = f" -> {to_jai_type(retval)}"

    return f"({args}){ret_with_arrow} #c_call"

def to_jai_type(cpp_type_string, info=None):
    if info is None:
        info = {}

    if cpp_type_string == "char*":
        return "*u8"

    if cpp_type_string == "...":
        return "..Any"

    if isinstance(cpp_type_string, dict):
        assert cpp_type_string.get("func")
        return to_jai_func_ptr(cpp_type_string)

    assert isinstance(cpp_type_string, str), "expected a string, got: " + str(cpp_type_string)
    cpp_type_string = cpp_type_string.replace("__cdecl", "") # TODO: probably shouldn't just erase this fact...

    if fn_ptr_matcher.search(cpp_type_string):
        return get_jai_func_ptr(cpp_type_string)

    cpp_type_string = cpp_type_string\
        .replace("char const*", "u8*")\
        .replace("const char*", "u8*")\
        .replace("const char *", "u8*")\
        .replace("char *", "*u8")\
        .replace("const ", "")\
        .replace(" const", "")

    cpp_type_string = handle_pointers(strip_im_prefixes(replace_types(cpp_type_string)))

    # in jai we put the array part first

    # TODO: the cpp_type_string coming into this function may have the array already flipped.
    # that seems wrong.
    match = re.match(r"^(?P<identifier>.*)\[(?P<array_size>\d+)\]$", cpp_type_string)
    if not match:
        match = re.match(r"^\[(?P<array_size>\d+)\](?P<identifier>.*)$", cpp_type_string)
    if match:
        identifier, array_size = match.group("identifier"), match.group("array_size")
        info['array_size'] = array_size
        cpp_type_string = f"[{array_size}]{identifier}"
    elif '[' in cpp_type_string and 'float' in cpp_type_string:
        assert False, cpp_type_string

    assert isinstance(cpp_type_string, str)
    return cpp_type_string

def all_jai_types_equivalent(enums, zipped_types):
    idx = 0
    for a, b in zipped_types:
        equiv, reason = jai_types_equivalent(enums, a, b)
        if not equiv:
            assert reason
            return False, reason, idx
        idx += 1
    
    return True, None, -1

def strip_pointer_or_array(s):
    # TODO: what if there are pointers to pointers here????
    if s.startswith("*"): return s[1:]

    bracket_idx = s.index("]")
    assert bracket_idx != -1
    return s[bracket_idx + 1:]


def jai_types_equivalent(enums, a, b):
    a = a.strip()
    b = b.strip()

    if a > b:
        a, b = b, a

    for typedef_name, jai_type in jai_typedefs.items():
        if a == typedef_name and b == jai_type:
            return True, None
        if b == typedef_name and a == jai_type:
            return True, None

    if a == "ID" and b == "u32":
        return True, None

    # TODO: use a similar thing with jai_typedefs but for function pointers
    if a == "InputTextCallback" and b == "s32 (__cdecl*)(ImGuiInputTextCallbackData*)":
        return True, None

    def starts_with_pointer_or_array(s):
        if s.startswith("*"): return True
        if re.match("^\[(?:\d+)?\]", s): return True
        return False


    while starts_with_pointer_or_array(a) and starts_with_pointer_or_array(b):
        a, b = strip_pointer_or_array(a), strip_pointer_or_array(b)

    arg_name_re = r"(\w+: )"

    # remove the argument names for our comparison if they are function pointers
    # TODO: this is silly. we already know if they are function pointers somewhere
    # above this code, because we did the conversion.
    did_find_func_ptr_a = "->" in a or "#c_call" in a
    did_find_func_ptr_b = "->" in b or "#c_call" in b
    if did_find_func_ptr_a and not did_find_func_ptr_b: b = jai_typedefs.get(b, b)
    if did_find_func_ptr_b and not did_find_func_ptr_a: a = jai_typedefs.get(a, a)

    a = re.sub(arg_name_re, "", a).lstrip("#type ")
    b = re.sub(arg_name_re, "", b).lstrip("#type ")

    if a == b:
        return True, None

    if did_find_func_ptr_a and did_find_func_ptr_b:
        print("~~~~mismatched fn ptrs:\n", a, "\n", b)

    def is_enum(a):
        if enums is None: return False

        # TODO: this is hacky and bad. we need to store the original c name
        return a in enums or (a + "_") in enums or ("ImGui" + a + "_") in enums

    # TODO: most of this mess can be cleaned up by using the 'typedefs' json
    # that is also emitted by cimgui.

    if (is_enum(a) and b == "s32") or (a == "s32" and is_enum(b)):
        return True, None

    jai_wchar_type = "u32" if IMGUI_USE_WCHAR32 else "u16"

    if a == "ImWchar" and b == jai_wchar_type:
        return True, None
    elif a == "ImWchar16" and b == "u16":
        return True, None
    elif a == "ImWchar32" and b == "u32":
        return True, None

    return False, f"a: {a}, b: {b}"
    

def strip_im_prefixes(name):
    if STRIP_IMGUI_PREFIX and name.startswith("ImGui"): name = name[5:]
    #if name.startswith("Im"): name = name[2:]
    return name


def convert_enum_default(enums, val):
    # ImDrawCornerFlags_All -> .All
    #
    # but only if it's a valid enum

    if "_" in val:
        i = val.index("_")
        enum_part = val[:i+1]
        if enum_part in enums:
            return "." + val[i+1:]

    return val

def get_enum_name(enums, jai_enum_name, value):
    jai_enum_name = jai_enum_name + "_"
    enum_entry = enums.get(jai_enum_name, None)
    if enum_entry is None:
        return None

    for val_entry in enum_entry:
        if val_entry["value"] == value:
            name = val_entry["name"]
            assert name.startswith(jai_enum_name), name
            name = name[len(jai_enum_name):]
            return name
    
    return None

def make_jai_default_arg(structs_and_enums, optional_default, arg_type):
    info = {}

    if not optional_default:
        return None, info

    if optional_default == "((void*)0)":
        return "null", info

    # TODO: check argtype and probably don't use a regex here.
    # do try: float() except ValueError: instead.
    float_match = re.match(r"[+-]?(\d+\.\d+)f", optional_default)
    if float_match is not None:
        # In jai, floating point values do not end with f -- the compiler
        # figures out which type the constant should be for us.
        return float_match.group(1), info

    # hack: also strip f for scientific notation. this should be merged
    # with the code above.
    if re.match(r".*e[+-]\d+[Ff]$", optional_default):
        return optional_default[:-1], info

    if optional_default == "0.0":
        return "0", info

    # TODO: make this kind of cast more general
    optional_default = optional_default.replace("(ImU32)", "cast(u32)")

    constructor_match = re.match(r"^(\w+)\((.*)\)$", optional_default)
    if constructor_match is not None:
        constructor_name, args = constructor_match.groups()
        if constructor_name == "sizeof":
            optional_default = "size_of(" + args + ")"
        else:
            optional_default = constructor_name + ".{" + args + "}"
            info['was_constructor'] = True

    enum_name = get_enum_name(structs_and_enums["enums"], arg_type, optional_default)
    if enum_name is not None:
        optional_default = f".{enum_name}"

    optional_default = convert_enum_default(structs_and_enums["enums"], optional_default)

    return optional_default, info

def parse_arg(c_arg_decl, arg_index):
    assert isinstance(c_arg_decl, str), "expected a string, got: " + str(c_arg_decl)
    assert not c_arg_decl.startswith("("), "didn't expect to start with a paren: " + c_arg_decl

    if c_arg_decl == "...":
        return dict(name="args", type="..Any", jai_type="..Any", default=None)

    assert c_arg_decl.count("=") <= 1
    elems = c_arg_decl.split("=")
    if len(elems) == 1:
        # no default argument
        arg_decl, default_arg = elems[0], None
    elif len(elems) == 2:
        arg_decl, default_arg = elems
        # a default argument

    fn_match = fn_ptr_matcher.match(arg_decl)
    if fn_match:
        ret_val, fn_name, fn_args = fn_match.groups()
        return dict(
            name=fn_name,
            type=dict(
                func=True,
                retval=ret_val,
                args=[parse_arg(a, idx) for idx, a in enumerate(split_args(fn_args))],
                default=default_arg)
        )

    else:
        space_elems = arg_decl.rsplit(' ', 1)
        if len(space_elems) == 1:
            arg_type, arg_name = space_elems[0], f"unnamed{arg_index}"
        else:
            arg_type, arg_name = space_elems

        match = re.match(r"(.*)(\[(?:\d+)?\])", arg_name)
        if match:
            arg_name, arr_part = match.groups()
            arg_type = f"{arr_part}{arg_type}"
        return dict(
            name=arg_name,
            type=arg_type,
            jai_type=to_jai_type(arg_type),
            default=default_arg,
            is_constref = bool(re.match(r"const \w+&", arg_type)))

def get_jai_args(structs_and_enums, func_entry, target=False):
    parsed_arg_infos = []

    for i, orig_arg in enumerate(split_args(func_entry["argsoriginal"][1:-1])):
        parsed_arg_infos.append(parse_arg(orig_arg, i))
        if func_entry['funcname'] in diagnose_funcnames:
            print("arg", i, orig_arg, parsed_arg_infos[-1])

    argsT = func_entry["argsT"]

    if target:
        print(f"{argsT}")

    if len(argsT) >= 1 and argsT[0]["name"] == "pOut":
        argsT.pop(0) # remove pOut arg--its only used by generated cimgui

    # insert another argument at the beginning if we have a self
    if len(argsT) >= 1 and argsT[0]["name"] == "self":
        assert len(argsT) == len(parsed_arg_infos) + 1
        parsed_arg_infos.insert(0, dict(name="self", type=argsT[0]['type'], jai_type=to_jai_type(argsT[0]['type'])))

    assert len(argsT) == len(parsed_arg_infos), pformat([
            ("comparison", (argsT, parsed_arg_infos)),
            ("func_entry", func_entry)])

    needs_defaults_wrapper = False
    arg_infos = []
    return_arg_info = None
    for i, arg in enumerate(argsT):
        parsed_arg = parsed_arg_infos[i]
        name, arg_type = arg["name"], arg["type"]

        # "argsoriginal": "(ImGuiID id,const ImVec2& size=ImVec2(0,0),ImGuiDockNodeFlags flags=0,const ImGuiWindowClass* window_class=((void*)0))",
        # "argsoriginal": "(const char* label,int* current_item,bool(*items_getter)(void* data,int idx,const char** out_text),void* data,int items_count,int height_in_items=-1)",
        # can check "signature" in argsT entry

        arg_type_info = {}
        jai_arg_type = to_jai_type(parsed_arg_infos[i]["type"], arg_type_info)
        if func_entry['funcname'] in diagnose_funcnames:
            print("jai_arg_type", i,parsed_arg_infos[i]["type"], "->", jai_arg_type)

        if name == "...":
            name = "args"

        wrapper_arg_type = jai_arg_type
        call_arg_value = name
        default_str = ""

        optional_default, default_info = make_jai_default_arg(structs_and_enums, (func_entry['defaults'] or {}).get(name, None), arg_type)

        if optional_default is not None and jai_arg_type == "*u8":
            # jai as of beta 0.0.024 has a bug where string
            # default arguments to #foreign procs don't work,
            # so we'll wrap those functions.
            needs_defaults_wrapper = True
            wrapper_arg_type = "string";
            call_arg_value = name + ".data"
            if optional_default == "null":
                optional_default = '""'
        elif optional_default is not None and not parsed_arg.get('func') and count_pointers(parsed_arg['jai_type']) == 1 and default_info.get("was_constructor"):
            needs_defaults_wrapper = True
            wrapper_arg_type = strip_pointer_or_array(parsed_arg['jai_type'])
            call_arg_value = "*" + name
        elif parsed_arg.get('is_constref'):
            needs_defaults_wrapper = True
            wrapper_arg_type = strip_pointer_or_array(parsed_arg['jai_type'])
            call_arg_value = "*" + name
        elif arg_type_info.get('array_size', 0):
            needs_default_wrapper = True
            call_arg_value = name + ".data"
        else:
            assert parsed_arg['name'] == name, parsed_arg["name"] + " vs " + name
            if isinstance(parsed_arg["type"], str):
                assert "jai_type" in parsed_arg, parsed_arg
                if count_pointers(parsed_arg["jai_type"]) == 1 + count_pointers(jai_arg_type):
                    call_arg_value = "*" + call_arg_value # take the address of the incoming value

        if optional_default is not None:
            default_str = f" = {optional_default}"

        arg_info = ArgInfo(name, jai_arg_type, default_str, wrapper_arg_type, call_arg_value, parsed_arg_infos[i])
        if name == "pOut":
            return_arg_info = arg_info
        else:
            arg_infos.append(arg_info)

    return arg_infos, needs_defaults_wrapper, return_arg_info

def count_pointers(jai_type):
    return jai_type.count("*") + len(re.findall(r"\[(?:\d+)?\]", jai_type))

def main():
    # get symbols from windows dll
    if not os.path.isfile(PATH_TO_IMGUI_DLL):
        raise Exception("error - expected imgui dll to exist here: " + PATH_TO_IMGUI_DLL)

    symbols = get_windows_symbols(PATH_TO_IMGUI_DLL)
    if len(symbols) == 0:
        raise Exception("Couldn't read DLL symbols. Are you in a Visual Studio command prompt? The PATH must contain dumpbin.exe.")

    # parse out their demangled descriptions and group them by function name
    symbols_grouped = group_symbols(symbols)

    # parse the structs/enums JSON
    structs_and_enums = load_structs_and_enums()

    ctx["output_file"] = open(OUTPUT_BINDINGS_JAI_FILE, "w")
    size_tester_file = open("imgui_sizes.cpp", "w")

    def p_sizer(*a, **k):
        k['file'] = size_tester_file
        return p(*a, **k)

    p_sizer("""\
#include <stdio.h>
#define IMGUI_API __declspec(dllimport)
#include "imgui.h"
#include "imgui_internal.h"

int main(int argc, char** argv) {
    printf("[1]\\n\\n");
""")

    def p_sizer_for_name(name, jai_name):
        p_sizer(f"""    printf("{cimgui_name} {jai_name} %lld\\n", sizeof({cimgui_name}));""")

    #
    # enums
    #
    print_section("ENUMS")
    for cimgui_name, enum_values in structs_and_enums["enums"].items():
        if SKIP_PRIVATE_ENUMS and "Private_" in cimgui_name: continue
        if cimgui_name.endswith("_"):
            cimgui_name = cimgui_name[:-1]

        jai_enum_name = strip_im_prefixes(cimgui_name)
        enum_or_enum_flags = "enum_flags" if "Flags" in jai_enum_name else "enum"

        p(f"{jai_enum_name} :: {enum_or_enum_flags} {ENUM_TYPE} {{")

        output_entries = []
        for entry_idx, entry in enumerate(enum_values):
            name = entry['name']
            assert name.startswith(cimgui_name), f"{name} does not start with '{cimgui_name}'"
            name = name[len(cimgui_name):]
            if name.startswith("_"):
                name = name[1:]

            value = entry['value']
            if isinstance(value, str):
                # omit the type name
                if cimgui_name + "_" in value:
                    value = value.replace(cimgui_name + "_", f"{jai_enum_name}.")
                else:
                    value = value.replace(cimgui_name,       f"{jai_enum_name}.")

            output_entries.append((name, f":: {value};"))
        
        p_aligned(output_entries, prefix=4 * " ")
        p(f"}}\n")

    #
    # functions
    #

    # parse the definitions JSON
    print_section("FUNCTIONS")
    definitions = load_definitions()

    struct_functions = defaultdict(list)
    global_functions = list()

    already_seen_dll_symbols = dict()

    for ig_name, overloads in definitions.items():
        if SKIP_INTERNAL and all(e.get('location', None) == "internal" for e in overloads):
            stats["skipped_internal_functions"] += 1
            continue

        for entry in overloads:
            if entry.get("destructor", False):
                # print(f"TODO: destructor {entry['cimguiname']}")
                continue
            if entry.get("constructor", False):
                # print(f"TODO: constructor {entry['cimguiname']}")
                continue
            if entry.get("location", None) == "internal":
                continue

            target = entry['cimguiname'] == "igGetWindowSize"
            if target:
                print(f"my little: {entry['cimguiname']}")

            args_info, needs_defaults_wrapper, return_arg_info = get_jai_args(structs_and_enums, entry, target)

            if return_arg_info is not None and target:
                print(f"return arg: {return_arg_info}")

            diagnose = entry['funcname'] in diagnose_funcnames

            if diagnose:
                print("=== needs defaults wrapper: ", needs_defaults_wrapper)

            ret_type = entry.get("ret", None)
            if ret_type == "void": ret_type = None
            ret_val_with_arrow = f" -> {to_jai_type(ret_type)}" if ret_type is not None else ""

            dll_symbol = get_function_symbol(symbols_grouped, structs_and_enums, entry, args_info, target)
            if dll_symbol is None:
                continue

            seen = already_seen_dll_symbols.get(dll_symbol, None)
            if seen is not None:
                raise Exception(f"already saw symbol {dll_symbol}:\nseen before: {pformat(seen)}\nnew: {pformat(entry)}")
            already_seen_dll_symbols[dll_symbol] = entry

            foreign_decl = "#foreign imgui_lib \"" + dll_symbol + "\""

            stats['actual_function_matches'] += 1

            def get_dict(k):
                dct = k._asdict()
                dct.update(meta_jai_type=to_jai_type(k.meta["type"]))

                dct['internal_jai_type'] = dct['meta_jai_type']

                info = {}
                to_jai_type(k.meta['type'], info)
                if info.get('array_size', 0):
                    dct['internal_jai_type'] = '*' + strip_pointer_or_array(dct['meta_jai_type'])

                return dct

            if needs_defaults_wrapper:

                args_string = ", ".join("{name}: {meta_jai_type}{default_str}".format(**get_dict(k)) for k in args_info)
                args_string_internal = ", ".join("{name}: {internal_jai_type}".format(**get_dict(k)) for k in args_info)
                wrapper_args_string = ", ".join("{name}: {wrapper_arg_type}{default_str}".format(**get_dict(k)) for k in args_info)

                jai_func_name_internal = "_internal_" + entry['funcname']
                call_args = ", ".join("{call_arg_value}".format(**k._asdict()) for k in args_info)
                function_definition = f""" :: ({wrapper_args_string}){ret_val_with_arrow} {{
    {jai_func_name_internal} :: ({args_string_internal}){ret_val_with_arrow} {foreign_decl};
    {"return " if ret_val_with_arrow else ""}{jai_func_name_internal}({call_args});
            }}"""
            else:

                args_string = ", ".join(
                    "{name}: {meta_jai_type}{default_str}".format(**get_dict(k))
                    for k in args_info)
                function_definition = f" :: ({args_string}){ret_val_with_arrow} {foreign_decl};"


            jai_function_line = (entry['funcname'], function_definition)
            stname = entry.get("stname", None) or None
            if stname is not None:
                struct_functions[strip_im_prefixes(stname)].append(jai_function_line);
            else:
                global_functions.append(jai_function_line)
                stats["printed_functions"] += 1

    p_aligned(global_functions)


    # 
    # structs
    #
    print_section("STRUCTS")

    def include_struct(item):
        if SKIP_INTERNAL:
            cimgui_name, fields = item
            if (structs_and_enums["locations"][cimgui_name] == "internal") and cimgui_name not in allow_internal:
                stats["skipped_internal_structs"] += 1

                if cimgui_name in diagnose_funcnames:
                    raise Exception(f"diagnosing {cimgui_name} but about to skip it!")

                return False
        
        return True

    all_structs = structs_and_enums["structs"].items()
    struct_items = [item for item in all_structs if include_struct(item)]
    print(f"including {len(struct_items)} structs out of {len(all_structs)}.")

    for struct_idx, (cimgui_name, fields) in enumerate(struct_items):
        jai_struct_name = strip_im_prefixes(cimgui_name)
        if cimgui_name not in skip_structs_for_size:
            p_sizer_for_name(cimgui_name, jai_struct_name)
        p(f"{jai_struct_name} :: struct {{")
        bitfield_state = []
        for field_idx, field in enumerate(fields):
            # TODO: things like ImGuiStoragePair have a field named "" for its union
            if field['name'] == "":
                continue 

            place, jai_name, jai_type = get_jai_field(field, field_idx, fields)
            p(f"    {place}{jai_name}: {jai_type};")
        struct_funcs = struct_functions.get(jai_struct_name, None)
        if struct_funcs is not None:
            p("")
            p_aligned(struct_funcs, prefix=4 * " ")
            stats['printed_struct_functions'] += len(struct_funcs)

        p_aligned(inline_functions.get(jai_struct_name, []), prefix=4*' ')

        p(f"}}\n")

    p_sizer("}")

    p(extra_code)

    # TODO: take type definitions in extra_code out into a table and re-use
    # them in jai_types_equivalent

    # show stats
    print(f"skipped {len(inline_functions_skipped)} inline functions:", ', '.join(inline_functions_skipped))
    for f in inline_functions_skipped:
        if f in diagnose_funcnames:
            print("ERROR!!! is inline: ", f) # TODO: don't show this message if we have a manual inline function from inline_functions
    print(f"\nMISSED {len(functions_skipped)} functions:", ', '.join(functions_skipped))
    for f in functions_skipped:
        if f.split(":")[-1] in diagnose_funcnames:
            print("ERROR!!! missed: ", f)
    pprint(dict(stats))

    stats_file = "stats.txt"
    if os.path.isfile(stats_file):
        old_stats = json.load(open(stats_file, "r"))
        print("DELTA:")
        for k, v in stats.items():
            print(f"    {v - old_stats[k]} {k}")

    open(stats_file, "w").write(json.dumps(stats))

_state = dict(nomatch_verbose = False)

def get_function_symbol(symbols_grouped, structs_and_enums, function_entry, args_info, target=False):
    # Given a list of function symbols from the DLL, attempt to match by
    # function name, argument and return types, and namespace. Returns
    # the mangled symbol name.

    args_info = args_info[:]
    enums = structs_and_enums["enums"]
    funcname = function_entry["funcname"]
    funcs = symbols_grouped[funcname]
    skip_reasons = []

    def nomatch(target=False):
        if len(funcs) == 0:
            # an inline function has no actual DLL code. we'll have to figure out how to either make them manually...or...
            inline_functions_skipped.append(funcname)
            return

        stats['total_no_matches'] += 1

        stname = function_entry.get("stname", None)
        functions_skipped.append((f"{stname}::" if stname else "") + funcname)

        if target or _state['nomatch_verbose'] or funcname in diagnose_funcnames:
            print(f"===============\nno match for function: " + funcname)
            print("functions in dll: " + pformat(funcs))
            print("function in json: " + pformat(function_entry))
            print("skip reasons:\n" + pformat(skip_reasons))
            if stats['total_no_matches'] > 5:
                print("...stopping showing no matches")
                _state['nomatch_verbose'] = False

    for dll_func in funcs:
        if dll_func['nspace_or_stname'] != function_entry.get("stname", None) and \
            dll_func['nspace_or_stname'] != function_entry.get("namespace", None):
            skip_reasons.append(
                ("nspace/stname", (dll_func['nspace_or_stname'], function_entry.get('stname'), function_entry.get('namespace'))))
            continue

        if len(args_info) > 0 and args_info[0].name == "self":
            args_info.pop(0)

        jai_dll_ret = to_jai_type(dll_func['retval'])
        jai_entry_ret = to_jai_type(function_entry["ret"])
        equiv, reason = jai_types_equivalent(enums, jai_dll_ret, jai_entry_ret)
        if not equiv:
            if target:
                print(f"args_info = {args_info}")
                # print(f"first arg = {args_info[0]}")
                print("RETURN NOT MATCHED")
            skip_reasons.append(("return value (json, dll)", (jai_dll_ret, jai_entry_ret)))
            continue

        arg_types = [to_jai_type(a.meta["type"]) for a in args_info]
        dll_types = [to_jai_type(a) for a in dll_func['args']]
        if funcname in diagnose_funcnames:
            print("dll_types", dll_types)
            print("orig     ", dll_func['args'])
        zipped_types = list(itertools.zip_longest(arg_types, dll_types, fillvalue=''))
        all_equiv, reason, idx = all_jai_types_equivalent(enums, zipped_types)
        if not all_equiv:
            skip_reasons.append(("argument types (json, dll)", (reason, dict(index=idx), zipped_types)))
            continue

        if funcname in diagnose_funcnames:
            print("----")
            print(f"success for '{funcname}': {dll_func['mangled']}")
            print("----")

        return dll_func['mangled']

    nomatch(target)
    return None

assert to_jai_type("const char*") == "*u8", "uhoh: " + to_jai_type("const_char*")
assert to_jai_type("char *") == "*u8",      "expected 'char *' to become '*u8', but: " + to_jai_type("char *")

def test_get_jai_func_ptr():
    cpp_func = "bool (*)(void*,int,char const* *)"
    expected_jai_func = "(unnamed0: *void, unnamed1: s32, unnamed2: **u8) -> bool #c_call"
    res = get_jai_func_ptr(cpp_func)
    assert res == expected_jai_func,\
        "for: {}\nexpected: {}\nbut got:  {}".format(cpp_func, expected_jai_func, res)

test_get_jai_func_ptr()

if __name__ == "__main__":
    main()


