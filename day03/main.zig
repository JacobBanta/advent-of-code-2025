const std = @import("std");
pub fn main() !void {
    var count: usize = 0;
    {
        var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
        while (it.next()) |line| {
            if (line.len == 0) continue;
            // The first battery is any battery other than the last.
            const firstIndex = std.mem.indexOfMax(u8, line[0 .. line.len - 1]);
            // The second battery is any battery after the first.
            const secondIndex = std.mem.indexOfMax(u8, line[firstIndex + 1 ..]);
            const joltage = try std.fmt.charToDigit(line[firstIndex], 10) * 10 + try std.fmt.charToDigit((line[firstIndex + 1 ..])[secondIndex], 10);
            count += joltage;
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    var count2: usize = 0;
    {
        var it = std.mem.splitScalar(u8, @embedFile("input.txt"), '\n');
        while (it.next()) |line| {
            if (line.len == 0) continue;
            // This does the same thing as part 1, except
            // there are less possible choices for the first
            // battery, and the middle batteries are constrained.
            //
            // Its a very simple greedy algorithm.
            var joltage: usize = 0;
            var index: usize = 0;
            for (0..12) |i| {
                joltage *= 10;
                const iindex = std.mem.indexOfMax(u8, line[index .. line.len - (11 - i)]);
                joltage += line[index + iindex] - '0';
                index += iindex + 1;
            }
            count2 += joltage;
        }
    }
    std.debug.print("part 2: {d}\n", .{count2});
}
