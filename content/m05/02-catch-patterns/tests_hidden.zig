const std = @import("std");
const sol = @import("solution.zig");

test "границы i64" {
    try std.testing.expectEqual(std.math.maxInt(i64), sol.parseOr("9223372036854775807", -1));
    try std.testing.expectEqual(std.math.minInt(i64), sol.parseOr("-9223372036854775808", -1));
    try std.testing.expectEqual(@as(i64, -1), sol.parseOr("9223372036854775808", -1));
    try std.testing.expectEqual(@as(i64, 5), sol.parseOr("-9223372036854775809", 5));
}

test "пробелы и знаки" {
    try std.testing.expectEqual(@as(i64, 9), sol.parseOr(" 42", 9));
    try std.testing.expectEqual(@as(i64, 9), sol.parseOr("42 ", 9));
    try std.testing.expectEqual(@as(i64, 42), sol.parseOr("+42", 9));
    try std.testing.expectEqual(@as(i64, -42), sol.parseOr("-42", 9));
    try std.testing.expectEqual(@as(i64, 9), sol.parseOr("+-42", 9));
    try std.testing.expectEqual(@as(i64, 9), sol.parseOr("42.0", 9));
}

test "parseOrZero совпадает с parseOr(s, 0)" {
    const inputs = [_][]const u8{ "777", "", "zzz", "-1", "9223372036854775808", "1_000" };
    for (inputs) |s| {
        try std.testing.expectEqual(sol.parseOr(s, 0), sol.parseOrZero(s));
    }
}
