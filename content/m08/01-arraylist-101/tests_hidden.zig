const std = @import("std");
const sol = @import("solution.zig");

fn runOnce(alloc: std.mem.Allocator, n: usize) !void {
    const r = try sol.squares(alloc, n);
    alloc.free(r);
}

test "каждый элемент — программно" {
    const alloc = std.testing.allocator;
    const got = try sol.squares(alloc, 200);
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 200), got.len);
    for (got, 0..) |v, i| {
        try std.testing.expectEqual(@as(u64, @intCast(i * i)), v);
    }
}

test "два вызова независимы" {
    const alloc = std.testing.allocator;
    const a = try sol.squares(alloc, 5);
    defer alloc.free(a);
    const b = try sol.squares(alloc, 8);
    defer alloc.free(b);
    // вторая аллокация не должна повредить первую
    try std.testing.expectEqualSlices(u64, &.{ 0, 1, 4, 9, 16 }, a);
    try std.testing.expectEqual(@as(u64, 49), b[7]);
}

test "ни одной утечки ни на одном пути ошибок" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{@as(usize, 10)},
    );
}

test "n = 2" {
    const alloc = std.testing.allocator;
    const got = try sol.squares(alloc, 2);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(u64, &.{ 0, 1 }, got);
}
