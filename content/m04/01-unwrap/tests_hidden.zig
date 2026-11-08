const std = @import("std");
const sol = @import("solution.zig");

test "таблица unwrapOr" {
    const cases = [_]struct { x: ?i32, d: i32, want: i32 }{
        .{ .x = std.math.minInt(i32), .d = 0, .want = std.math.minInt(i32) },
        .{ .x = std.math.maxInt(i32), .d = -1, .want = std.math.maxInt(i32) },
        .{ .x = null, .d = std.math.minInt(i32), .want = std.math.minInt(i32) },
        .{ .x = null, .d = std.math.maxInt(i32), .want = std.math.maxInt(i32) },
        .{ .x = 123_456, .d = 0, .want = 123_456 },
        .{ .x = null, .d = 123_456, .want = 123_456 },
    };
    for (cases) |c| {
        try std.testing.expectEqual(c.want, sol.unwrapOr(c.x, c.d));
    }
}

test "unwrapPanic крайние" {
    try std.testing.expectEqual(std.math.minInt(i32), sol.unwrapPanic(std.math.minInt(i32)));
    try std.testing.expectEqual(std.math.maxInt(i32), sol.unwrapPanic(std.math.maxInt(i32)));
}
