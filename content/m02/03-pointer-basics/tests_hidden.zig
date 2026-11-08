const std = @import("std");
const sol = @import("solution.zig");

test "swap самого с собой" {
    var x: i32 = 7;
    sol.swap(&x, &x);
    try std.testing.expectEqual(@as(i32, 7), x);
    var neg: i32 = -3;
    sol.swap(&neg, &neg);
    try std.testing.expectEqual(@as(i32, -3), neg);
}

test "swap крайние значения" {
    var a: i32 = std.math.maxInt(i32);
    var b: i32 = std.math.minInt(i32);
    sol.swap(&a, &b);
    try std.testing.expectEqual(std.math.minInt(i32), a);
    try std.testing.expectEqual(std.math.maxInt(i32), b);
}

test "incAll дельта и большие значения" {
    var xs = [_]i32{ std.math.maxInt(i32) - 4, std.math.minInt(i32) + 2 };
    sol.incAll(&xs, 4);
    try std.testing.expectEqualSlices(i32, &.{ std.math.maxInt(i32), std.math.minInt(i32) + 6 }, &xs);
}

test "incAll на подслайсе" {
    var xs = [_]i32{ 1, 1, 1, 1 };
    sol.incAll(xs[1..3], 9);
    try std.testing.expectEqualSlices(i32, &.{ 1, 10, 10, 1 }, &xs);
    sol.incAll(&xs, -1);
    try std.testing.expectEqualSlices(i32, &.{ 0, 9, 9, 0 }, &xs);
}
