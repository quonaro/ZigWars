const std = @import("std");
const sol = @import("solution.zig");

test "гласная на краях строки" {
    try std.testing.expectEqual(@as(?u8, 'a'), sol.firstVowel("abbbb"));
    try std.testing.expectEqual(@as(?u8, 'u'), sol.firstVowel("bbbu"));
    try std.testing.expectEqual(@as(?u8, 'o'), sol.firstVowel("zo"));
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("zO"));
}

test "пропуски и нелатиница" {
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("xYz"));
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("!!!"));
    try std.testing.expectEqual(@as(?u8, 'e'), sol.firstVowel("Мама" ++ "e"));
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("яюэ"));
}

test "optChain сохраняет знак и null" {
    try std.testing.expectEqual(@as(?i32, -2000), sol.optChain(-1000));
    try std.testing.expectEqual(@as(?i32, 2000), sol.optChain(1000));
    try std.testing.expectEqual(@as(?i32, std.math.maxInt(i32) - 1), sol.optChain((std.math.maxInt(i32) - 1) / 2));
    try std.testing.expectEqual(@as(?i32, null), sol.optChain(null));
}
