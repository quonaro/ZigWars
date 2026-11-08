const std = @import("std");
const sol = @import("solution.zig");

test "начало с Z" {
    try std.testing.expect(sol.startsWithZ("Zig"));
    try std.testing.expect(sol.startsWithZ("Z"));
    try std.testing.expect(!sol.startsWithZ("zig"));
    try std.testing.expect(!sol.startsWithZ("aZ"));
}

test "края: пустая и похожие строки" {
    try std.testing.expect(!sol.startsWithZ(""));
    try std.testing.expect(sol.startsWithZ("ZZZ"));
    try std.testing.expect(!sol.startsWithZ("zZ"));
}

test "последний байт" {
    try std.testing.expectEqual(@as(?u8, 'g'), sol.lastChar("zig"));
    try std.testing.expectEqual(@as(?u8, 'a'), sol.lastChar("a"));
    try std.testing.expectEqual(@as(?u8, '\n'), sol.lastChar("line\n"));
}

test "пустая строка даёт null" {
    try std.testing.expect(sol.lastChar("") == null);
}

test "юникод — это байты" {
    // "Даня" — 8 байт; последний байт 'я' = 0x8F
    try std.testing.expectEqual(@as(?u8, 0x8F), sol.lastChar("Даня"));
    try std.testing.expectEqual(@as(?u8, 0x91), sol.lastChar("ё"));
}
