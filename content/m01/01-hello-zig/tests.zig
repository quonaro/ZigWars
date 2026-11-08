const std = @import("std");
const sol = @import("solution.zig");

test "положительные числа" {
    try std.testing.expectEqual(5, sol.add(2, 3));
    try std.testing.expectEqual(100, sol.add(40, 60));
}

test "отрицательные и ноль" {
    try std.testing.expectEqual(0, sol.add(-1, 1));
    try std.testing.expectEqual(-10, sol.add(-4, -6));
    try std.testing.expectEqual(7, sol.add(7, 0));
}
