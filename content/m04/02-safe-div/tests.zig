const std = @import("std");
const sol = @import("solution.zig");

test "обычное деление" {
    try std.testing.expectEqual(@as(?i32, 5), sol.safeDiv(10, 2));
    try std.testing.expectEqual(@as(?i32, 0), sol.safeDiv(0, 7));
    try std.testing.expectEqual(@as(?i32, 4), sol.safeDiv(-8, -2));
}

test "усечение к нулю" {
    try std.testing.expectEqual(@as(?i32, -3), sol.safeDiv(-7, 2));
    try std.testing.expectEqual(@as(?i32, -3), sol.safeDiv(7, -2));
    try std.testing.expectEqual(@as(?i32, 3), sol.safeDiv(7, 2));
}

test "деление на ноль" {
    try std.testing.expectEqual(@as(?i32, null), sol.safeDiv(10, 0));
    try std.testing.expectEqual(@as(?i32, null), sol.safeDiv(-1, 0));
    try std.testing.expect(sol.safeDiv(5, 0) == null);
}
