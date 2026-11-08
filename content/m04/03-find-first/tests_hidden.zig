const std = @import("std");
const sol = @import("solution.zig");

fn alwaysTrue(x: i32) bool {
    _ = x;
    return true;
}

fn alwaysFalse(x: i32) bool {
    _ = x;
    return false;
}

fn isMultipleOf10(x: i32) bool {
    return @rem(x, 10) == 0;
}

test "первый элемент при совпадении первого же" {
    try std.testing.expectEqual(@as(?i32, 3), sol.findFirst(&[_]i32{ 3, 9, 10 }, alwaysTrue));
    try std.testing.expectEqual(@as(?i32, -100), sol.findFirst(&[_]i32{ -100, 20, 30 }, isMultipleOf10));
}

test "никто не подходит" {
    try std.testing.expectEqual(@as(?i32, null), sol.findFirst(&[_]i32{ 3, 5, 7, 11 }, alwaysFalse));
    try std.testing.expectEqual(@as(?i32, null), sol.findFirst(&[_]i32{ 11, 21, 33 }, isMultipleOf10));
}

test "совпадение на последнем" {
    try std.testing.expectEqual(@as(?i32, 60), sol.findFirst(&[_]i32{ 1, 3, 5, 60 }, isMultipleOf10));
    try std.testing.expectEqual(@as(?i32, -40), sol.findFirst(&[_]i32{ 7, -40 }, isMultipleOf10));
}

test "поиск в таблице фикстур" {
    const cases = [_]struct { xs: []const i32, want: ?i32 }{
        .{ .xs = &.{ 1, 2, 30, 40 }, .want = 30 },
        .{ .xs = &.{ 5, 15, 25 }, .want = null },
        .{ .xs = &.{ 0 }, .want = 0 },
    };
    for (cases) |c| {
        try std.testing.expectEqual(c.want, sol.findFirst(c.xs, isMultipleOf10));
    }
}
