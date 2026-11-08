const std = @import("std");
const sol = @import("solution.zig");

test "базовая карточка" {
    const r = try sol.fmtUser(std.testing.allocator, "Даня", 25, 98.5);
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("Даня, 25 лет, счёт 98.50", r);
}

test "целый счёт дополняется нулями" {
    const r = try sol.fmtUser(std.testing.allocator, "Аня", 30, 100);
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("Аня, 30 лет, счёт 100.00", r);
}

test "округление до двух знаков" {
    const r = try sol.fmtUser(std.testing.allocator, "Zig", 1, 0.125);
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings("Zig, 1 лет, счёт 0.13", r);
}

test "нулевые значения" {
    const r = try sol.fmtUser(std.testing.allocator, "", 0, 0);
    defer std.testing.allocator.free(r);
    try std.testing.expectEqualStrings(", 0 лет, счёт 0.00", r);
}

test "несколько пользователей подряд" {
    const alloc = std.testing.allocator;
    const a = try sol.fmtUser(alloc, "Кей", 7, 3.14159);
    defer alloc.free(a);
    const b = try sol.fmtUser(alloc, "Ди", 99, 7.5);
    defer alloc.free(b);
    try std.testing.expectEqualStrings("Кей, 7 лет, счёт 3.14", a);
    try std.testing.expectEqualStrings("Ди, 99 лет, счёт 7.50", b);
}
