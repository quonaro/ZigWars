const std = @import("std");
const sol = @import("solution.zig");

test "валидные числа" {
    try std.testing.expectEqual(@as(i64, 42), sol.parseOr("42", -1));
    try std.testing.expectEqual(@as(i64, -7), sol.parseOr("-7", 0));
    try std.testing.expectEqual(@as(i64, 0), sol.parseOr("0", 99));
    try std.testing.expectEqual(@as(i64, 123456789012345), sol.parseOr("123456789012345", -1));
}

test "мусор — default" {
    try std.testing.expectEqual(@as(i64, -1), sol.parseOr("abc", -1));
    try std.testing.expectEqual(@as(i64, 5), sol.parseOr("", 5));
    try std.testing.expectEqual(@as(i64, 7), sol.parseOr("12x", 7));
    try std.testing.expectEqual(@as(i64, -1), sol.parseOr("--5", -1));
}

test "переполнение — тоже default" {
    try std.testing.expectEqual(@as(i64, 7), sol.parseOr("99999999999999999999", 7));
    try std.testing.expectEqual(@as(i64, -1), sol.parseOr("-99999999999999999999", -1));
}

test "parseOrZero" {
    try std.testing.expectEqual(@as(i64, 55), sol.parseOrZero("55"));
    try std.testing.expectEqual(@as(i64, 0), sol.parseOrZero("nope"));
    try std.testing.expectEqual(@as(i64, 0), sol.parseOrZero(""));
    try std.testing.expectEqual(@as(i64, -13), sol.parseOrZero("-13"));
}
