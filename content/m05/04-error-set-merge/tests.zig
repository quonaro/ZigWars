const std = @import("std");
const sol = @import("solution.zig");

test "валидные строки — сумма байт" {
    try std.testing.expectEqual(@as(u32, 97), try sol.validate("a"));
    try std.testing.expectEqual(@as(u32, 209), try sol.validate("hi"));
    try std.testing.expectEqual(@as(u32, 49), try sol.validate("1"));
    try std.testing.expectEqual(@as(u32, 97 * 8), try sol.validate("aaaaaaaa"));
}

test "Empty" {
    try std.testing.expectError(error.Empty, sol.validate(""));
    try std.testing.expectError(error.Empty, sol.validateInfer(""));
}

test "TooLong" {
    try std.testing.expectError(error.TooLong, sol.validate("123456789"));
    // длина проверяется раньше ASCII
    try std.testing.expectError(error.TooLong, sol.validate("12345678\xff\x00\xff"));
}

test "NotAscii" {
    try std.testing.expectError(error.NotAscii, sol.validate("\xff"));
    try std.testing.expectError(error.NotAscii, sol.validate("ok\x80"));
    try std.testing.expectError(error.NotAscii, sol.validateInfer("й"));
}

test "validateInfer повторяет validate" {
    try std.testing.expectEqual(try sol.validate("abc"), try sol.validateInfer("abc"));
    try std.testing.expectEqual(try sol.validate("z"), try sol.validateInfer("z"));
    // ошибки пробрасываются теми же именами
    const r = sol.validateInfer("123456789") catch |err| {
        try std.testing.expectEqualStrings("TooLong", @errorName(err));
        return;
    };
    _ = r;
    unreachable;
}
