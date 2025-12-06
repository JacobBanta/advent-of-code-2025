const std = @import("std");
pub fn main() !void {
    const input = @embedFile("input.txt");
    const lines = std.mem.count(u8, input, "\n");
    const lineLen = @divExact(input.len, lines);
    const operators = input[lineLen * (lines - 1) .. input.len - 1];
    var numbers: [][]const u8 = try std.heap.page_allocator.alloc([]const u8, lines - 1);
    for (0..lines - 1) |i| {
        numbers[i] = input[lineLen * (i) .. lineLen * (i + 1) - 1];
    }
    var operatorIterator = std.mem.splitScalar(u8, operators, ' ');
    var count: usize = 0;
    while (operatorIterator.next()) |operator| {
        if (operator.len == 0) continue;
        const index = operatorIterator.index.?;
        var math: usize = 0;
        if (operator[0] == '+') {
            for (0..lines - 1) |x| {
                const startIndex = std.mem.indexOfAnyPos(u8, numbers[x], index - 2, "123456789").?;
                math += std.fmt.parseInt(usize, numbers[x][startIndex .. std.mem.indexOfScalarPos(u8, numbers[x], startIndex, ' ') orelse lineLen - 1], 10) catch 0;
            }
        }
        if (operator[0] == '*') {
            math += 1;
            for (0..lines - 1) |x| {
                const startIndex = std.mem.indexOfAnyPos(u8, numbers[x], index - 2, "123456789").?;
                math *= std.fmt.parseInt(usize, numbers[x][startIndex .. std.mem.indexOfScalarPos(u8, numbers[x], startIndex, ' ') orelse lineLen - 1], 10) catch 1;
            }
        }
        count += math;
    }
    std.debug.print("part 1: {d}\n", .{count});
    count = 0;
    operatorIterator.reset();
    while (operatorIterator.next()) |operator| {
        if (operator.len == 0) continue;
        const index = operatorIterator.index.? - 2;
        var sum: usize = 0;
        if (operator[0] == '*') {
            sum = 1;
        }
        for (index..lineLen - 1) |i| {
            var num: usize = 0;
            for (0..lines - 1) |x| {
                if (numbers[x][i] == ' ') continue;
                num *= 10;
                num += numbers[x][i] - '0';
            }
            if (num == 0) break;
            if (operator[0] == '+') {
                sum += num;
            } else if (operator[0] == '*') {
                sum *= num;
            } else unreachable;
        }
        count += sum;
    }
    std.debug.print("part 2: {d}\n", .{count});
}
