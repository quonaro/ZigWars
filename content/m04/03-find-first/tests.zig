const std = @import("std");
const sol = @import("solution.zig");

fn isEven(x: i32) bool {
    return @rem(x, 2) == 0;
}

fn isNegative(x: i32) bool {
    return x < 0;
}

fn isBig(x: i32) bool {
    return x > 100;
}

test "находит первый подходящий" {
    try std.testing.expectEqual(@as(?i32, 4), sol.findFirst(&[_]i32{ 1, 3, 4, 6 }, isEven));
    try std.testing.expectEqual(@as(?i32, -5), sol.findFirst(&[_]i32{ 1, -5, -2, 8 }, isNegative));
    try std.testing.expectEqual(@as(?i32, 200), sol.findFirst(&[_]i32{ 200, 1, 300 }, isBig));
}

test "именно первый, а не последний" {
    try std.testing.expectEqual(@as(?i32, 2), sol.findFirst(&[_]i32{ 2, 4, 8 }, isEven));
    try std.testing.expectEqual(@as(?i32, -1), sol.findFirst(&[_]i32{ -1, -2, -3 }, isNegative));
}

test "ничего не нашлось" {
    try std.testing.expectEqual(@as(?i32, null), sol.findFirst(&[_]i32{ 1, 3, 5 }, isEven));
    try std.testing.expectEqual(@as(?i32, null), sol.findFirst(&[_]i32{ 0, 50 }, isBig));
    try std.testing.expect(sol.findFirst(&[_]i32{ 7 }, isNegative) == null);
}

test "пустой слайс" {
    try std.testing.expectEqual(@as(?i32, null), sol.findFirst(&[_]i32{}, isEven));
}
