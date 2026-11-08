const std = @import("std");
const sol = @import("solution.zig");

test "простые слова" {
    try std.testing.expectEqual(@as(usize, 1), sol.countVowels("zig"));
    try std.testing.expectEqual(@as(usize, 2), sol.countVowels("hello"));
    try std.testing.expectEqual(@as(usize, 5), sol.countVowels("sequoia"));
}

test "без гласных и пустая" {
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels(""));
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels("rhythm"));
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels("12345 !?"));
}

test "регистр важен" {
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels("AEIOU"));
    try std.testing.expectEqual(@as(usize, 2), sol.countVowels("ZigZag"));
}

test "юникодные байты не гласные" {
    try std.testing.expectEqual(@as(usize, 0), sol.countVowels("мама"));
    try std.testing.expectEqual(@as(usize, 2), sol.countVowels("Дaння oк"));
}
