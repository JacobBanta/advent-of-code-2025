const std = @import("std");
pub fn main() !void {
    //std.debug.print("{any}\n", .{isInvalid("1010")});
    var it = std.mem.splitScalar(u8, @embedFile("input.txt"), ',');
    var count: usize = 0;
    var count2: usize = 0;
    while (it.next()) |range| {
        if (range.len == 0) continue;
        var it2 = std.mem.splitScalar(u8, std.mem.trim(u8, range, "\n\r "), '-');
        const min = try std.fmt.parseInt(usize, it2.next().?, 10);
        const max = try std.fmt.parseInt(usize, it2.next().?, 10);
        for (min..max + 1) |id| {
            var buf: [20]u8 = [_]u8{0} ** 20;
            var al = std.ArrayList(u8).initBuffer(buf[0..]);
            al.printAssumeCapacity("{d}", .{id});
            if (isInvalid(al.items)) {
                //std.debug.print("{d}\n", .{id});
                count += id;
            }
            if (isInvalid2(al.items)) {
                count2 += id;
            }
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    std.debug.print("part 2: {d}\n", .{count2});
}
fn isInvalid(id: []const u8) bool {
    if (@mod(id.len, 2) == 1) return false;
    return std.mem.eql(u8, id[0 .. id.len / 2], id[id.len / 2 ..]);
}
fn isInvalid2(id: []const u8) bool {
    if (id.len == 1) return false;
    outer: for (1..@divFloor(id.len, 2) + 1) |patternLen| {
        if (@mod(id.len, patternLen) == 0) {
            for (1..@divExact(id.len, patternLen)) |i| {
                if (!std.mem.eql(u8, id[0..patternLen], id[i * patternLen .. i * patternLen + patternLen])) continue :outer;
            }
            return true;
        }
    }
    return false;
}
