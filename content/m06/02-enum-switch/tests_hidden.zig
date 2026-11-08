const std = @import("std");
const sol = @import("solution.zig");
const Dir = sol.Dir;

const dirs = [_]Dir{ .north, .east, .south, .west };

test "четыре поворота — полный круг" {
    for (dirs) |d| {
        var cur = d;
        for (0..4) |_| cur = sol.turn(cur, .right);
        try std.testing.expectEqual(d, cur);

        cur = d;
        for (0..4) |_| cur = sol.turn(cur, .left);
        try std.testing.expectEqual(d, cur);
    }
}

test "градусы согласованы с поворотами — вся таблица" {
    for (dirs) |d| {
        const right = @mod(@as(i32, sol.toDegrees(d)) + 90, 360);
        const left = @mod(@as(i32, sol.toDegrees(d)) - 90, 360);
        try std.testing.expectEqual(@as(i32, @intCast(sol.toDegrees(sol.turn(d, .right)))), right);
        try std.testing.expectEqual(@as(i32, @intCast(sol.toDegrees(sol.turn(d, .left)))), left);
    }
}

test "три вправо равно одному влево" {
    for (dirs) |d| {
        var cur = d;
        for (0..3) |_| cur = sol.turn(cur, .right);
        try std.testing.expectEqual(sol.turn(d, .left), cur);
    }
}
