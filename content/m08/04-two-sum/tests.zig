const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

test "классические случаи" {
    try std.testing.expectEqual(@as(?[2]usize, .{ 0, 1 }), try sol.twoSum(A, &.{ 2, 7, 11, 15 }, 9));
    try std.testing.expectEqual(@as(?[2]usize, .{ 1, 2 }), try sol.twoSum(A, &.{ 3, 2, 4 }, 6));
    try std.testing.expectEqual(@as(?[2]usize, .{ 0, 1 }), try sol.twoSum(A, &.{ 3, 3 }, 6));
}

test "нет пары" {
    try std.testing.expectEqual(@as(?[2]usize, null), try sol.twoSum(A, &.{ 1, 5, 9 }, 100));
    try std.testing.expectEqual(@as(?[2]usize, null), try sol.twoSum(A, &.{5}, 10));
    try std.testing.expectEqual(@as(?[2]usize, null), try sol.twoSum(A, &.{}, 0));
}

test "нельзя использовать один элемент дважды" {
    // 5 + 5 = 10, но элемент один — ответа нет
    try std.testing.expectEqual(@as(?[2]usize, null), try sol.twoSum(A, &.{ 5, 1, 2 }, 10));
}

test "отрицательные числа" {
    try std.testing.expectEqual(@as(?[2]usize, .{ 0, 2 }), try sol.twoSum(A, &.{ -1, 5, -4, 3 }, -5));
}

test "пара не на краях" {
    try std.testing.expectEqual(@as(?[2]usize, .{ 1, 3 }), try sol.twoSum(A, &.{ 0, 4, 9, 3, 2 }, 7));
}
