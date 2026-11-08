const std = @import("std");
const sol = @import("solution.zig");

test "базовая таблица" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{
        .{ "name", "zig" },
        .{ "ver", "0.17" },
    });
    defer alloc.free(s);
    try std.testing.expectEqualStrings("name | zig\nver  | 0.17\n", s);
}

test "одна строка" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{.{ "key", "value" }});
    defer alloc.free(s);
    try std.testing.expectEqualStrings("key | value\n", s);
}

test "разные длины ключей" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{
        .{ "a", "1" },
        .{ "bbbb", "2" },
        .{ "cc", "3" },
    });
    defer alloc.free(s);
    try std.testing.expectEqualStrings("a    | 1\nbbbb | 2\ncc   | 3\n", s);
}

test "пустой вход" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{});
    defer alloc.free(s);
    try std.testing.expectEqualStrings("", s);
}

test "пустые значения" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{.{ "k", "" }});
    defer alloc.free(s);
    try std.testing.expectEqualStrings("k | \n", s);
}
