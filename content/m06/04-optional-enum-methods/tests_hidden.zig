const std = @import("std");
const sol = @import("solution.zig");
const Op = sol.Op;

test "деление на минус-ноль тоже null" {
    try std.testing.expectEqual(null, sol.apply(.div, 1, -0.0));
    try std.testing.expectEqual(null, sol.apply(.div, -3.5, -0.0));
}

test "почти операторы — не операторы" {
    // байты, соседние с '+' '*' '/', и буквы операторов
    for ([_]u8{ '(', ')', ',', '.', 'a', 's', 'm', 'd', '^', 0 }) |c| {
        try std.testing.expectEqual(null, Op.fromChar(c));
    }
}

test "каждый символ — ровно одна операция" {
    var found: usize = 0;
    for (0..256) |ci| {
        const c: u8 = @intCast(ci);
        if (Op.fromChar(c) != null) {
            found += 1;
            // round-trip: symbol возвращает ровно этот байт
            try std.testing.expectEqual(c, Op.fromChar(c).?.symbol());
        }
    }
    try std.testing.expectEqual(@as(usize, 4), found);
}

test "арифметика на краях" {
    try std.testing.expectApproxEqAbs(0.0, sol.apply(.add, -5, 5).?, 1e-9);
    try std.testing.expectApproxEqAbs(-12.0, sol.apply(.mul, -3, 4).?, 1e-9);
    try std.testing.expectApproxEqAbs(-12.0, sol.apply(.mul, 3, -4).?, 1e-9);
    try std.testing.expectApproxEqAbs(-0.25, sol.apply(.div, -1, 4).?, 1e-9);
    try std.testing.expectApproxEqAbs(0.5, sol.apply(.div, -1, -2).?, 1e-9);
}
