const std = @import("std");
const sol = @import("solution.zig");

test "дубли и порядок" {
    const alloc = std.testing.allocator;
    const got = try sol.uniqueSorted(alloc, &.{ 4, 2, 4, 1, 2 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2, 4 }, got);
}

test "все одинаковые" {
    const alloc = std.testing.allocator;
    const got = try sol.uniqueSorted(alloc, &.{ 7, 7, 7 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{7}, got);
}

test "пусто" {
    const alloc = std.testing.allocator;
    const got = try sol.uniqueSorted(alloc, &.{});
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "уже уникальные — просто сортировка" {
    const alloc = std.testing.allocator;
    const got = try sol.uniqueSorted(alloc, &.{ 9, -3, 0, -3, 5 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ -3, 0, 5, 9 }, got);
}

test "вход не мутируется" {
    const alloc = std.testing.allocator;
    var src = [_]i32{ 3, 1, 3, 2 };
    const got = try sol.uniqueSorted(alloc, &src);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 3, 1, 3, 2 }, &src);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2, 3 }, got);
}
