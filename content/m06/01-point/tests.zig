const std = @import("std");
const sol = @import("solution.zig");
const Point = sol.Point;

test "расстояние — треугольник 3-4-5" {
    const a = Point{ .x = 0, .y = 0 };
    const b = Point{ .x = 3, .y = 4 };
    try std.testing.expectApproxEqAbs(5.0, sol.distance(a, b), 1e-9);
}

test "расстояние до себя равно нулю" {
    const p = Point{ .x = -7.5, .y = 2.25 };
    try std.testing.expectApproxEqAbs(0.0, sol.distance(p, p), 1e-9);
}

test "расстояние симметрично" {
    const a = Point{ .x = -2, .y = 1 };
    const b = Point{ .x = 4, .y = -3 };
    try std.testing.expectApproxEqAbs(sol.distance(a, b), sol.distance(b, a), 1e-9);
    try std.testing.expectApproxEqAbs(std.math.sqrt(52.0), sol.distance(a, b), 1e-9);
}

test "add складывает координаты" {
    const p = Point{ .x = 1, .y = 2 };
    const q = p.add(.{ .x = 10, .y = -5 });
    try std.testing.expectApproxEqAbs(11.0, q.x, 1e-9);
    try std.testing.expectApproxEqAbs(-3.0, q.y, 1e-9);
}

test "add не мутирует self" {
    const p = Point{ .x = 3.5, .y = -1.5 };
    _ = p.add(.{ .x = 100, .y = 100 });
    try std.testing.expectApproxEqAbs(3.5, p.x, 1e-9);
    try std.testing.expectApproxEqAbs(-1.5, p.y, 1e-9);
}
