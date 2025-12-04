const std = @import("std");
pub fn main() !void {
    var input: [@embedFile("input.txt").len]u8 = comptime @embedFile("input.txt").*;
    const lineLen = std.mem.indexOfScalar(u8, &input, '\n').? + 1;
    const lines = @divExact(input.len, lineLen);
    var count: usize = 0;
    for (input, 0..) |char, index| {
        switch (char) {
            '.', '\n' => {},
            '@' => {
                const x = @mod(index, lineLen);
                const y = @divFloor(index, lineLen);
                var rolls: usize = 0;
                if (x >= 1) {
                    if (y >= 1) {
                        if (input[index - lineLen - 1] == '@') {
                            rolls += 1;
                        }
                    }
                    if (input[index - 1] == '@') {
                        rolls += 1;
                    }
                    if (y < lines - 1) {
                        if (input[index + lineLen - 1] == '@') {
                            rolls += 1;
                        }
                    }
                }
                if (y >= 1) {
                    if (input[index - lineLen] == '@') {
                        rolls += 1;
                    }
                }
                if (y < lines - 1) {
                    if (input[index + lineLen] == '@') {
                        rolls += 1;
                    }
                }
                if (x < lineLen - 1) {
                    if (y >= 1) {
                        if (input[index - lineLen + 1] == '@') {
                            rolls += 1;
                        }
                    }
                    if (input[index + 1] == '@') {
                        rolls += 1;
                    }
                    if (y < lines - 1) {
                        if (input[index + lineLen + 1] == '@') {
                            rolls += 1;
                        }
                    }
                }
                if (rolls < 4) {
                    count += 1;
                }
            },
            else => unreachable,
        }
    }
    std.debug.print("part 1: {d}\n", .{count});
    count = 0;
    var pcount: usize = std.math.maxInt(usize);
    while (count != pcount) {
        pcount = count;
        for (input, 0..) |char, index| {
            switch (char) {
                '.', '\n' => {},
                '@' => {
                    const x = @mod(index, lineLen);
                    const y = @divFloor(index, lineLen);
                    var rolls: usize = 0;
                    if (x >= 1) {
                        if (y >= 1) {
                            if (input[index - lineLen - 1] == '@') {
                                rolls += 1;
                            }
                        }
                        if (input[index - 1] == '@') {
                            rolls += 1;
                        }
                        if (y < lines - 1) {
                            if (input[index + lineLen - 1] == '@') {
                                rolls += 1;
                            }
                        }
                    }
                    if (y >= 1) {
                        if (input[index - lineLen] == '@') {
                            rolls += 1;
                        }
                    }
                    if (y < lines - 1) {
                        if (input[index + lineLen] == '@') {
                            rolls += 1;
                        }
                    }
                    if (x < lineLen - 1) {
                        if (y >= 1) {
                            if (input[index - lineLen + 1] == '@') {
                                rolls += 1;
                            }
                        }
                        if (input[index + 1] == '@') {
                            rolls += 1;
                        }
                        if (y < lines - 1) {
                            if (input[index + lineLen + 1] == '@') {
                                rolls += 1;
                            }
                        }
                    }
                    if (rolls < 4) {
                        count += 1;
                        input[index] = '.';
                    }
                },
                else => unreachable,
            }
        }
    }
    std.debug.print("part 2: {d}\n", .{count});
}
