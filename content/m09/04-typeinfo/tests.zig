const std = @import("std");
const sol = @import("solution.zig");

test "знаковые и беззнаковые целые" {
    try std.testing.expectEqualStrings("знаковое целое, 32 бит", sol.describe(i32));
    try std.testing.expectEqualStrings("знаковое целое, 8 бит", sol.describe(i8));
    try std.testing.expectEqualStrings("беззнаковое целое, 8 бит", sol.describe(u8));
    try std.testing.expectEqualStrings("беззнаковое целое, 64 бит", sol.describe(u64));
}

test "usize и isize — тоже целые" {
    try std.testing.expectEqualStrings("беззнаковое целое, 64 бит", sol.describe(usize));
    try std.testing.expectEqualStrings("знаковое целое, 64 бит", sol.describe(isize));
}

test "плавающие и bool" {
    try std.testing.expectEqualStrings("число с плавающей точкой, 32 бит", sol.describe(f32));
    try std.testing.expectEqualStrings("число с плавающей точкой, 64 бит", sol.describe(f64));
    try std.testing.expectEqualStrings("логический", sol.describe(bool));
}

test "слайсы и указатели" {
    try std.testing.expectEqualStrings("слайс на u8", sol.describe([]u8));
    try std.testing.expectEqualStrings("слайс на u8", sol.describe([]const u8));
    try std.testing.expectEqualStrings("слайс на i32", sol.describe([]const i32));
    try std.testing.expectEqualStrings("указатель на u8", sol.describe(*u8));
    try std.testing.expectEqualStrings("указатель на i32", sol.describe(*const i32));
}

test "прочие типы" {
    try std.testing.expectEqualStrings("другое: void", sol.describe(void));
    // Структуры и перечисления попадают в "другое" с именем от @typeName.
    const s = sol.describe(struct { x: i32 });
    try std.testing.expect(std.mem.startsWith(u8, s, "другое: "));
}
