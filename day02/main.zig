const std = @import("std");
pub fn main() !void {
    var it = std.mem.splitScalar(u8, @embedFile("input.txt"), ',');
    var count: usize = 0;
    var count2: usize = 0;
    while (it.next()) |range| {
        if (range.len == 0) continue;
        inline for (1..11) |x| {
            var it2 = std.mem.splitScalar(u8, std.mem.trim(u8, range, "\n\r "), '-');
            var min = try std.fmt.parseInt(usize, it2.next().?, 10);
            var max = try std.fmt.parseInt(usize, it2.next().?, 10);
            if (digitCount(max) < x * 2) break;
            if (std.math.comptimeMod(digitCount(min), x) != 0) {
                min = POW10[digitCount(min)];
            }
            if (std.math.comptimeMod(digitCount(max), x) != 0) {
                if (digitCount(max) == 0) {
                    max = 0;
                } else {
                    max = POW10[digitCount(max) - 1];
                }
            }
            if (min < max) {
                var newMin = min;
                {
                    var offset: usize = 1;
                    for (0..digitCount(newMin) / x - 1) |_| {
                        for (0..x) |_| {
                            offset *= 10;
                            newMin = @divFloor(newMin, 10);
                        }
                        offset += 1;
                    }
                    newMin *= offset;
                    if (newMin < min) newMin += offset;
                }
                var id: usize = newMin;
                outer: while (id < max + 1) : (id += 1) {
                    if (id < 10) continue;
                    if (isInvalid(id, x)) {
                        if (id < newMin) std.debug.print("{d} < {d}\n", .{ id, newMin });
                        if (digitCount(id) == x * 2)
                            count += id;
                        inline for (1..x) |i| {
                            if (isInvalid(id, i)) {
                                continue :outer;
                            }
                        }
                        count2 += id;
                        var offset: usize = 1;
                        for (0..digitCount(id) / x - 1) |_| {
                            for (0..x) |_| {
                                offset *= 10;
                            }
                            offset += 1;
                        }
                        id += offset - 1;
                    }
                }
            }
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    std.debug.print("part 2: {d}\n", .{count2});
}
fn isInvalid(id: usize, comptime patternLen: usize) bool {
    const repetitions: usize = digitCount(id) / patternLen;
    if (repetitions == 1) return false;
    const pattern = std.math.comptimeMod(id, comptime std.math.pow(usize, 10, patternLen));
    const d = digitCount(pattern);
    var remaining = id;
    inline for (0..11) |rep| {
        if (repetitions == rep) {
            var i: u32 = 0;
            while (i < rep) : (i += 1) {
                const segment = remaining % POW10[d];
                if (segment != pattern) return false; // Early exit on mismatch
                remaining /= POW10[d];
            }
            return remaining == 0;
        }
    }
    unreachable;
}

pub fn digitCount(n: usize) usize {
    // input has max 10 digit numbers
    if (n >= 1000000000) return 10;
    if (n >= 100000000) return 9;
    if (n >= 10000000) return 8;
    if (n >= 1000000) return 7;
    if (n >= 100000) return 6;
    if (n >= 10000) return 5;
    if (n >= 1000) return 4;
    if (n >= 100) return 3;
    if (n >= 10) return 2;
    return 1;
}
const POW10 = [11]u64{ 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000 };
