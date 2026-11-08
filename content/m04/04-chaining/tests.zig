const std = @import("std");
const sol = @import("solution.zig");

test "firstVowel: находит" {
    try std.testing.expectEqual(@as(?u8, 'i'), sol.firstVowel("zig"));
    try std.testing.expectEqual(@as(?u8, 'e'), sol.firstVowel("hello"));
    try std.testing.expectEqual(@as(?u8, 'a'), sol.firstVowel("bca"));
}

test "firstVowel: именно первая" {
    try std.testing.expectEqual(@as(?u8, 'e'), sol.firstVowel("eaio"));
    try std.testing.expectEqual(@as(?u8, 'o'), sol.firstVowel("xyzou"));
}

test "firstVowel: не находит" {
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("bcdfg"));
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel(""));
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("APPLE"));
    try std.testing.expectEqual(@as(?u8, null), sol.firstVowel("123"));
}

test "optChain" {
    try std.testing.expectEqual(@as(?i32, 42), sol.optChain(21));
    try std.testing.expectEqual(@as(?i32, null), sol.optChain(null));
    try std.testing.expectEqual(@as(?i32, -10), sol.optChain(-5));
    try std.testing.expectEqual(@as(?i32, 0), sol.optChain(0));
}
