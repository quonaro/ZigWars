const std = @import("std");
const sol = @import("solution.zig");
const Op = sol.Op;

test "арифметика" {
    try std.testing.expectApproxEqAbs(7.0, sol.apply(.add, 3, 4).?, 1e-9);
    try std.testing.expectApproxEqAbs(-1.0, sol.apply(.sub, 3, 4).?, 1e-9);
    try std.testing.expectApproxEqAbs(12.0, sol.apply(.mul, 3, 4).?, 1e-9);
    try std.testing.expectApproxEqAbs(0.75, sol.apply(.div, 3, 4).?, 1e-9);
}

test "деление на ноль даёт null" {
    try std.testing.expectEqual(null, sol.apply(.div, 1, 0));
    try std.testing.expectEqual(null, sol.apply(.div, -5, 0));
    try std.testing.expect(sol.apply(.div, 1, 0.001) != null);
}

test "fromChar разбирает операторы" {
    try std.testing.expectEqual(Op.add, Op.fromChar('+'));
    try std.testing.expectEqual(Op.sub, Op.fromChar('-'));
    try std.testing.expectEqual(Op.mul, Op.fromChar('*'));
    try std.testing.expectEqual(Op.div, Op.fromChar('/'));
}

test "fromChar отвергает чужие символы" {
    for ([_]u8{ 'x', '0', ' ', '%', 255 }) |c| {
        try std.testing.expectEqual(null, Op.fromChar(c));
    }
}

test "symbol и fromChar обратны друг другу" {
    for ([_]u8{ '+', '-', '*', '/' }) |c| {
        const op = Op.fromChar(c).?;
        try std.testing.expectEqual(c, op.symbol());
    }
}
