const std = @import("std");
const B = std.Build;

pub fn build(b: *B) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    {
        const module = b.addModule("zig-package-template", .{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        });
        addDependencies(module, b, target, optimize);
    }

    {
        const tests = b.addTest(.{
            .name = "test",
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        });
        addDependencies(tests, b, target, optimize);

        const run_tests = b.addRunArtifact(tests);
        const test_step = b.step("test", "Run unit tests");
        test_step.dependOn(&run_tests.step);

        const debug_tests_artifact = b.addInstallArtifact(tests, .{});
        const debug_tests_step = b.step("build-test", "Create a test artifact that runs the tests");
        debug_tests_step.dependOn(&debug_tests_artifact.step);
    }

    {
        const tests_check = b.addTest(.{
            .name = "check",
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        });
        addDependencies(tests_check, b, target, optimize);

        const check = b.step("check", "Check if tests compile");
        check.dependOn(&tests_check.step);
    }
}

fn addDependencies(
    step: anytype,
    b: *B,
    target: B.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    _ = step;
    _ = b;
    _ = target;
    _ = optimize;
}
