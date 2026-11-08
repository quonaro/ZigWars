const std = @import("std");

/// Первая строчная гласная (a e i o u) в строке; иначе null.
pub fn firstVowel(s: []const u8) ?u8 {
    for (s) |c| {
        switch (c) {
            'a', 'e', 'i', 'o', 'u' => return c,
            else => {},
        }
    }
    return null;
}

/// Если a есть — a * 2, иначе null.
pub fn optChain(a: ?i32) ?i32 {
    return if (a) |v| v * 2 else null;
}
