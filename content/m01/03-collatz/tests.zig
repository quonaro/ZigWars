const std = @import("std");
const sol = @import("solution.zig");

test "простые случаи" {
    try std.testing.expectEqual(@as(usize, 0), sol.collatzSteps(1));
    try std.testing.expectEqual(@as(usize, 1), sol.collatzSteps(2));
    try std.testing.expectEqual(@as(usize, 7), sol.collatzSteps(3));
}

test "классика" {
    try std.testing.expectEqual(@as(usize, 8), sol.collatzSteps(6));
    try std.testing.expectEqual(@as(usize, 111), sol.collatzSteps(27));
    try std.testing.expectEqual(@as(usize, 9), sol.collatzSteps(12));
}
