const std = @import("std");
const sol = @import("solution.zig");

test "первые пять квадратов" {
    const alloc = std.testing.allocator;
    const got = try sol.squares(alloc, 5);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(u64, &.{ 0, 1, 4, 9, 16 }, got);
}

test "ноль элементов" {
    const alloc = std.testing.allocator;
    const got = try sol.squares(alloc, 0);
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "один элемент" {
    const alloc = std.testing.allocator;
    const got = try sol.squares(alloc, 1);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(u64, &.{0}, got);
}

test "большой n — проверяем конец" {
    const alloc = std.testing.allocator;
    const got = try sol.squares(alloc, 1000);
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 1000), got.len);
    try std.testing.expectEqual(@as(u64, 998001), got[999]);
    try std.testing.expectEqual(@as(u64, 49), got[7]);
}
