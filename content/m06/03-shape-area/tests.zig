const std = @import("std");
const sol = @import("solution.zig");
const Shape = sol.Shape;

test "площадь круга" {
    try std.testing.expectApproxEqAbs(std.math.pi, sol.area(.{ .circle = 1 }), 1e-9);
    try std.testing.expectApproxEqAbs(4 * std.math.pi, sol.area(.{ .circle = 2 }), 1e-9);
}

test "площадь прямоугольника" {
    const s = Shape{ .rect = .{ .w = 3, .h = 4 } };
    try std.testing.expectApproxEqAbs(12.0, sol.area(s), 1e-9);
    try std.testing.expectApproxEqAbs(7.5, sol.area(.{ .rect = .{ .w = 2.5, .h = 3 } }), 1e-9);
}

test "площадь квадрата" {
    try std.testing.expectApproxEqAbs(25.0, sol.area(.{ .square = 5 }), 1e-9);
    try std.testing.expectApproxEqAbs(0.0, sol.area(.{ .square = 0 }), 1e-9);
}

test "квадрат 2x2 и прямоугольник 2x2 совпадают" {
    const sq = Shape{ .square = 2 };
    const rc = Shape{ .rect = .{ .w = 2, .h = 2 } };
    try std.testing.expectApproxEqAbs(sol.area(rc), sol.area(sq), 1e-9);
}
