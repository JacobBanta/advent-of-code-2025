const std = @import("std");
pub fn main() !void {
    var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
    var pos: isize = 50;
    var count: usize = 0;
    var count2: usize = 0;
    while (it.next()) |line| {
        if (line.len == 0) continue;
        if (line[0] == 'R') {
            for (0..try std.fmt.parseInt(usize, line[1..], 10)) |_| {
                pos += 1;
                if (@mod(pos, 100) == 0) count2 += 1;
            }
        }
        if (line[0] == 'L') {
            for (0..try std.fmt.parseInt(usize, line[1..], 10)) |_| {
                pos -= 1;
                if (@mod(pos, 100) == 0) count2 += 1;
            }
        }
        if (@mod(pos, 100) == 0) count += 1;
    }
    std.debug.print("part 1: {d}\n", .{count});
    std.debug.print("part 2: {d}\n", .{count2});
}
