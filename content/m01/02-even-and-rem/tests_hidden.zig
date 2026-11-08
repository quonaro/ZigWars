const std = @import("std");
const sol = @import("solution.zig");

test "отрицательные делители" {
    try std.testing.expect(sol.isMultipleOf(10, -5));
    try std.testing.expect(sol.isMultipleOf(-10, -5));
    try std.testing.expect(!sol.isMultipleOf(7, -3));
    try std.testing.expect(sol.isMultipleOf(0, -7));
}

test "делитель больше числа" {
    try std.testing.expect(!sol.isMultipleOf(5, 10));
    try std.testing.expect(!sol.isMultipleOf(-3, 8));
    try std.testing.expect(sol.isMultipleOf(0, 100));
    try std.testing.expect(!sol.isMultipleOf(1, -2));
}

test "чётность через бит" {
    var n: i32 = -61;
    while (n <= 61) : (n += 1) {
        try std.testing.expectEqual((n & 1) == 0, sol.isEven(n));
    }
    try std.testing.expect(sol.isEven(std.math.minInt(i32)));
    try std.testing.expect(!sol.isEven(std.math.maxInt(i32)));
}
