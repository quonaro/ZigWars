const std = @import("std");
const sol = @import("solution.zig");

test "максимум целых" {
    try std.testing.expectEqual(7, sol.maxOf(@as(i32, 3), @as(i32, 7)));
    try std.testing.expectEqual(-2, sol.maxOf(@as(i32, -2), @as(i32, -9)));
    try std.testing.expectEqual(255, sol.maxOf(@as(u8, 200), @as(u8, 255)));
}

test "максимум дробных" {
    try std.testing.expectApproxEqAbs(2.5, sol.maxOf(@as(f64, 2.5), @as(f64, -1)), 1e-9);
    try std.testing.expectApproxEqAbs(-0.25, sol.maxOf(@as(f32, -0.5), @as(f32, -0.25)), 1e-6);
}

test "сумма одинаковых типов" {
    try std.testing.expectEqual(3, sol.add(@as(i32, 1), @as(i32, 2)));
    try std.testing.expectEqual(-5, sol.add(@as(i8, -2), @as(i8, -3)));
}

test "сумма смешанных типов" {
    const r1 = sol.add(@as(u8, 200), @as(u16, 100));
    try std.testing.expectEqual(300, r1);
    try std.testing.expectEqual(u16, @TypeOf(r1));

    const r2 = sol.add(@as(i32, 1), @as(f64, 0.5));
    try std.testing.expectApproxEqAbs(1.5, r2, 1e-9);
    try std.testing.expectEqual(f64, @TypeOf(r2));
}

test "тип результата выводится" {
    try std.testing.expectEqual(i32, @TypeOf(sol.maxOf(@as(i32, 0), @as(i32, 1))));
    try std.testing.expectEqual(f32, @TypeOf(sol.maxOf(@as(f32, 0), @as(f32, 1))));
}
