const std = @import("std");

/// true, если строка начинается с заглавной 'Z'.
pub fn startsWithZ(s: []const u8) bool {
    return std.mem.startsWith(u8, s, "Z");
}

/// Последний байт строки; null, если строка пустая.
pub fn lastChar(s: []const u8) ?u8 {
    if (s.len == 0) return null;
    return s[s.len - 1];
}
