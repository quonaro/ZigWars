const std = @import("std");
const sol = @import("solution.zig");
const Shape = sol.Shape;

test "площадь круга растёт квадратично" {
    const r1 = sol.area(.{ .circle = 3 });
    const r2 = sol.area(.{ .circle = 6 });
    try std.testing.expectApproxEqAbs(4 * r1, r2, 1e-9);
}

test "нулевые размеры — нулевая площадь" {
    try std.testing.expectApproxEqAbs(0.0, sol.area(.{ .circle = 0 }), 1e-9);
    try std.testing.expectApproxEqAbs(0.0, sol.area(.{ .rect = .{ .w = 7, .h = 0 } }), 1e-9);
    try std.testing.expectApproxEqAbs(0.0, sol.area(.{ .rect = .{ .w = 0, .h = 0 } }), 1e-9);
}

test "площадь прямоугольника симметрична" {
    const a = Shape{ .rect = .{ .w = 2.5, .h = 6 } };
    const b = Shape{ .rect = .{ .w = 6, .h = 2.5 } };
    try std.testing.expectApproxEqAbs(sol.area(a), sol.area(b), 1e-9);
    try std.testing.expectApproxEqAbs(15.0, sol.area(a), 1e-9);
}

test "квадрат со стороной как у круга-радиуса" {
    // square(r) = r^2, circle(r) = pi*r^2 — отношение ровно pi
    const c = sol.area(.{ .circle = 5 });
    const s = sol.area(.{ .square = 5 });
    try std.testing.expectApproxEqAbs(std.math.pi, c / s, 1e-9);
}
