const std = @import("std");

pub const ValidateError = error{ Empty, TooLong, NotAscii };

/// Валидирует строку, возвращает сумму байт.
/// Проверки по порядку: Empty → TooLong(>8) → NotAscii → сумма.
pub fn validate(s: []const u8) ValidateError!u32 {
    // TODO: три проверки по порядку, затем сумма байт
    _ = s;
    return 0;
}

/// Та же логика, error set выводится компилятором.
pub fn validateInfer(s: []const u8) !u32 {
    // TODO: одна строка — делегируй validate
    _ = s;
    return 0;
}
