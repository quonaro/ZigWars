const std = @import("std");
const sol = @import("solution.zig");

test "работает на любом аллокаторе — не только арене" {
    // контракт: обычный Allocator; вызывающий волен освободить результат
    const alloc = std.testing.allocator;
    const got = try sol.buildLookup(alloc, 6);
    defer alloc.free(got);
    try std.testing.expectEqualSlices(usize, &.{ 0, 1, 4, 9, 16, 25 }, got);
}

test "n = 1" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const got = try sol.buildLookup(arena.allocator(), 1);
    try std.testing.expectEqualSlices(usize, &.{0}, got);
}

test "большое n — элементы независимо проверяемы" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const n = 1000;
    const got = try sol.buildLookup(arena.allocator(), n);
    try std.testing.expectEqual(n, got.len);
    for (got, 0..) |v, i| {
        try std.testing.expectEqual(i * i, v);
    }
}

test "таблицы от разных вызовов не пересекаются" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const a = arena.allocator();
    const t1 = try sol.buildLookup(a, 8);
    // вторая аллокация не должна перезаписать первую таблицу
    const t2 = try sol.buildLookup(a, 100);
    for (t1, 0..) |v, i| try std.testing.expectEqual(i * i, v);
    try std.testing.expectEqual(@as(usize, 99 * 99), t2[99]);
}
