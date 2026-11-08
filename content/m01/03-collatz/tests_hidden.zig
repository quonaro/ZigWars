const std = @import("std");
const sol = @import("solution.zig");

fn refSteps(n: u64) usize {
    var x = n;
    var s: usize = 0;
    while (x != 1) {
        x = if (@rem(x, 2) == 0) x / 2 else 3 * x + 1;
        s += 1;
    }
    return s;
}

test "степени двойки" {
    try std.testing.expectEqual(@as(usize, 4), sol.collatzSteps(16));
    try std.testing.expectEqual(@as(usize, 5), sol.collatzSteps(32));
    try std.testing.expectEqual(@as(usize, 10), sol.collatzSteps(1024));
    try std.testing.expectEqual(@as(usize, 20), sol.collatzSteps(1_048_576));
    try std.testing.expectEqual(@as(usize, 63), sol.collatzSteps(@as(u64, 1) << 63));
}

test "сверка с эталонным циклом" {
    var n: u64 = 1;
    while (n <= 300) : (n += 1) {
        try std.testing.expectEqual(refSteps(n), sol.collatzSteps(n));
    }
    const big = [_]u64{ 31, 97, 255, 511, 703, 6171, 837799 };
    for (big) |v| {
        try std.testing.expectEqual(refSteps(v), sol.collatzSteps(v));
    }
}
