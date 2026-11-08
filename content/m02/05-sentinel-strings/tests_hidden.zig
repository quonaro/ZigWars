const std = @import("std");
const sol = @import("solution.zig");

test "длинная строка" {
    var buf: [64:0]u8 = @splat('a');
    try std.testing.expectEqual(@as(usize, 64), sol.cStrLen(&buf));
    try std.testing.expectEqual(@as(usize, 0), sol.cStrLen(""));
    // та же строка, но с хвостом нулей внутри буфера не бывает — длина строго до '\0'
    buf[10] = 0;
    try std.testing.expectEqual(@as(usize, 10), sol.cStrLen(&buf));
}

test "юникод — длина в байтах" {
    // "привет" — 12 байт UTF-8, "€" — 3 байта
    try std.testing.expectEqual(@as(usize, 12), sol.cStrLen("привет"));
    try std.testing.expectEqual(@as(usize, 3), sol.cStrLen("€"));
    try std.testing.expectEqual(@as(usize, 21), sol.cStrLen("Привет, Зиг!"));
}

test "equalZigStr с юникодом и пробелами" {
    try std.testing.expect(sol.equalZigStr("Привет, Зиг!", "Привет, Зиг!"));
    try std.testing.expect(!sol.equalZigStr("Привет, Зиг!", "Привет, Зиг"));
    try std.testing.expect(sol.equalZigStr("  ", "  "));
    try std.testing.expect(!sol.equalZigStr("a b", "a  b"));
    try std.testing.expect(!sol.equalZigStr("€", "euro"));
}

test "equalZigStr срез C-строки" {
    const word = "zigwars";
    try std.testing.expect(sol.equalZigStr(word, word[0..7]));
    try std.testing.expect(!sol.equalZigStr(word, word[0..6]));
    try std.testing.expect(sol.equalZigStr("wars", word[3..7]));
}
