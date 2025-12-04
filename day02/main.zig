const std = @import("std");
pub fn main() !void {
    var it = std.mem.splitScalar(u8, @embedFile("input.txt"), ',');
    var count: usize = 0;
    var count2: usize = 0;
    while (it.next()) |range| {
        if (range.len == 0) continue;
        // this being inline lets patternLen be comptime,
        // which trickles a little bit of speed through.
        // Specifically, the std.math.comptimeMod is faster than @mod,
        // but it requires the denominator to be comptime known
        inline for (1..11) |patternLen| {
            var it2 = std.mem.splitScalar(u8, std.mem.trim(u8, range, "\n\r "), '-');
            var min = try std.fmt.parseInt(usize, it2.next().?, 10);
            var max = try std.fmt.parseInt(usize, it2.next().?, 10);
            if (digitCount(max) < patternLen * 2) break;
            // Here, we limit the range to be just what is possible to to have with the patternLen
            if (std.math.comptimeMod(digitCount(min), patternLen) != 0) {
                min = POW10[digitCount(min)];
            }
            if (std.math.comptimeMod(digitCount(max), patternLen) != 0) {
                if (digitCount(max) == 0) {
                    max = 0;
                } else {
                    max = POW10[digitCount(max) - 1];
                }
            }
            if (min < max) {
                // Here we calculate the first invalid ID
                var newMin = min;
                {
                    var offset: usize = 1;
                    for (0..digitCount(newMin) / patternLen - 1) |_| {
                        for (0..patternLen) |_| {
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
                    // Not optimal, but it is needed because of when you
                    // cross orders of magnitude, some edge cases arise.
                    if (isInvalid(id, patternLen)) {
                        if (id < newMin) std.debug.print("{d} < {d}\n", .{ id, newMin });
                        if (digitCount(id) == patternLen * 2)
                            count += id;
                        inline for (1..patternLen) |i| {
                            if (isInvalid(id, i)) {
                                continue :outer;
                            }
                        }
                        count2 += id;
                        // Also not optimal, but it is what it is.
                        var offset: usize = 1;
                        for (0..digitCount(id) / patternLen - 1) |_| {
                            for (0..patternLen) |_| {
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

/// Determines if an ID is invalid for a given patternLen.
/// For example, 123123123 is invalid with a patternLen of 3, but not 1 or 2.
fn isInvalid(id: usize, comptime patternLen: usize) bool {
    const repetitions: usize = digitCount(id) / patternLen;
    if (repetitions == 1) return false;
    const pattern = std.math.comptimeMod(id, comptime std.math.pow(usize, 10, patternLen));
    var remaining = id;
    // Compares the last segment to the first,
    // then shifts to the right (in base 10).
    for (0..repetitions - 1) |_| {
        const segment = remaining % POW10[patternLen];
        remaining /= POW10[patternLen];
        if (segment != pattern) return false;
    }
    return remaining == pattern;
}

/// Counts the number of digits in the number.
pub fn digitCount(n: usize) usize {
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
