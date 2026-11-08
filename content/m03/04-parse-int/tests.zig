const std = @import("std");
const sol = @import("solution.zig");

test "обычные числа" {
    try std.testing.expectEqual(@as(u32, 42), try sol.parsePositive("42"));
    try std.testing.expectEqual(@as(u32, 1), try sol.parsePositive("1"));
    try std.testing.expectEqual(@as(u32, 4294967295), try sol.parsePositive("4294967295"));
}

test "ведущие нули и плюс" {
    try std.testing.expectEqual(@as(u32, 7), try sol.parsePositive("007"));
    try std.testing.expectEqual(@as(u32, 5), try sol.parsePositive("+5"));
}

test "ноль и нули — не положительные" {
    try std.testing.expectError(error.NotPositive, sol.parsePositive("0"));
    try std.testing.expectError(error.NotPositive, sol.parsePositive("000"));
}

test "мусор" {
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("abc"));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("12a"));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive(""));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive(" 12"));
}

test "переполнение и минус" {
    try std.testing.expectError(error.Overflow, sol.parsePositive("4294967296"));
    // "-7" для unsigned — Overflow: знак парсится, но не влезает в u32
    try std.testing.expectError(error.Overflow, sol.parsePositive("-7"));
}
