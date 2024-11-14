const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard target options
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .bpfel,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    // Create the library
    const lib = b.addObject(.{
        .name = "program",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Set linker script and flags
    const linker_script = b.path("bpf.ld");
    lib.setLinkerScript(linker_script);

    // Important flags for BPF
    lib.link_function_sections = true;
    lib.link_eh_frame_hdr = true;
    lib.bundle_compiler_rt = false;
    lib.want_lto = true;
    lib.link_z_notext = true;
    lib.rdynamic = false;
    lib.linker_allow_shlib_undefined = true;
    lib.entry = .{ .symbol_name = "entrypoint" };

    // Disable panic handlers and unwinding
    lib.root_module.strip = true;
    lib.root_module.unwind_tables = false;
    lib.root_module.strip = true;
    lib.root_module.single_threaded = true;
    // lib.root_module.sanitize_c = false;
    lib.root_module.red_zone = false;
    lib.root_module.omit_frame_pointer = true;
    lib.root_module.pic = true;

    const bpf_output_path = "target/program.so";
    const install_program = b.addInstallBinFile(lib.getEmittedBin(), bpf_output_path);
    // const install_program = b.addInstallArtifact(lib, .{ .dest_dir = .{ .override = .{ .custom = "target" } } });

    const build_step = b.step("bpf", "Build the BPF program");
    build_step.dependOn(&install_program.step);

    // Create test step
    const main_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .optimize = optimize,
    });

    const run_main_tests = b.addRunArtifact(main_tests);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}
