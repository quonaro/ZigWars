const std = @import("std");
const sol = @import("solution.zig");

var calls: usize = 0;

fn isBig(x: i32) bool {
    calls += 1;
    return x > 100;
}

fn isNeg(x: i32) bool {
    return x < 0;
}

fn alwaysTrue(_: i32) bool {
    return true;
}

fn runOnce(alloc: std.mem.Allocator, xs: []const i32) !void {
    const r = try sol.filterAlloc(alloc, xs, isNeg);
    alloc.free(r);
}

test "предикат вызывается хотя бы раз на элемент" {
    calls = 0;
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ 1, 150, 2, 200, 3 }, isBig);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 150, 200 }, got);
    try std.testing.expect(calls >= 5);
}

test "длина результата точная — без лишней ёмкости" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ -5, 0, -3, 9, -1 }, isNeg);
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 3), got.len);
    try std.testing.expectEqualSlices(i32, &.{ -5, -3, -1 }, got);
}

test "все элементы проходят — копия входа" {
    const alloc = std.testing.allocator;
    const got = try sol.filterAlloc(alloc, &.{ 7, -8, 9 }, alwaysTrue);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 7, -8, 9 }, got);
}

test "ни одной утечки ни на одном пути ошибок" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{ -1, 2, -3, 4 }},
    );
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{}},
    );
}
