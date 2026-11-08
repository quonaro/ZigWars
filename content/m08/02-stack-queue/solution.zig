const std = @import("std");

/// Вычислить выражение в обратной польской нотации.
/// Деление усечённое (@divTrunc). Ошибки: InvalidExpression, DivisionByZero.
pub fn evalRPN(alloc: std.mem.Allocator, tokens: []const []const u8) !i64 {
    // TODO
    _ = alloc;
    _ = tokens;
    return error.InvalidExpression;
}
