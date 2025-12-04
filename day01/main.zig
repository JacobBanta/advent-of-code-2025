const std = @import("std");
pub fn main() !void {
    var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
    var pos: isize = 50;
    var count: usize = 0;
    var count2: usize = 0;
    while (it.next()) |line| {
        if (line.len == 0) continue;
        if (line[0] == 'R') {
            // The general idea here is to calculate how
            // many turns it will take to get to the next 0.
            // This is not optimal, but it is fast enough.
            var i = try std.fmt.parseInt(isize, line[1..], 10);
            while (i > 0) {
                var change = @min(i, 100 - pos);
                if (change == 0) change = 100;
                pos += change;
                pos = @mod(pos, 100);
                i -= @intCast(change);
                if (i == 0) {
                    if (@mod(pos, 100) == 0) count2 += 1;
                    break;
                }
                count2 += 1;
            }
        }
        if (line[0] == 'L') {
            var i = try std.fmt.parseInt(isize, line[1..], 10);
            while (i > 0) {
                var change = @min(i, pos);
                if (change == 0) change = @min(100, i);
                pos -= change;
                pos = @mod(pos, 100);
                i -= @intCast(change);
                if (i == 0) {
                    if (@mod(pos, 100) == 0) count2 += 1;
                    break;
                }
                count2 += 1;
            }
        }
        if (@mod(pos, 100) == 0) count += 1;
        pos = @mod(pos, 100);
    }
    std.debug.print("part 1: {d}\n", .{count});
    std.debug.print("part 2: {d}\n", .{count2});
}
