const std = @import("std");
const sol = @import("solution.zig");

test "внутри диапазона" {
    try std.testing.expectEqual(5, sol.clamp(5, 0, 10));
    try std.testing.expectEqual(0, sol.clamp(0, 0, 10));
    try std.testing.expectEqual(10, sol.clamp(10, 0, 10));
}

test "за границами" {
    try std.testing.expectEqual(0, sol.clamp(-3, 0, 10));
    try std.testing.expectEqual(10, sol.clamp(15, 0, 10));
    try std.testing.expectEqual(-5, sol.clamp(-100, -5, 5));
}

test "вырожденный диапазон" {
    try std.testing.expectEqual(7, sol.clamp(7, 7, 7));
    try std.testing.expectEqual(7, sol.clamp(100, 7, 7));
}
