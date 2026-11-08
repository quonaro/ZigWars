const std = @import("std");
const sol = @import("solution.zig");

fn runOnce(alloc: std.mem.Allocator, xs: []const i32) !void {
    const r = try sol.dedupCopy(alloc, xs);
    alloc.free(r);
}

test "уже отсортированный вход без дублей" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{ -5, -1, 0, 42 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ -5, -1, 0, 42 }, got);
}

test "обратный порядок и разнесённые дубли" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{ 9, 4, 4, 1, 9, 1 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 1, 4, 9 }, got);
}

test "один элемент" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{-7});
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{-7}, got);
}

test "чередование без подряд идущих дублей" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{ 1, 2, 1, 2 });
    defer alloc.free(got);
    // после сортировки [1,1,2,2] -> [1,2]
    try std.testing.expectEqualSlices(i32, &.{ 1, 2 }, got);
}

test "чисто по памяти при любом падении — разные входы" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{ 3, 3, 3, 1 }},
    );
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{}},
    );
}
