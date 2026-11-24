const std = @import("std");

pub fn getModule(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.Optimize) *std.Build.Module {
    if (b.modules.contains("box3d")) {
        return b.modules.get("box3d").?;
    }

    const box3d_dependency = b.dependency("box3d", .{});
    const box3d_c = b.addTranslateC(.{
        .root_source_file = box3d_dependency.path("include/box3d/box3d.h"),
        .link_libc = true,
        .optimize = optimize,
        .target = target,
    });
    const box3d_module = box3d_c.addModule("box3d");
    box3d_module.addIncludePath(box3d_dependency.path("include"));
    box3d_module.addIncludePath(box3d_dependency.path("src"));
    box3d_module.addCSourceFiles(.{
        .root = box3d_dependency.path("src"),
        .language = .c,
        .flags = &.{
            "-std=gnu17",
        },
        .files = &.{
            "aabb.c",
            "arena_allocator.c",
            "bitset.c",
            "block_allocator.c",
            "body.c",
            "broad_phase.c",
            "capsule.c",
            "compound.c",
            "constraint_graph.c",
            "contact.c",
            "contact_solver.c",
            "convex_manifold.c",
            "core.c",
            "distance.c",
            "distance_joint.c",
            "dynamic_tree.c",
            "height_field.c",
            "hull.c",
            "id_pool.c",
            "island.c",
            "joint.c",
            "manifold.c",
            "math_functions.c",
            "mesh.c",
            "mesh_contact.c",
            "motion_lock_joint.c",
            "motor_joint.c",
            "mover.c",
            "mover_joint.c",
            "name_cache.c",
            "parallel_for.c",
            "parallel_joint.c",
            "physics_world.c",
            "pogo_joint.c",
            "prismatic_joint.c",
            "recording.c",
            "replay.c",
            "revolute_joint.c",
            "scheduler.c",
            "sensor.c",
            "shape.c",
            "simd.c",
            "solver.c",
            "solver_set.c",
            "sphere.c",
            "spherical_joint.c",
            "table.c",
            "timer.c",
            "triangle_manifold.c",
            "types.c",
            "weld_joint.c",
            "wheel_joint.c",
            "wide4.c",
            "wide8.c",
            "world_snapshot.c",
        },
    });

    return box3d_module;
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const box3d_module = getModule(b, target, optimize);

    const test_module = b.createModule(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
    });

    test_module.addImport("box3d", box3d_module);

    const exe_tests = b.addTest(.{
        .root_module = test_module,
    });

    const run_tests = b.addRunArtifact(exe_tests);
    const step_tests = b.step("test", "Run tests");
    step_tests.dependOn(&run_tests.step);
}
