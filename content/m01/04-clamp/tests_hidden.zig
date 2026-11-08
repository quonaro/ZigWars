const std = @import("std");
const sol = @import("solution.zig");

test "отрицательный диапазон" {
    try std.testing.expectEqual(@as(i32, -50), sol.clamp(-50, -50, -10));
    try std.testing.expectEqual(@as(i32, -10), sol.clamp(-10, -50, -10));
    try std.testing.expectEqual(@as(i32, -30), sol.clamp(-30, -50, -10));
    try std.testing.expectEqual(@as(i32, -50), sol.clamp(-999, -50, -10));
}

test "экстремумы i32" {
    try std.testing.expectEqual(@as(i32, 0), sol.clamp(std.math.minInt(i32), 0, 100));
    try std.testing.expectEqual(@as(i32, 5), sol.clamp(std.math.maxInt(i32), -5, 5));
    try std.testing.expectEqual(std.math.minInt(i32), sol.clamp(std.math.minInt(i32), std.math.minInt(i32), std.math.maxInt(i32)));
    try std.testing.expectEqual(std.math.maxInt(i32), sol.clamp(std.math.maxInt(i32), std.math.minInt(i32), std.math.maxInt(i32)));
}

test "сверка со std.math.clamp" {
    var state: u64 = 0xB5297A4D;
    var i: usize = 0;
    while (i < 300) : (i += 1) {
        state = state *% 6364136223846793005 +% 1442695040888963407;
        const x: i32 = @intCast(@rem(@as(i64, @bitCast(state >> 9)), 10_000));
        state = state *% 6364136223846793005 +% 1442695040888963407;
        var lo: i32 = @intCast(@rem(@as(i64, @bitCast(state >> 5)), 5_000));
        state = state *% 6364136223846793005 +% 1442695040888963407;
        var hi: i32 = @intCast(@rem(@as(i64, @bitCast(state >> 3)), 5_000));
        if (lo > hi) {
            const t = lo;
            lo = hi;
            hi = t;
        }
        try std.testing.expectEqual(std.math.clamp(x, lo, hi), sol.clamp(x, lo, hi));
    }
}
