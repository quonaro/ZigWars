const std = @import("std");

pub const ValidateError = error{ Empty, TooLong, NotAscii };

/// Валидирует строку, возвращает сумму байт.
/// Проверки по порядку: Empty → TooLong(>8) → NotAscii → сумма.
pub fn validate(s: []const u8) ValidateError!u32 {
    if (s.len == 0) return error.Empty;
    if (s.len > 8) return error.TooLong;
    var sum: u32 = 0;
    for (s) |c| {
        if (c > 127) return error.NotAscii;
        sum += c;
    }
    return sum;
}

/// Та же логика, error set выводится компилятором.
pub fn validateInfer(s: []const u8) !u32 {
    return validate(s);
}
