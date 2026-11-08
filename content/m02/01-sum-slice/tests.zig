const std = @import("std");
const sol = @import("solution.zig");

test "обычный слайс" {
    try std.testing.expectEqual(@as(i64, 6), sol.sumSlice(&.{ 1, 2, 3 }));
    try std.testing.expectEqual(@as(i64, 10), sol.sumSlice(&.{ 4, 5, 1 }));
}

test "отрицательные числа" {
    try std.testing.expectEqual(@as(i64, -6), sol.sumSlice(&.{ -1, -2, -3 }));
    try std.testing.expectEqual(@as(i64, 0), sol.sumSlice(&.{ -5, 5 }));
    try std.testing.expectEqual(@as(i64, -10), sol.sumSlice(&.{ 10, -30, 10 }));
}

test "пустой слайс" {
    try std.testing.expectEqual(@as(i64, 0), sol.sumSlice(&.{}));
    const empty: []const i32 = &.{};
    try std.testing.expectEqual(@as(i64, 0), sol.sumSlice(empty));
}

test "один элемент" {
    try std.testing.expectEqual(@as(i64, 42), sol.sumSlice(&.{42}));
    try std.testing.expectEqual(@as(i64, -7), sol.sumSlice(&.{-7}));
}

test "большие значения без переполнения" {
    try std.testing.expectEqual(@as(i64, 4_000_000_000), sol.sumSlice(&.{ 2_000_000_000, 2_000_000_000 }));
}

test "слайс от массива" {
    const arr = [_]i32{ 7, 8, 9, 10, 11 };
    try std.testing.expectEqual(@as(i64, 45), sol.sumSlice(&arr));
    try std.testing.expectEqual(@as(i64, 27), sol.sumSlice(arr[1..4]));
}
