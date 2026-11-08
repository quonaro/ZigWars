const std = @import("std");
const sol = @import("solution.zig");

test "чётные и нечётные" {
    try std.testing.expect(sol.isEven(4));
    try std.testing.expect(sol.isEven(0));
    try std.testing.expect(!sol.isEven(7));
    try std.testing.expect(sol.isEven(-6));
    try std.testing.expect(!sol.isEven(-3));
}

test "кратность" {
    try std.testing.expect(sol.isMultipleOf(10, 5));
    try std.testing.expect(!sol.isMultipleOf(10, 3));
    try std.testing.expect(sol.isMultipleOf(-9, 3));
    try std.testing.expect(sol.isMultipleOf(0, 7));
    try std.testing.expect(!sol.isMultipleOf(1, 2));
}
