const std = @import("std");

/// Длина нуль-терминированной строки (без сентинела).
pub fn cStrLen(s: [*:0]const u8) usize {
    var n: usize = 0;
    while (s[n] != 0) n += 1;
    return n;
}

/// true, если C-строка a посимвольно равна слайсу b.
pub fn equalZigStr(a: [*:0]const u8, b: []const u8) bool {
    return std.mem.eql(u8, std.mem.span(a), b);
}
