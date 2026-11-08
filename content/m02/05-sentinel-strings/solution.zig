const std = @import("std");

/// Длина нуль-терминированной строки (без сентинела).
pub fn cStrLen(s: [*:0]const u8) usize {
    // TODO
    _ = s;
    return 0;
}

/// true, если C-строка a посимвольно равна слайсу b.
pub fn equalZigStr(a: [*:0]const u8, b: []const u8) bool {
    // TODO
    _ = a;
    _ = b;
    return false;
}
