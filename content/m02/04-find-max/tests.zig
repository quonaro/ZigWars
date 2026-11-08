const std = @import("std");
const sol = @import("solution.zig");

test "максимум в середине" {
    try std.testing.expectEqual(@as(?usize, 1), sol.indexOfMax(&.{ 1, 9, 3 }));
    try std.testing.expectEqual(@as(?usize, 3), sol.indexOfMax(&.{ 1, 2, 3, 10, 4 }));
}

test "максимум по краям" {
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{ 9, 1, 3 }));
    try std.testing.expectEqual(@as(?usize, 4), sol.indexOfMax(&.{ 1, 2, 3, 4, 50 }));
}

test "все равны — первый" {
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{ 5, 5, 5 }));
}

test "несколько максимумов — первый" {
    try std.testing.expectEqual(@as(?usize, 1), sol.indexOfMax(&.{ 2, 7, 3, 7, 1 }));
}

test "отрицательные числа" {
    try std.testing.expectEqual(@as(?usize, 1), sol.indexOfMax(&.{ -3, -1, -7 }));
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{ -1, -10, -20 }));
}

test "один элемент" {
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{42}));
    try std.testing.expectEqual(@as(?usize, 0), sol.indexOfMax(&.{-42}));
}

test "пустой слайс — null" {
    try std.testing.expectEqual(@as(?usize, null), sol.indexOfMax(&.{}));
    try std.testing.expect(sol.indexOfMax(&.{}) == null);
}

test "развёртывание через if" {
    if (sol.indexOfMax(&.{ 4, 8, 6 })) |idx| {
        try std.testing.expectEqual(@as(usize, 1), idx);
    } else {
        return error.TestUnexpectedResult;
    }
}
