const std = @import("std");
pub fn main() !void {
    const rawinput = @embedFile("input.txt");
    const lineLen = std.mem.indexOfScalar(u8, rawinput, '\n').? + 1;
    var padded = try std.ArrayList(u8).initCapacity(std.heap.page_allocator, rawinput.len + lineLen * 2);
    padded.appendNTimesAssumeCapacity('\n', lineLen);
    padded.appendSliceAssumeCapacity(rawinput);
    padded.appendNTimesAssumeCapacity('\n', lineLen);
    const input = padded.items;

    var neighbors = try std.heap.page_allocator.alloc(i8, rawinput.len + lineLen * 2);
    @memset(neighbors, 0);

    var count: usize = 0;
    for (input, 0..) |char, index| {
        switch (char) {
            '.', '\n' => {
                neighbors[index] = 64;
            },
            '@' => {
                const nearNeighbors = @as(@Vector(8, u8), [8]u8{
                    input[index - lineLen - 1],
                    input[index - 1],
                    input[index + lineLen - 1],
                    input[index - lineLen],
                    input[index + lineLen],
                    input[index - lineLen + 1],
                    input[index + 1],
                    input[index + lineLen + 1],
                });
                neighbors[index] = @reduce(.Add, @as(@Vector(8, i8), @intFromBool(nearNeighbors == @as(@Vector(8, u8), @splat('@')))));
                if (neighbors[index] < 4) {
                    count += 1;
                }
            },
            else => unreachable,
        }
    }
    std.debug.print("part 1: {d}\n", .{count});

    count = 0;
    var index: usize = lineLen;
    while (index < neighbors.len) {
        if (neighbors[index] < 4) {
            count += 1;
            neighbors[index] = 64;
            var nindex = index;
            neighbors[index + lineLen + 1] -= 1;
            if (neighbors[index + lineLen + 1] < 4) {
                nindex = index + lineLen + 1;
            }
            neighbors[index + lineLen] -= 1;
            if (neighbors[index + lineLen] < 4) {
                nindex = index + lineLen;
            }
            neighbors[index + lineLen - 1] -= 1;
            if (neighbors[index + lineLen - 1] < 4) {
                nindex = index + lineLen - 1;
            }
            neighbors[index + 1] -= 1;
            if (neighbors[index + 1] < 4) {
                nindex = index + 1;
            }
            neighbors[index - 1] -= 1;
            if (neighbors[index - 1] < 4) {
                nindex = index - 1;
            }
            neighbors[index - lineLen + 1] -= 1;
            if (neighbors[index - lineLen + 1] < 4) {
                nindex = index - lineLen + 1;
            }
            neighbors[index - lineLen] -= 1;
            if (neighbors[index - lineLen] < 4) {
                nindex = index - lineLen;
            }
            neighbors[index - lineLen - 1] -= 1;
            if (neighbors[index - lineLen - 1] < 4) {
                nindex = index - lineLen - 1;
            }
            index = @min(index, nindex) - 1;
        }
        index += 1;
    }
    std.debug.print("part 2: {d}\n", .{count});
}
