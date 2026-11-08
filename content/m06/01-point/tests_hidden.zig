const std = @import("std");
const sol = @import("solution.zig");
const Point = sol.Point;

test "другие пифагоровы тройки" {
    const o = Point{ .x = 0, .y = 0 };
    try std.testing.expectApproxEqAbs(13.0, sol.distance(o, .{ .x = 5, .y = 12 }), 1e-9);
    try std.testing.expectApproxEqAbs(25.0, sol.distance(o, .{ .x = -7, .y = 24 }), 1e-9);
    try std.testing.expectApproxEqAbs(17.0, sol.distance(.{ .x = 1, .y = 1 }, .{ .x = 9, .y = 16 }), 1e-9);
}

test "расстояние не зависит от переноса" {
    const a = Point{ .x = 1.5, .y = -2.25 };
    const b = Point{ .x = -4.0, .y = 3.0 };
    const shift = Point{ .x = 100.0, .y = -50.0 };
    const d1 = sol.distance(a, b);
    const d2 = sol.distance(a.add(shift), b.add(shift));
    try std.testing.expectApproxEqAbs(d1, d2, 1e-9);
}

test "add коммутативен" {
    const a = Point{ .x = -3.25, .y = 7.5 };
    const b = Point{ .x = 10.0, .y = -0.5 };
    const ab = a.add(b);
    const ba = b.add(a);
    try std.testing.expectApproxEqAbs(ab.x, ba.x, 1e-12);
    try std.testing.expectApproxEqAbs(ab.y, ba.y, 1e-12);
}

test "add ассоциативен" {
    const a = Point{ .x = 1.25, .y = -2.5 };
    const b = Point{ .x = -0.75, .y = 4.0 };
    const c = Point{ .x = 6.5, .y = -1.0 };
    const l = a.add(b).add(c);
    const r = a.add(b.add(c));
    try std.testing.expectApproxEqAbs(l.x, r.x, 1e-12);
    try std.testing.expectApproxEqAbs(l.y, r.y, 1e-12);
}
