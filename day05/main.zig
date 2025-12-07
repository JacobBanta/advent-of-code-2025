const std = @import("std");
const Range = struct { min: usize, max: usize };
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    const allocator = gpa.allocator();
    var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
    var ranges = std.ArrayList(Range).empty;
    while (it.next()) |range| {
        if (range.len == 0) break;
        var it2 = std.mem.splitScalar(u8, range, '-');
        try ranges.append(allocator, .{
            .min = try std.fmt.parseInt(usize, it2.next().?, 10),
            .max = try std.fmt.parseInt(usize, it2.next().?, 10),
        });
    }
    std.mem.sort(Range, ranges.items, {}, struct {
        pub fn inner(_: void, a: Range, b: Range) bool {
            return a.min < b.min;
        }
    }.inner);
    var count2: usize = 0;
    var newRanges = std.ArrayList(Range).empty;
    var index: usize = 1;
    var min = ranges.items[0].min;
    var max = ranges.items[0].max;
    while (index < ranges.items.len) : (index += 1) {
        if (ranges.items[index].min > max + 1) {
            count2 += max - min + 1;
            try newRanges.append(allocator, .{ .min = min, .max = max });
            min = ranges.items[index].min;
            max = ranges.items[index].max;
            continue;
        }
        if (ranges.items[index].max > max) {
            max = ranges.items[index].max;
        }
    }
    count2 += max - min + 1;
    try newRanges.append(allocator, .{ .min = min, .max = max });
    var count: usize = 0;
    while (it.next()) |food| {
        if (food.len == 0) break;
        const id = try std.fmt.parseInt(usize, food, 10);
        if (std.sort.binarySearch(Range, newRanges.items, id, struct {
            pub fn inner(i: usize, a: Range) std.math.Order {
                if (i > a.max) return .gt;
                if (i < a.min) return .lt;
                return .eq;
            }
        }.inner) != null) {
            count += 1;
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    std.debug.print("part 2: {d}\n", .{count2});
}
