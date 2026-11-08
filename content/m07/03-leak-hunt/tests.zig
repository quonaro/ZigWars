const std = @import("std");
const sol = @import("solution.zig");

test "дубликаты схлопываются" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{ 3, 3, 1, 2, 2 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2, 3 }, got);
}

test "все одинаковые" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{ 5, 5, 5 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{5}, got);
}

test "пустой вход" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{});
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "без дубликатов" {
    const alloc = std.testing.allocator;
    const got = try sol.dedupCopy(alloc, &.{ 9, 1, 4 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 1, 4, 9 }, got);
}

fn runOnce(alloc: std.mem.Allocator, xs: []const i32) !void {
    const r = try sol.dedupCopy(alloc, xs);
    alloc.free(r);
}

test "ни одного утечки ни на одном пути ошибок" {
    // по очереди валится каждая аллокация — проверяем, что память чиста всегда
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        runOnce,
        .{&[_]i32{ 4, 4, 1, 7, 7, 2 }},
    );
}
