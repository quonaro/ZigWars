const std = @import("std");
const sol = @import("solution.zig");

test "факториалы — вся таблица 0..20" {
    const expected = [_]u64{
        1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880,
        3628800, 39916800, 479001600, 6227020800, 87178291200,
        1307674368000, 20922789888000, 355687428096000, 6402373705728000,
        121645100408832000, 2432902008176640000,
    };
    inline for (0..21) |i| {
        try std.testing.expectEqual(expected[i], sol.comptimeFactorial(@as(u32, i)));
    }
}

test "квадраты — сетка значений" {
    try std.testing.expectEqual(4, sol.comptimeSquare(2));
    try std.testing.expectEqual(10201, sol.comptimeSquare(101));
    try std.testing.expectEqual(4294836225, sol.comptimeSquare(65535));
}

test "обе функции — истинно comptime" {
    const arr = [_]u8{ comptime sol.comptimeSquare(7), comptime sol.comptimeSquare(7), comptime sol.comptimeSquare(7), comptime sol.comptimeSquare(7) };
    for (arr) |v| try std.testing.expectEqual(49, v);
    const f = comptime sol.comptimeFactorial(9);
    try std.testing.expectEqual(362880, f);
}

test "факториал через соседа — соотношение n! = n*(n-1)!" {
    inline for (3..21) |n| {
        const cur: u64 = comptime sol.comptimeFactorial(@as(u32, n));
        const prev: u64 = comptime sol.comptimeFactorial(@as(u32, n - 1));
        try std.testing.expectEqual(prev * n, cur);
    }
}
