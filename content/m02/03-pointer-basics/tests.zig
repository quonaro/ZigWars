const std = @import("std");
const sol = @import("solution.zig");

test "swap двух переменных" {
    var x: i32 = 1;
    var y: i32 = 2;
    sol.swap(&x, &y);
    try std.testing.expectEqual(@as(i32, 2), x);
    try std.testing.expectEqual(@as(i32, 1), y);
}

test "swap с отрицательными" {
    var x: i32 = -10;
    var y: i32 = 7;
    sol.swap(&x, &y);
    try std.testing.expectEqual(@as(i32, 7), x);
    try std.testing.expectEqual(@as(i32, -10), y);
}

test "swap одинаковых значений" {
    var x: i32 = 5;
    var y: i32 = 5;
    sol.swap(&x, &y);
    try std.testing.expectEqual(@as(i32, 5), x);
    try std.testing.expectEqual(@as(i32, 5), y);
}

test "incAll положительная дельта" {
    var xs = [_]i32{ 1, 2, 3 };
    sol.incAll(&xs, 10);
    try std.testing.expectEqualSlices(i32, &.{ 11, 12, 13 }, &xs);
}

test "incAll отрицательная дельта" {
    var xs = [_]i32{ 5, 0, -5 };
    sol.incAll(&xs, -3);
    try std.testing.expectEqualSlices(i32, &.{ 2, -3, -8 }, &xs);
}

test "incAll ноль и пустой слайс" {
    var xs = [_]i32{ 1, 2 };
    sol.incAll(&xs, 0);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2 }, &xs);
    var empty = [_]i32{};
    sol.incAll(&empty, 100);
}

test "swap элементов слайса" {
    var xs = [_]i32{ 9, 8, 7 };
    sol.swap(&xs[0], &xs[2]);
    try std.testing.expectEqualSlices(i32, &.{ 7, 8, 9 }, &xs);
}
