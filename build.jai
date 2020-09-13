#import "Basic";
#import "Compiler";

module_search_paths := string.[
    ".",
];

#run build();

build_file :: (filename: string, output_executable_name: string) {
    w := compiler_create_workspace("build");
    defer compiler_destroy_workspace(w);

    compiler_begin_intercept(w);
    defer compiler_end_intercept(w);

    opts := get_build_options();
    array_add(*opts.modules_search_path_array, ..module_search_paths);
    opts.output_type = .EXECUTABLE;
    opts.output_executable_name = output_executable_name;
    set_build_options(opts, w);

    add_build_file(filename, w);
    while true {
        message := compiler_wait_for_message();
        if !message || message.workspace != w continue;
        if message.kind == .COMPLETE break;
    }
}

build :: () {
    set_working_directory(#filepath);

    opts := get_build_options();
    opts.output_type = .NO_OUTPUT;
    set_build_options(opts);

    build_only_opengl := false;
    for compiler_get_command_line_arguments() 
        if it == "opengl"
            build_only_opengl = true;

    build_file("imgui_opengl_test.jai", output_executable_name="imgui_opengl_test");

    if !build_only_opengl  {
        build_file("example_null.jai", output_executable_name="example_null");
        build_file("test_sizes.jai", output_executable_name="test_sizes");
    }

    print("built.\n");
}

