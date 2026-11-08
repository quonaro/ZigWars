const std = @import("std");
const sol = @import("solution.zig");

test "пустой ключ дополняется до ширины" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{
        .{ "", "v" },
        .{ "ab", "w" },
    });
    defer alloc.free(s);
    try std.testing.expectEqualStrings("   | v\nab | w\n", s);
}

test "значение содержит разделитель |" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{
        .{ "a", "x | y" },
    });
    defer alloc.free(s);
    try std.testing.expectEqualStrings("a | x | y\n", s);
}

test "одинаковые ключи — без паддинга" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{
        .{ "kk", "1" },
        .{ "kk", "2" },
        .{ "kk", "3" },
    });
    defer alloc.free(s);
    try std.testing.expectEqualStrings("kk | 1\nkk | 2\nkk | 3\n", s);
}

test "финальный перевод строки у каждой строки" {
    const alloc = std.testing.allocator;
    const s = try sol.renderTable(alloc, &.{
        .{ "key", "value" },
        .{ "longer", "v2" },
    });
    defer alloc.free(s);
    try std.testing.expect(s.len > 0);
    try std.testing.expectEqual(@as(u8, '\n'), s[s.len - 1]);
    try std.testing.expectEqual(@as(usize, 2), std.mem.count(u8, s, "\n"));
    // ровно один ' | ' разделитель на строку
    try std.testing.expectEqual(@as(usize, 2), std.mem.count(u8, s, " | "));
}

test "много строк и длинные значения" {
    const alloc = std.testing.allocator;
    const rows = [_][2][]const u8{
        .{ "i", "v" },
        .{ "medium", "x" },
        .{ "the-longest-key", "y" },
    };
    const s = try sol.renderTable(alloc, &rows);
    defer alloc.free(s);
    // ширина 15 + " | " → '|' всегда на позиции 16
    var it = std.mem.splitScalar(u8, s, '\n');
    const l1 = it.next().?;
    try std.testing.expect(std.mem.startsWith(u8, l1, "i"));
    try std.testing.expectEqual(@as(usize, 16), std.mem.indexOfScalar(u8, l1, '|').?);
    try std.testing.expect(std.mem.endsWith(u8, l1, "| v"));

    const l2 = it.next().?;
    try std.testing.expect(std.mem.startsWith(u8, l2, "medium"));
    try std.testing.expectEqual(@as(usize, 16), std.mem.indexOfScalar(u8, l2, '|').?);
    try std.testing.expect(std.mem.endsWith(u8, l2, "| x"));

    const l3 = it.next().?;
    try std.testing.expect(std.mem.startsWith(u8, l3, "the-longest-key"));
    try std.testing.expectEqual(@as(usize, 16), std.mem.indexOfScalar(u8, l3, '|').?);
    try std.testing.expect(std.mem.endsWith(u8, l3, "| y"));

    try std.testing.expectEqualStrings("", it.next().?);
    try std.testing.expectEqual(null, it.next());
}
