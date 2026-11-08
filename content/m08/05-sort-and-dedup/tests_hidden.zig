const std = @import("std");
const sol = @import("solution.zig");

fn runOnce(alloc: std.mem.Allocator, xs: []const i32) !void {
    const r = try sol.uniqueSorted(alloc, xs);
    alloc.free(r);
}

test "один и два элемента" {
    const alloc = std.testing.allocator;
    const one = try sol.uniqueSorted(alloc, &.{42});
    defer alloc.free(one);
    try std.testing.expectEqualSlices(i32, &.{42}, one);

    const two = try sol.uniqueSorted(alloc, &.{ 2, 1 });
    defer alloc.free(two);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2 }, two);

    const same = try sol.uniqueSorted(alloc, &.{ 5, 5 });
    defer alloc.free(same);
    try std.testing.expectEqualSlices(i32, &.{5}, same);
}

test "экстремумы i32" {
    const alloc = std.testing.allocator;
    const got = try sol.uniqueSorted(alloc, &.{
        std.math.maxInt(i32), std.math.minInt(i32), 0, std.math.maxInt(i32),
    });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{
        std.math.minInt(i32), 0, std.math.maxInt(i32),
    }, got);
}

test "большой вход — свойства результата" {
    const alloc = std.testing.allocator;
    var src: [256]i32 = undefined;
    for (&src, 0..) |*v, i| {
        v.* = @as(i32, @intCast((i * 37 + 11) % 53)) - 26;
    }
    const got = try sol.uniqueSorted(alloc, &src);
    defer alloc.free(got);
    // 53 разных значения от -26 до 26
    try std.testing.expectEqual(@as(usize, 53), got.len);
    for (got[1..], 0..) |v, i| {
        try std.testing.expect(v > got[i]); // строго возрастает = без дублей
    }
    try std.testing.expectEqual(@as(i32, -26), got[0]);
    try std.testing.expectEqual(@as(i32, 26), got[got.len - 1]);
}

test "ни одной утечки ни на одном пути ошибок" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{ 3, 1, 3, 2, 1 }},
    );
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{}},
    );
}
