#import "Basic";
#import "Compiler";

#run build();

build_file :: (filename: string, output_executable_name: string) {
    w := compiler_create_workspace("build");
    defer compiler_destroy_workspace(w);

    compiler_begin_intercept(w);
    defer compiler_end_intercept(w);

    // import_path
    opts := get_build_options();
    new_import_paths: [..]string;
    array_add(*new_import_paths, ".");
    array_add(*new_import_paths, "examples");
    array_add(*new_import_paths, ..opts.import_path);
    opts.import_path = new_import_paths;

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

    examples: [..]string;
    array_add(*examples, "example_no_graphics");
    array_add(*examples, "example_opengl");
    if OS == .WINDOWS { array_add(*examples, "example_d3d11"); }

    for examples
        build_file(tprint("examples/%.jai", it), output_executable_name=it);
    sleep_milliseconds(50); // so we don't interleave with jai complier's output...

    print("\nSUCCESS! built:\n");
    for examples
        print("  %.exe\n", it);

}

