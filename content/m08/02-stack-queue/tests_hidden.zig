const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

test "цепочки унарных операций" {
    try std.testing.expectEqual(@as(i64, 7), try sol.evalRPN(A, &.{ "1", "2", "3", "*", "+" }));
    try std.testing.expectEqual(@as(i64, -5), try sol.evalRPN(A, &.{ "1", "2", "-", "4", "-" }));
    try std.testing.expectEqual(@as(i64, -20), try sol.evalRPN(A, &.{ "2", "-5", "*", "2", "*" }));
}

test "деление — края" {
    try std.testing.expectEqual(@as(i64, -3), try sol.evalRPN(A, &.{ "7", "-2", "/" }));
    try std.testing.expectEqual(@as(i64, 0), try sol.evalRPN(A, &.{ "0", "5", "/" }));
    try std.testing.expectEqual(@as(i64, 0), try sol.evalRPN(A, &.{ "-1", "2", "/" }));
}

test "большие числа" {
    try std.testing.expectEqual(
        @as(i64, 6_000_000_000_000),
        try sol.evalRPN(A, &.{ "2000000", "3000000", "*" }),
    );
}

test "ошибка посреди выражения — тоже чисто и без паники" {
    // стек не пуст к моменту ошибки — ресурсы всё равно должны освободиться
    try std.testing.expectError(
        error.InvalidExpression,
        sol.evalRPN(A, &.{ "1", "2", "+", "-" }),
    );
    try std.testing.expectError(
        error.DivisionByZero,
        sol.evalRPN(A, &.{ "3", "1", "+", "0", "/" }),
    );
    // нечисловой мусор — ошибка parseInt (InvalidCharacter)
    try std.testing.expectError(
        error.InvalidCharacter,
        sol.evalRPN(A, &.{ "abc", "1", "+" }),
    );
    try std.testing.expectError(
        error.InvalidExpression,
        sol.evalRPN(A, &.{ "1", "2", "+", "5", "6" }),
    );
}
