const std = @import("std");
const sol = @import("solution.zig");

test "два слова" {
    const r = try sol.reverseWords(std.testing.allocator, "hello zig");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("zig hello", r);
}

test "одно слово и пустая строка" {
    const alloc = std.testing.allocator;
    const r1 = try sol.reverseWords(alloc, "solo");
    defer alloc.free(r1);
    try std.testing.expectEqualStrings("solo", r1);

    const r2 = try sol.reverseWords(alloc, "");
    defer alloc.free(r2);
    try std.testing.expectEqualStrings("", r2);
}

test "много слов" {
    const r = try sol.reverseWords(std.testing.allocator, "the quick brown fox");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("fox brown quick the", r);
}

test "лишние пробелы схлопываются" {
    const r = try sol.reverseWords(std.testing.allocator, "  alpha   beta  ");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("beta alpha", r);
}

test "юникодные слова" {
    const r = try sol.reverseWords(std.testing.allocator, "раз два три");
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("три два раз", r);
}
