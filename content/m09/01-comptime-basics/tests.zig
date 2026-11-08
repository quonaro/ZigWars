const std = @import("std");
const sol = @import("solution.zig");

test "квадраты" {
    try std.testing.expectEqual(81, sol.comptimeSquare(9));
    try std.testing.expectEqual(0, sol.comptimeSquare(0));
    try std.testing.expectEqual(1, sol.comptimeSquare(1));
    try std.testing.expectEqual(1048576, sol.comptimeSquare(1024));
}

test "факториалы маленьких чисел" {
    try std.testing.expectEqual(1, sol.comptimeFactorial(0));
    try std.testing.expectEqual(1, sol.comptimeFactorial(1));
    try std.testing.expectEqual(2, sol.comptimeFactorial(2));
    try std.testing.expectEqual(120, sol.comptimeFactorial(5));
    try std.testing.expectEqual(3628800, sol.comptimeFactorial(10));
}

test "факториал большой" {
    try std.testing.expectEqual(2432902008176640000, sol.comptimeFactorial(20));
}

test "результат — comptime-константа" {
    // Если функция не comptime-вычисляема, этот тест просто не скомпилируется.
    const sq = comptime sol.comptimeSquare(12);
    try std.testing.expectEqual(144, sq);
    const f = comptime sol.comptimeFactorial(7);
    try std.testing.expectEqual(5040, f);
}
