const std = @import("std");
const sol = @import("solution.zig");

test "пять квадратов в арене" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const a = arena.allocator();

    const got = try sol.buildLookup(a, 5);
    // free не делаем — арена освободит всё в deinit
    try std.testing.expectEqualSlices(usize, &.{ 0, 1, 4, 9, 16 }, got);
}

test "пустая таблица" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const got = try sol.buildLookup(arena.allocator(), 0);
    try std.testing.expectEqual(@as(usize, 0), got.len);
}

test "проверка по точкам для n=10" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const got = try sol.buildLookup(arena.allocator(), 10);
    try std.testing.expectEqual(@as(usize, 10), got.len);
    try std.testing.expectEqual(@as(usize, 49), got[7]);
    try std.testing.expectEqual(@as(usize, 81), got[9]);
}

test "арену можно грузить много раз" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const a = arena.allocator();
    const t1 = try sol.buildLookup(a, 3);
    const t2 = try sol.buildLookup(a, 4);
    // обе таблицы живы одновременно — арена держит все аллокации
    try std.testing.expectEqual(@as(usize, 4), t1[2]);
    try std.testing.expectEqual(@as(usize, 9), t2[3]);
}
