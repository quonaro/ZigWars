const std = @import("std");

/// Количество строчных ASCII-гласных (a e i o u) в строке.
pub fn countVowels(s: []const u8) usize {
    var count: usize = 0;
    for (s) |byte| {
        count += switch (byte) {
            'a', 'e', 'i', 'o', 'u' => 1,
            else => 0,
        };
    }
    return count;
}
