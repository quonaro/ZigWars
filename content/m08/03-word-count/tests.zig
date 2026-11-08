const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

test "повторяющиеся слова" {
    try std.testing.expectEqual(@as(usize, 2), try sol.wordCount(A, "hello world hello"));
}

test "пустая строка и только пробелы" {
    try std.testing.expectEqual(@as(usize, 0), try sol.wordCount(A, ""));
    try std.testing.expectEqual(@as(usize, 0), try sol.wordCount(A, "   \t\n  "));
}

test "одно слово много раз" {
    try std.testing.expectEqual(@as(usize, 1), try sol.wordCount(A, "a a a a"));
}

test "разные разделители" {
    try std.testing.expectEqual(@as(usize, 2), try sol.wordCount(A, "x  \t y\nx"));
    try std.testing.expectEqual(@as(usize, 3), try sol.wordCount(A, "zig is fun"));
}

test "регистр имеет значение" {
    try std.testing.expectEqual(@as(usize, 3), try sol.wordCount(A, "Zig zig ZIG"));
}
