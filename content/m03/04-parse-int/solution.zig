const std = @import("std");

/// Парсит строго положительное десятичное число.
/// "0" -> error.NotPositive, мусор -> ошибки parseInt.
pub fn parsePositive(s: []const u8) !u32 {
    // TODO
    _ = s;
    return error.InvalidCharacter;
}
