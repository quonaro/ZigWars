const std = @import("std");
const sol = @import("solution.zig");

fn isEven(x: i32) bool {
    return @mod(x, 2) == 0;
}

fn isPositive(x: i32) bool {
    return x > 0;
}

fn alwaysFalse(_: i32) bool {
    return false;
}

test "чётные" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ 1, 2, 3, 4, 5, 6 }, isEven);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 2, 4, 6 }, got);
}

test "положительные" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ -3, -1, 0, 2, 7, -9 }, isPositive);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 2, 7 }, got);
}

test "ничего не прошло" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ 1, 2, 3 }, alwaysFalse);
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "пустой вход" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{}, isEven);
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "все прошли — порядок сохранён" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ 9, 8, 7 }, isPositive);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 9, 8, 7 }, got);
}
