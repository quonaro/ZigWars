const std = @import("std");
const sol = @import("solution.zig");

test "одиночный бит на каждой позиции" {
    var i: usize = 0;
    while (i < 32) : (i += 1) {
        const x: u32 = @as(u32, 1) << @intCast(i);
        try std.testing.expectEqual(@as(u32, 1), sol.countOnes(x));
    }
}

test "паттерны" {
    try std.testing.expectEqual(@as(u32, 16), sol.countOnes(0xAAAAAAAA));
    try std.testing.expectEqual(@as(u32, 16), sol.countOnes(0x55555555));
    try std.testing.expectEqual(@as(u32, 16), sol.countOnes(0xFF00FF00));
    try std.testing.expectEqual(@as(u32, 16), sol.countOnes(0xFFFF0000));
    try std.testing.expectEqual(@as(u32, 16), sol.countOnes(0x0000FFFF));
    try std.testing.expectEqual(@as(u32, 8), sol.countOnes(0x000000FF));
    try std.testing.expectEqual(@as(u32, 24), sol.countOnes(0xFFFFFF00));
}

test "генератор против @popCount" {
    var state: u64 = 0xC0FFEE42;
    var i: usize = 0;
    while (i < 256) : (i += 1) {
        state = state *% 6364136223846793005 +% 1442695040888963407;
        const x: u32 = @truncate(state >> 17);
        try std.testing.expectEqual(@popCount(x), sol.countOnes(x));
    }
}
