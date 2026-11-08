const std = @import("std");
const sol = @import("solution.zig");

test "unwrapOr со значением" {
    try std.testing.expectEqual(@as(i32, 42), sol.unwrapOr(42, -1));
    try std.testing.expectEqual(@as(i32, 0), sol.unwrapOr(0, 99));
    try std.testing.expectEqual(@as(i32, -7), sol.unwrapOr(-7, 5));
}

test "unwrapOr с null" {
    try std.testing.expectEqual(@as(i32, -1), sol.unwrapOr(null, -1));
    try std.testing.expectEqual(@as(i32, 100), sol.unwrapOr(null, 100));
    try std.testing.expectEqual(@as(i32, 0), sol.unwrapOr(null, 0));
}

test "unwrapPanic" {
    try std.testing.expectEqual(@as(i32, 7), sol.unwrapPanic(7));
    try std.testing.expectEqual(@as(i32, -3), sol.unwrapPanic(-3));
    try std.testing.expectEqual(@as(i32, 0), sol.unwrapPanic(0));
}
