const std = @import("std");
const sol = @import("solution.zig");

test "все minInt — первый" {
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{ std.math.minInt(i32), std.math.minInt(i32), std.math.minInt(i32) }));
}

test "максимум в конце массива" {
    var buf: [64]i32 = undefined;
    @memset(&buf, -100);
    buf[63] = 999;
    try std.testing.expectEqual(@as(?usize, 63), sol.indexOfMax(&buf));
}

test "два равных максимума в конце" {
    try std.testing.expectEqual(@as(?usize, 2), sol.indexOfMax(&.{ 1, 0, 9, 5, 9 }));
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{ 8, 8, 8, 8 }));
}

test "сверка с эталонным поиском" {
    var state: u64 = 0x12345678;
    var round: usize = 0;
    while (round < 100) : (round += 1) {
        var buf: [17]i32 = undefined;
        for (&buf) |*x| {
            state = state *% 6364136223846793005 +% 1442695040888963407;
            x.* = @intCast(@rem(@as(i64, @bitCast(state >> 13)), 50));
        }
        var want: usize = 0;
        for (buf[1..], 1..) |x, i| {
            if (x > buf[want]) want = i;
        }
        try std.testing.expectEqual(@as(?usize, want), sol.indexOfMax(&buf));
    }
}
