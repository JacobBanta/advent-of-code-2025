const std = @import("std");
pub fn main() !void {
    const input = @embedFile("input.txt");
    const lineLen = std.mem.indexOfScalar(u8, input, '\n').? + 1;
    const lines = @divExact(input.len, lineLen);

    var neighbors = [_]i8{0} ** input.len;

    var count: usize = 0;
    for (input, 0..) |char, index| {
        switch (char) {
            '.', '\n' => {
                neighbors[index] = 64;
            },
            '@' => {
                const x = @mod(index, lineLen);
                const y = @divFloor(index, lineLen);
                // This is a lot, but neighbor checking looks rough
                if (x >= 1) {
                    if (y >= 1) {
                        if (input[index - lineLen - 1] == '@') {
                            neighbors[index] += 1;
                        }
                    }
                    if (input[index - 1] == '@') {
                        neighbors[index] += 1;
                    }
                    if (y < lines - 1) {
                        if (input[index + lineLen - 1] == '@') {
                            neighbors[index] += 1;
                        }
                    }
                }
                if (y >= 1) {
                    if (input[index - lineLen] == '@') {
                        neighbors[index] += 1;
                    }
                }
                if (y < lines - 1) {
                    if (input[index + lineLen] == '@') {
                        neighbors[index] += 1;
                    }
                }
                if (x < lineLen - 1) {
                    if (y >= 1) {
                        if (input[index - lineLen + 1] == '@') {
                            neighbors[index] += 1;
                        }
                    }
                    if (input[index + 1] == '@') {
                        neighbors[index] += 1;
                    }
                    if (y < lines - 1) {
                        if (input[index + lineLen + 1] == '@') {
                            neighbors[index] += 1;
                        }
                    }
                }
                if (neighbors[index] < 4) {
                    count += 1;
                }
            },
            else => unreachable,
        }
    }
    std.debug.print("part 1: {d}\n", .{count});

    count = 0;
    var index: usize = 0;
    while (index < neighbors.len) {
        if (neighbors[index] < 4) {
            count += 1;
            neighbors[index] = 64;
            const x = @mod(index, lineLen);
            const y = @divFloor(index, lineLen);
            var nindex = index;
            if (y < lines - 1) {
                if (x < lineLen - 1) {
                    neighbors[index + lineLen + 1] -= 1;
                    if (neighbors[index + lineLen + 1] < 4) {
                        nindex = index + lineLen + 1;
                    }
                }
                neighbors[index + lineLen] -= 1;
                if (neighbors[index + lineLen] < 4) {
                    nindex = index + lineLen;
                }
                if (x >= 1) {
                    neighbors[index + lineLen - 1] -= 1;
                    if (neighbors[index + lineLen - 1] < 4) {
                        nindex = index + lineLen - 1;
                    }
                }
            }

            if (x < lineLen - 1) {
                neighbors[index + 1] -= 1;
                if (neighbors[index + 1] < 4) {
                    nindex = index + 1;
                }
            }

            if (x >= 1) {
                neighbors[index - 1] -= 1;
                if (neighbors[index - 1] < 4) {
                    nindex = index - 1;
                }
            }

            if (y >= 1) {
                if (x < lineLen - 1) {
                    neighbors[index - lineLen + 1] -= 1;
                    if (neighbors[index - lineLen + 1] < 4) {
                        nindex = index - lineLen + 1;
                    }
                }
                neighbors[index - lineLen] -= 1;
                if (neighbors[index - lineLen] < 4) {
                    nindex = index - lineLen;
                }
                if (x >= 1) {
                    neighbors[index - lineLen - 1] -= 1;
                    if (neighbors[index - lineLen - 1] < 4) {
                        nindex = index - lineLen - 1;
                    }
                }
            }
            index = @min(index, nindex) - 1;
        }
        index += 1;
    }
    std.debug.print("part 2: {d}\n", .{count});
}
