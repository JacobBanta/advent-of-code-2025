const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    const days = .{
        "01",
        "02",
        "03",
        "04",
        "05",
        "06",
    };
    const cmd = b.addSystemCommand(&.{ "hyperfine", "-N" });
    if (optimize != .Debug) {
        cmd.addArgs(&.{ "--warmup", "5000" });
    }
    inline for (days) |day| {
        const mod = b.createModule(.{
            .root_source_file = b.path("day" ++ day ++ "/main.zig"),
            .target = target,
            .optimize = optimize,
        });
        const exe = b.addExecutable(.{ .root_module = mod, .name = "day" ++ day });
        b.installArtifact(exe);
        cmd.addArgs(&.{ "-n", "day" ++ day });
        cmd.addArtifactArg(exe);
    }
    const time = b.step("time", "times");
    time.dependOn(&cmd.step);
}
