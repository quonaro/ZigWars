const std = @import("std");
const sol = @import("solution.zig");

test "граница u32" {
    try std.testing.expectEqual(@as(u32, 4_294_967_295), try sol.parsePositive("4294967295"));
    try std.testing.expectError(error.Overflow, sol.parsePositive("4294967296"));
    try std.testing.expectError(error.Overflow, sol.parsePositive("42949672950"));
    try std.testing.expectEqual(@as(u32, 2147483648), try sol.parsePositive("2147483648"));
}

test "подчёркивания разрешены" {
    try std.testing.expectEqual(@as(u32, 1000), try sol.parsePositive("1_000"));
    try std.testing.expectEqual(@as(u32, 1_000_000), try sol.parsePositive("1_000_000"));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("_5"));
}

test "ноль в разных видах — NotPositive" {
    try std.testing.expectError(error.NotPositive, sol.parsePositive("00"));
    try std.testing.expectError(error.NotPositive, sol.parsePositive("+0"));
    try std.testing.expectError(error.NotPositive, sol.parsePositive("0_0"));
}

test "хвосты и не-ASCII" {
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("5 "));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("7\xFF"));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("１２３"));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive("+"));
    try std.testing.expectError(error.InvalidCharacter, sol.parsePositive(" "));
}
