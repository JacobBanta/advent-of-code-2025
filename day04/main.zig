const std = @import("std");
pub fn main() !void {
    var input: [@embedFile("input.txt").len]u8 = comptime @embedFile("input.txt").*;
    const lineLen = std.mem.indexOfScalar(u8, &input, '\n').? + 1;
    const lines = @divExact(input.len, lineLen);

    var initialBuffer: [32 * 1024]usize = undefined;
    var stack = std.ArrayList(usize).initBuffer(initialBuffer[0..]);

    var count: usize = 0;
    for (input, 0..) |char, index| {
        switch (char) {
            '.', '\n' => {},
            '@' => {
                stack.appendAssumeCapacity(index);
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
    while (stack.pop()) |index| {
        const char = input[index];
        switch (char) {
            '.', '\n' => {},
            '@' => {
                const x = @mod(index, lineLen);
                const y = @divFloor(index, lineLen);
                var rolls: usize = 0;
                if (y < lines - 1) {
                    if (x < lineLen - 1) {
                        if (input[index + lineLen + 1] == '@') {
                            rolls += 1;
                        }
                    }
                    if (input[index + lineLen] == '@') {
                        rolls += 1;
                    }
                    if (x >= 1) {
                        if (input[index + lineLen - 1] == '@') {
                            rolls += 1;
                        }
                    }
                }

                if (x < lineLen - 1) {
                    if (input[index + 1] == '@') {
                        rolls += 1;
                    }
                }

                if (x >= 1) {
                    if (input[index - 1] == '@') {
                        rolls += 1;
                    }
                }

                if (y >= 1) {
                    if (x < lineLen - 1) {
                        if (input[index - lineLen + 1] == '@') {
                            rolls += 1;
                        }
                    }
                    if (input[index - lineLen] == '@') {
                        rolls += 1;
                    }
                    if (x >= 1) {
                        if (input[index - lineLen - 1] == '@') {
                            rolls += 1;
                        }
                    }
                }
                if (rolls < 4) {
                    count += 1;
                    input[index] = '.';

                    var buf: [3]usize = undefined;
                    var newStack = std.ArrayList(usize).initBuffer(buf[0..]);
                    if (y >= 1) {
                        if (x >= 1) {
                            if (input[index - lineLen - 1] == '@') {
                                newStack.appendAssumeCapacity(index - lineLen - 1);
                            }
                        }
                        if (input[index - lineLen] == '@') {
                            newStack.appendAssumeCapacity(index - lineLen);
                        }
                        if (x < lineLen - 1) {
                            if (input[index - lineLen + 1] == '@') {
                                newStack.appendAssumeCapacity(index - lineLen + 1);
                            }
                        }
                    }

                    if (x >= 1) {
                        if (input[index - 1] == '@') {
                            newStack.appendAssumeCapacity(index - 1);
                        }
                    }

                    if (x < lineLen - 1) {
                        if (input[index + 1] == '@') {
                            newStack.appendAssumeCapacity(index + 1);
                        }
                    }

                    if (y < lines - 1) {
                        if (x >= 1) {
                            if (input[index + lineLen - 1] == '@') {
                                newStack.appendAssumeCapacity(index + lineLen - 1);
                            }
                        }
                        if (input[index + lineLen] == '@') {
                            newStack.appendAssumeCapacity(index + lineLen);
                        }
                        if (x < lineLen - 1) {
                            if (input[index + lineLen + 1] == '@') {
                                newStack.appendAssumeCapacity(index + lineLen + 1);
                            }
                        }
                    }
                    stack.appendSliceAssumeCapacity(newStack.items);

                    continue;
                }
            },
            else => unreachable,
        }
    }
    std.debug.print("part 2: {d}\n", .{count});
}
