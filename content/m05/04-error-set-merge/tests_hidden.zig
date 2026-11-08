const std = @import("std");
const sol = @import("solution.zig");

test "граница длины ровно 8" {
    try std.testing.expectEqual(@as(u32, 'a' * 8), try sol.validate("aaaaaaaa"));
    try std.testing.expectError(error.TooLong, sol.validate("aaaaaaaaa"));
}

test "байт 127 валиден, 128 нет" {
    try std.testing.expectEqual(@as(u32, 127), try sol.validate("\x7f"));
    try std.testing.expectError(error.NotAscii, sol.validate("\x80"));
    try std.testing.expectError(error.NotAscii, sol.validate("abc\xC0"));
}

test "порядок ошибок при конфликтах" {
    // длинная не-ASCII — TooLong, а не NotAscii
    try std.testing.expectError(error.TooLong, sol.validate("\xff\xff\xff\xff\xff\xff\xff\xff\xff"));
    // пустая — только Empty
    try std.testing.expectError(error.Empty, sol.validate(""));
}

test "сумма байт как у эталонного подсчёта" {
    const inputs = [_][]const u8{ "z", "ZIG", "12.34", "abcdefgh", "\x00\x00", "a b c !" };
    for (inputs) |s| {
        var want: u32 = 0;
        for (s) |c| want += c;
        try std.testing.expectEqual(want, try sol.validate(s));
        try std.testing.expectEqual(want, try sol.validateInfer(s));
    }
}
