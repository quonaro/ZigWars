const std = @import("std");
const sol = @import("solution.zig");

const A = std.testing.allocator;

test "простые выражения" {
    try std.testing.expectEqual(@as(i64, 9), try sol.evalRPN(A, &.{ "2", "1", "+", "3", "*" }));
    try std.testing.expectEqual(@as(i64, 6), try sol.evalRPN(A, &.{ "4", "13", "5", "/", "+" }));
    try std.testing.expectEqual(@as(i64, 5), try sol.evalRPN(A, &.{"5"}));
}

test "классический пример с отрицательными" {
    try std.testing.expectEqual(@as(i64, 22), try sol.evalRPN(A, &.{
        "10", "6", "9", "3", "+", "-11", "*", "/", "*", "17", "+", "5", "+",
    }));
}

test "порядок операндов важен" {
    try std.testing.expectEqual(@as(i64, 2), try sol.evalRPN(A, &.{ "4", "2", "-" }));
    try std.testing.expectEqual(@as(i64, -3), try sol.evalRPN(A, &.{ "2", "4", "-", "1", "-" }));
}

test "усечённое деление отрицательного" {
    try std.testing.expectEqual(@as(i64, -3), try sol.evalRPN(A, &.{ "-7", "2", "/" }));
}

test "деление на ноль — ошибка" {
    try std.testing.expectError(error.DivisionByZero, sol.evalRPN(A, &.{ "4", "0", "/" }));
}

test "некорректные выражения" {
    try std.testing.expectError(error.InvalidExpression, sol.evalRPN(A, &.{"+"}));
    try std.testing.expectError(error.InvalidExpression, sol.evalRPN(A, &.{ "1", "+" }));
    try std.testing.expectError(error.InvalidExpression, sol.evalRPN(A, &.{ "1", "2", "3" }));
    try std.testing.expectError(error.InvalidExpression, sol.evalRPN(A, &.{}));
}
