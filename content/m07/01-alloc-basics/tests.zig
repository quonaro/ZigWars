const std = @import("std");
const sol = @import("solution.zig");

test "копия обычного среза" {
    const alloc = std.testing.allocator;
    const got = try sol.dupSlice(alloc, &.{ 1, 2, 3 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ 1, 2, 3 }, got);
}

test "копия независима от оригинала" {
    const alloc = std.testing.allocator;
    var src = [_]i32{ 10, 20, 30 };
    const got = try sol.dupSlice(alloc, &src);
    defer alloc.free(got);
    src[0] = -999; // меняем оригинал — копия не должна заметить
    try std.testing.expectEqual(@as(i32, 10), got[0]);
}

test "пустой срез" {
    const alloc = std.testing.allocator;
    const got = try sol.dupSlice(alloc, &.{});
    defer alloc.free(got);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "отрицательные и большие значения" {
    const alloc = std.testing.allocator;
    const got = try sol.dupSlice(alloc, &.{ -2_000_000_000, 0, 2_000_000_000 });
    defer alloc.free(got);
    try std.testing.expectEqualSlices(i32, &.{ -2_000_000_000, 0, 2_000_000_000 }, got);
}
