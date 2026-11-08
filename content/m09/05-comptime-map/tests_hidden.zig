const std = @import("std");
const sol = @import("solution.zig");

test "фибоначчи — начало таблицы по значениям" {
    const expected = [_]u64{ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377 };
    inline for (0..expected.len) |i| {
        try std.testing.expectEqual(expected[i], sol.fib(@as(u8, i)));
    }
}

test "фибоначчи — рекуррентное соотношение на всей таблице" {
    inline for (2..93) |i| {
        const a = comptime sol.fib(@as(u8, i - 1));
        const b = comptime sol.fib(@as(u8, i - 2));
        try std.testing.expectEqual(a + b, comptime sol.fib(@as(u8, i)));
    }
}

test "rangeSum — единичные и отрицательные диапазоны" {
    try std.testing.expectEqual(-5, sol.rangeSum(i32, -5, -5));
    try std.testing.expectEqual(410, sol.rangeSum(i64, -10, 30));
    try std.testing.expectEqual(7, sol.rangeSum(u8, 7, 7));
    try std.testing.expectEqual(-9, sol.rangeSum(i32, -9, -9));
}

test "rangeSum — разные целочисленные типы" {
    try std.testing.expectEqual(6, sol.rangeSum(u4, 1, 3));
    try std.testing.expectEqual(@as(i128, 5050), sol.rangeSum(i128, 1, 100));
    try std.testing.expectEqual(@as(usize, 210), sol.rangeSum(usize, 0, 20));
    try std.testing.expectEqual(0, sol.rangeSum(i8, 5, 0));
}
