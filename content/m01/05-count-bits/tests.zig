const std = @import("std");
const sol = @import("solution.zig");

test "ручные случаи" {
    try std.testing.expectEqual(@as(u32, 0), sol.countOnes(0));
    try std.testing.expectEqual(@as(u32, 1), sol.countOnes(1));
    try std.testing.expectEqual(@as(u32, 3), sol.countOnes(0b1011));
    try std.testing.expectEqual(@as(u32, 32), sol.countOnes(0xFFFFFFFF));
    try std.testing.expectEqual(@as(u32, 1), sol.countOnes(0x80000000));
}

test "сверка с @popCount" {
    // оракул — честный ответ компилятора
    const cases = [_]u32{ 3, 17, 255, 1024, 65537, 123_456_789 };
    for (cases) |x| {
        try std.testing.expectEqual(@popCount(x), sol.countOnes(x));
    }
}
