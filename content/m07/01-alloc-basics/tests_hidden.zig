const std = @import("std");
const sol = @import("solution.zig");

fn dupeFree(alloc: std.mem.Allocator, xs: []const i32) !void {
    const got = try sol.dupSlice(alloc, xs);
    alloc.free(got);
}

test "ни одной утечки ни на одном пути ошибок" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        dupeFree,
        .{&[_]i32{ 1, -2, 3, -4 }},
    );
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        dupeFree,
        .{&[_]i32{}},
    );
}

test "большой срез — проверяем каждый элемент" {
    const alloc = std.testing.allocator;
    var src: [512]i32 = undefined;
    for (&src, 0..) |*v, i| {
        v.* = @as(i32, @intCast(i)) * 37 - 9000;
    }
    const got = try sol.dupSlice(alloc, &src);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &src, got);
}

test "копия живёт в другой памяти" {
    const alloc = std.testing.allocator;
    const src = [_]i32{ 1, 2, 3 };
    const got = try sol.dupSlice(alloc, &src);
    defer alloc.free(got);
    try std.testing.expect(@intFromPtr(&src[0]) != @intFromPtr(got.ptr));
}

test "серия копий — все независимы и корректны" {
    const alloc = std.testing.allocator;
    const fixtures = [_][]const i32{
        &.{0},
        &.{ -1, 1 },
        &.{ 100, -200, 300, -400 },
        &.{std.math.minInt(i32), std.math.maxInt(i32)},
    };
    for (fixtures) |xs| {
        const got = try sol.dupSlice(alloc, xs);
        defer alloc.free(got);
        try std.testing.expectEqualSlices(i32, xs, got);
    }
}
