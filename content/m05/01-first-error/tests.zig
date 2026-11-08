const std = @import("std");
const sol = @import("solution.zig");

test "успешное деление" {
    try std.testing.expectEqual(@as(i32, 5), try sol.divide(10, 2));
    try std.testing.expectEqual(@as(i32, -3), try sol.divide(-7, 2));
    try std.testing.expectEqual(@as(i32, 0), try sol.divide(0, 9));
}

test "деление на ноль — ошибка" {
    try std.testing.expectError(error.DivisionByZero, sol.divide(1, 0));
    try std.testing.expectError(error.DivisionByZero, sol.divide(-42, 0));
}

test "catch как значение" {
    const ok = sol.divide(8, 4) catch -1;
    const bad = sol.divide(8, 0) catch -1;
    try std.testing.expectEqual(@as(i32, 2), ok);
    try std.testing.expectEqual(@as(i32, -1), bad);
}

test "ошибка пробрасывается try" {
    const helper = struct {
        fn call() error{DivisionByZero}!i32 {
            return try sol.divide(5, 0);
        }
    }.call;
    try std.testing.expectError(error.DivisionByZero, helper());
}
