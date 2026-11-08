const std = @import("std");
const sol = @import("solution.zig");

test "сплошные гласные и повторы" {
    try std.testing.expectEqual(@as(usize, 10), sol.countVowels("aeiouaeiou"));
    const hundred_a: [100]u8 = @splat('a');
    try std.testing.expectEqual(@as(usize, 100), sol.countVowels(&hundred_a));
    var fifty_ab: [100]u8 = undefined;
    for (&fifty_ab, 0..) |*c, i| c.* = if (i % 2 == 0) 'a' else 'b';
    try std.testing.expectEqual(@as(usize, 50), sol.countVowels(&fifty_ab));
}

test "соседние по таблице байты не гласные" {
    // 'u' гласная; '`', 'v', 'f', 'j', 'p', 'y', 'z' — нет
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels("`v fjpyz"));
    try std.testing.expectEqual(@as(usize, 1), sol.countVowels("u"));
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels("y"));
}

test "смешанная строка" {
    try std.testing.expectEqual(@as(usize, 11), sol.countVowels("the quick brown fox jumps over the lazy dog"));
    try std.testing.expectEqual(@as(usize, 2), sol.countVowels("  a  e  "));
    try std.testing.expectEqual(@as(usize, 4), sol.countVowels("0xDeadBeef"));
}
