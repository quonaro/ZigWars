const std = @import("std");
const sol = @import("solution.zig");

test "палиндром не меняется" {
    var xs = [_]i32{ 1, 2, 3, 2, 1 };
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2, 3, 2, 1 }, &xs);
}

test "симметричные пары на месте" {
    var xs = [_]i32{ 10, 20, 30, 40, 50, 60 };
    sol.reverseInPlace(&xs);
    try std.testing.expectEqualSlices(i32, &.{ 60, 50, 40, 30, 20, 10 }, &xs);
}

test "большой массив" {
    var buf: [128]i32 = undefined;
    for (&buf, 0..) |*x, i| x.* = @intCast(i);
    sol.reverseInPlace(&buf);
    for (buf, 0..) |x, i| {
        try std.testing.expectEqual(@as(i32, @intCast(127 - i)), x);
    }
}

test "подслайс переворачивается изолированно" {
    var xs = [_]i32{ 1, 2, 3, 4, 5, 6 };
    sol.reverseInPlace(xs[1..5]);
    try std.testing.expectEqualSlices(i32, &.{ 1, 5, 4, 3, 2, 6 }, &xs);
}
