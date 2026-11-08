const std = @import("std");
const sol = @import("solution.zig");

test "числа Фибоначчи" {
    try std.testing.expectEqual(0, sol.fib(0));
    try std.testing.expectEqual(1, sol.fib(1));
    try std.testing.expectEqual(1, sol.fib(2));
    try std.testing.expectEqual(55, sol.fib(10));
    try std.testing.expectEqual(6765, sol.fib(20));
}

test "фибоначчи большой — край таблицы" {
    try std.testing.expectEqual(2880067194370816120, sol.fib(90));
    try std.testing.expectEqual(7540113804746346429, sol.fib(92));
}

test "суммы диапазонов i32" {
    try std.testing.expectEqual(55, sol.rangeSum(i32, 1, 10));
    try std.testing.expectEqual(0, sol.rangeSum(i32, 0, 0));
    try std.testing.expectEqual(-15, sol.rangeSum(i32, -5, -1));
    try std.testing.expectEqual(0, sol.rangeSum(i32, -5, 5));
}

test "суммы диапазонов разных типов" {
    try std.testing.expectEqual(5050, sol.rangeSum(u16, 1, 100));
    try std.testing.expectEqual(210, sol.rangeSum(u8, 0, 20));
    try std.testing.expectEqual(500000500000, sol.rangeSum(u64, 1, 1_000_000));
}

test "пустой диапазон" {
    try std.testing.expectEqual(0, sol.rangeSum(i32, 5, 3));
    try std.testing.expectEqual(0, sol.rangeSum(u8, 10, 0));
}
