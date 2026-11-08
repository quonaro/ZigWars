const std = @import("std");
const sol = @import("solution.zig");

test "строки с пробелами и знаками" {
    try std.testing.expect(!sol.startsWithZ(" Zig"));
    try std.testing.expect(sol.startsWithZ("Z z"));
    try std.testing.expect(!sol.startsWithZ("Жаня"));
    try std.testing.expect(!sol.startsWithZ("1Z"));
}

test "последний байт — небуквы" {
    try std.testing.expectEqual(@as(?u8, '!'), sol.lastChar("wow!"));
    try std.testing.expectEqual(@as(?u8, ' '), sol.lastChar("trail "));
    try std.testing.expectEqual(@as(?u8, 0xA2), sol.lastChar("™"));
    try std.testing.expectEqual(@as(?u8, '9'), sol.lastChar("999"));
}

test "длина-1 и двухбайтовые литеры" {
    try std.testing.expectEqual(@as(?u8, 'x'), sol.lastChar("x"));
    try std.testing.expect(sol.startsWithZ("Zx"));
    try std.testing.expectEqual(@as(?u8, 0xAF), sol.lastChar("Я"));
    try std.testing.expectEqual(@as(?u8, 0x8F), sol.lastChar("я"));
}
