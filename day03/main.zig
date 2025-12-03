const std = @import("std");
pub fn main() !void {
    var count: usize = 0;
    {
        var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
        while (it.next()) |line| {
            if (line.len == 0) continue;
            const firstIndex = try findLargestIndex(line[0 .. line.len - 1]);
            const secondIndex = try findLargestIndex(line[firstIndex + 1 ..]);
            const joltage = try std.fmt.charToDigit(line[firstIndex], 10) * 10 + try std.fmt.charToDigit((line[firstIndex + 1 ..])[secondIndex], 10);
            //std.debug.print("{d}\n", .{joltage});
            count += joltage;
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    var count2: usize = 0;
    {
        var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
        while (it.next()) |line| {
            if (line.len == 0) continue;
            var joltage: usize = 0;
            var index: usize = 0;
            for (0..12) |i| {
                joltage *= 10;
                const iindex = try findLargestIndex(line[index .. line.len - (11 - i)]);
                joltage += line[index + iindex] - '0';
                index += iindex + 1;
            }
            //std.debug.print("{d}\n", .{joltage});
            count2 += joltage;
        }
    }
    std.debug.print("part 2: {d}\n", .{count2});
}
fn findLargestIndex(line: []const u8) !usize {
    var biggest: u8 = 0;
    var index: usize = 0;
    for (line, 0..) |char, i| {
        if (try std.fmt.charToDigit(char, 10) > biggest) {
            biggest = try std.fmt.charToDigit(char, 10);
            index = i;
        }
    }
    return index;
}
