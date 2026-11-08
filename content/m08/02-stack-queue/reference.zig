const std = @import("std");

/// Вычислить выражение в обратной польской нотации.
/// Деление усечённое (@divTrunc). Ошибки: InvalidExpression, DivisionByZero.
pub fn evalRPN(alloc: std.mem.Allocator, tokens: []const []const u8) !i64 {
    var stack: std.ArrayList(i64) = .empty;
    defer stack.deinit(alloc);

    for (tokens) |tok| {
        if (tok.len == 1 and (tok[0] == '+' or tok[0] == '-' or tok[0] == '*' or tok[0] == '/')) {
            const b = stack.pop() orelse return error.InvalidExpression;
            const a = stack.pop() orelse return error.InvalidExpression;
            const r: i64 = switch (tok[0]) {
                '+' => a + b,
                '-' => a - b,
                '*' => a * b,
                '/' => blk: {
                    if (b == 0) return error.DivisionByZero;
                    break :blk @divTrunc(a, b);
                },
                else => unreachable,
            };
            try stack.append(alloc, r);
        } else {
            const n = try std.fmt.parseInt(i64, tok, 10);
            try stack.append(alloc, n);
        }
    }

    if (stack.items.len != 1) return error.InvalidExpression;
    return stack.items[0];
}
