const std = @import("std");

/// Число из строки s; при ошибке парсинга — default.
pub fn parseOr(s: []const u8, default: i64) i64 {
    // TODO: std.fmt.parseInt(i64, s, 10) catch default
    _ = s;
    _ = default;
    return 0;
}

/// То же, но с нулём. Через parseOr.
pub fn parseOrZero(s: []const u8) i64 {
    // TODO: одна строка — вызов parseOr
    _ = s;
    return 0;
}
