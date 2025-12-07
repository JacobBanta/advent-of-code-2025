const std = @import("std");
pub fn main() !void {
    const input = @embedFile("input.txt");
    const linelen = std.mem.indexOfScalar(u8, input, '\n').?;
    const tachyons = try std.heap.page_allocator.alloc(usize, linelen);
    @memset(tachyons, 0);
    tachyons[std.mem.indexOfScalar(u8, input, 'S').?] = 1;
    var it = std.mem.splitScalar(u8, input, '\n');
    var count: usize = 0;
    while (it.next()) |line| {
        if (line.len == 0) continue;
        var i: usize = 0;
        while (true) {
            i = std.mem.indexOfScalarPos(u8, line, i + 1, '^') orelse break;
            //std.debug.print("{s} - {d}\n", .{ line, i });
            //var count: usize = 0;
            //for (tachyons) |t| {
            //count += t;
            //}
            //std.debug.print("{d}\n", .{count});
            if (tachyons[i] > 0) {
                count += 1;
                tachyons[i - 1] += tachyons[i];
                tachyons[i + 1] += tachyons[i];
                tachyons[i] = 0;
            }
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    count = 0;
    for (tachyons) |t| {
        count += t;
    }
    std.debug.print("part 2: {d}\n", .{count});
}
