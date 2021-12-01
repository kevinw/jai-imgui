#import "Basic";
#import "Compiler";
Check :: #import "Check";

#run build();

// Builds an executable from an example .jai file
build_file :: (filename: string, output_executable_name: string) -> (success: bool) {
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
        Check.do_error_checking(message, check_bindings=true);
        if message.kind == .COMPLETE {
            // Check for Message_Complete.error_code == .NONE to see if we succeeded.
            message_complete := cast(*Message_Complete)message;
            return message_complete.error_code == .NONE;
        }
    }
}

// The main metaprogram for building jai-imgui examples.
build :: () {
    set_working_directory(#filepath);

    opts := get_build_options();
    opts.output_type = .NO_OUTPUT;
    set_build_options(opts);

    examples: [..]string;
    array_add(*examples, "example_no_graphics");
    array_add(*examples, "example_opengl");
    if OS == .WINDOWS { array_add(*examples, "example_d3d11"); }

    all_succeeded := true;
    for examples {
        success := build_file(tprint("examples/%.jai", it), output_executable_name=it);
        all_succeeded &= success;
    }

    sleep_milliseconds(50); // so we don't interleave with jai complier's output...

    if all_succeeded {
        print("\nSUCCESS! built:\n");
        for examples
            print("  %.exe\n", it);
    }

}

