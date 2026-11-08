const std = @import("std");
const sol = @import("solution.zig");

test "границы i32" {
    try std.testing.expectEqual(std.math.maxInt(i32), sol.add(std.math.maxInt(i32), 0));
    try std.testing.expectEqual(std.math.minInt(i32), sol.add(std.math.minInt(i32), 0));
    try std.testing.expectEqual(@as(i32, -1), sol.add(std.math.minInt(i32), std.math.maxInt(i32)));
    try std.testing.expectEqual(std.math.maxInt(i32), sol.add(2_000_000_000, 147_483_647));
}

test "псевдослучайные пары" {
    var state: u64 = 0x9E3779B97F4A7C15;
    var i: usize = 0;
    while (i < 200) : (i += 1) {
        state = state *% 6364136223846793005 +% 1442695040888963407;
        const a: i32 = @intCast(@rem(@as(i64, @bitCast(state >> 11)), 2_000_000));
        state = state *% 6364136223846793005 +% 1442695040888963407;
        const b: i32 = @intCast(@rem(@as(i64, @bitCast(state >> 7)), 2_000_000));
        const want: i64 = @as(i64, a) + b;
        try std.testing.expectEqual(want, @as(i64, sol.add(a, b)));
    }
}
