const std = @import("std");
pub fn main() !void {
    const input = @embedFile("input.txt");
    const linelen = std.mem.indexOfScalar(u8, input, '\n').?;
    const tachyons = try std.heap.page_allocator.alloc(usize, linelen);
    @memset(tachyons, 0);
    // Storing all of the tachyons positions in an array
    // makes it really easy to track the superposition.
    tachyons[std.mem.indexOfScalar(u8, input, 'S').?] = 1;
    var it = std.mem.splitScalar(u8, input, '\n');
    var count: usize = 0;
    while (it.next()) |line| {
        if (line.len == 0) continue;
        _ = it.next();
        var i: usize = 0;
        while (true) {
            i = std.mem.indexOfScalarPos(u8, line, i + 1, '^') orelse break;
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
