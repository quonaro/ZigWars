const std = @import("std");

/// Парсит строго положительное десятичное число.
/// "0" -> error.NotPositive, мусор -> ошибки parseInt.
pub fn parsePositive(s: []const u8) !u32 {
    const n = try std.fmt.parseInt(u32, s, 10);
    if (n == 0) return error.NotPositive;
    return n;
}
