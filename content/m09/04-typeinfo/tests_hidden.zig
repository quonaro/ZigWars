const std = @import("std");
const sol = @import("solution.zig");

test "нестандартная разрядность" {
    try std.testing.expectEqualStrings("знаковое целое, 16 бит", sol.describe(i16));
    try std.testing.expectEqualStrings("беззнаковое целое, 32 бит", sol.describe(u32));
    try std.testing.expectEqualStrings("беззнаковое целое, 128 бит", sol.describe(u128));
    try std.testing.expectEqualStrings("число с плавающей точкой, 16 бит", sol.describe(f16));
}

test "слайсы более сложных типов" {
    try std.testing.expectEqualStrings("слайс на i32", sol.describe([]i32));
    try std.testing.expectEqualStrings("слайс на bool", sol.describe([]const bool));
    // слайс слайсов: имя элемента — полное имя типа
    try std.testing.expectEqualStrings("слайс на []const u8", sol.describe([]const []const u8));
}

test "указатель на массив — не слайс" {
    try std.testing.expectEqualStrings("указатель на [4]u8", sol.describe(*const [4]u8));
    try std.testing.expectEqualStrings("указатель на i64", sol.describe(*i64));
}

test "прочие типы — enum, optional, error set" {
    const E = enum { a, b };
    const s = sol.describe(E);
    try std.testing.expect(std.mem.startsWith(u8, s, "другое: "));
    try std.testing.expect(std.mem.endsWith(u8, s, "E"));

    try std.testing.expectEqualStrings("другое: ?i32", sol.describe(?i32));
    try std.testing.expectEqualStrings("другое: void", sol.describe(void));
}
